import 'package:dio/dio.dart';
import 'app_controller.dart';
import 'token_interceptor.dart';

class ApiService {
  late final Dio _dio;
  String devBaseUrl = 'http://0.0.0.0:8000';
  String prodBaseUrl = 'https://isapi-app.greensmoke-3681ba3b.koreacentral.azurecontainerapps.io';

  ApiService._internal() {
    _dio = Dio(BaseOptions(
      // baseUrl: 'http://192.168.45.237:8000', // 변경 가능
      baseUrl: AppController.to.isProd.value ? prodBaseUrl : devBaseUrl, // 변경 가능
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
      headers: {
        'Content-Type': 'application/json',
      },
      // 4xx도 Response로 받게 해서 body를 읽을 수 있게 함
      validateStatus: (s) => s != null && s < 500,
    ));

    _dio.interceptors.add(TokenInterceptor()); // 토큰 자동 추가
  }

  static final ApiService _instance = ApiService._internal();

  factory ApiService() => _instance;

  Dio get client => _dio;

  Future<Response> get(String path, {Map<String, dynamic>? query}) async {
    return _dio.get(path, queryParameters: query);
  }
  // file download
  Future<Response> get2(String path) async {
    return _dio.get<List<int>>(path,
      options: Options(
        responseType: ResponseType.bytes,
        // 400 같은 오류도 예외로 던지지 않게
        validateStatus: (_) => true,
        receiveDataWhenStatusError: true,
      ),
    );
  }

  Future<Response> post(String path, dynamic data) async {
    return _dio.post(path, data: data);
  }

  Future<Response> post2(String path, dynamic data) async {
    return _dio.post(path, data: data,
        options: Options(headers: {'Content-Type': 'multipart/form-data'})
    );
  }

  Future<Response> post3(String path) async {
    return _dio.post(path);
  }


  Future<Response> put(String path, dynamic data) async {
    return _dio.put(path, data: data);
  }

  Future<Response> delete(String path) async {
    return _dio.delete(path);
    // return _dio.delete(
    //   path,
    //   options: Options(
    //     validateStatus: (status) {
    //       // 200~404까지는 예외로 던지지 않음
    //       return status != null && status >= 200 && status <= 404;
    //     },
    //   ),
    // );
  }
}

String humanMessageFromDio(Object error) {
  if (error is DioException) {
    final r = error.response;
    // 서버가 detail/message 구조로 내려주는 경우들 처리
    final data = r?.data;
    if (data is Map) {
      // FastAPI ValidationError
      if (data['detail'] is List) {
        // 여러 에러를 한 줄 메시지로
        final details = (data['detail'] as List).map((e) {
          final loc = (e['loc'] is List) ? (e['loc'] as List).join('.') : 'unknown';
          final msg = e['msg'] ?? 'error';
          return '$loc: $msg';
        }).join('\n');
        return details;
      }
      // 커스텀 키
      if (data['message'] is String) return data['message'];
      if (data['E:'] is String) return data['E:'];     // eformsign 케이스
      if (data['error'] is String) return data['error'];
      if (data['detail'] is String) return data['detail'];
    }
    // 상태코드 기반 fallback
    if (r != null) {
      return 'HTTP ${r.statusCode}: ${r.statusMessage ?? 'request failed'}';
    }
    // 네트워크/타임아웃 등
    return error.message ?? 'Network error';
  }
  return error.toString();
}