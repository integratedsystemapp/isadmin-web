import 'package:dio/dio.dart';

class TokenInterceptor extends Interceptor {
  // 추후 GetStorage, SharedPreferences 등에서 토큰을 불러올 수 있음
  Future<String?> _getToken() async {
    // 예: return await storage.read('accessToken');
    return 'your-token-goes-here';
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _getToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    return handler.next(options);
  }
}
