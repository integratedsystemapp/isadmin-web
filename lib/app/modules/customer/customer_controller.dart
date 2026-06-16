import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:html' as html;

import '../../data/model/customer_model.dart';
import '../common/api_service.dart';
import '../common/show_custom_snackbar.dart';

import 'contract/contract_send.dart';


class CustomerController extends GetxController {

  static CustomerController get to {
    if (Get.isRegistered<CustomerController>()) {
      return Get.find<CustomerController>();
    } else {
      return Get.put(CustomerController());
    }
  }

  final selected = <int>{}.obs;
  final customerList = <CustomerModel>[].obs;
  final selectedCustomer = CustomerModel(
    companyCd: '',
    companyName: '',
    businessRegistrationNo: null,
    address: null,
    companyPhoneNo: null,
    ceoName: null,
    businessTypeCd: null,
    businessItem: null,
    managerName: null,
    managerPosition: null,
    managerTelNo: null,
    managerMobileNo: null,
    managerEmail: null,
    invoiceIssueDate: null,
    contractAmount: null,
    eformsignDocId: null,
  ).obs;

  final sortColumnIndex = 1.obs;
  // final sortColumnIndex = RxnInt(); // null 허용
  final sortAscending = true.obs;

  // T는 Comparable (String, num, DateTime 등)
  int _cmp<T extends Comparable>(T? a, T? b, {bool ascending = true, bool nullsLast = true, bool caseInsensitive = true}) {
    Comparable? x = a;
    Comparable? y = b;

    // 문자열이면 대소문자 무시 옵션
    if (caseInsensitive) {
      if (x is String) x = x.toLowerCase();
      if (y is String) y = y.toLowerCase();
    }

    // null 처리
    if (x == null && y == null) return 0;
    if (x == null) return nullsLast ? 1 : -1;
    if (y == null) return nullsLast ? -1 : 1;

    final base = Comparable.compare(x, y);
    return ascending ? base : -base;
  }

  void sortBy<T extends Comparable>(
      T? Function(CustomerModel e) getField,
      int columnIndex,
      bool ascending,
      ) {
    customerList.sort((a, b) => _cmp<T>(getField(a), getField(b), ascending: ascending));
    sortColumnIndex.value = columnIndex;   // 이제 null 가능
    sortAscending.value = ascending;
  }


  void toggleSelection(int index) {

    if (selected.isNotEmpty && selected.first == index) {
      // 선택 토글
      selected.clear();
    } else {
      selected.clear();
      selected.add(index);
    }

    // debugPrint(selected.toList().toString());

    return;



    if (selected.contains(index)) {
      selected.remove(index);
    } else {
      selected.add(index);
    }
  }

  bool isSelected(int index) => selected.contains(index);
  CustomerModel? getSelected() => (selected.isNotEmpty) ? customerList[selected.first] : null;

  final ScrollController controller = ScrollController();
  final ScrollController horizontalController = ScrollController();
  // bool sortAscending = true;
  // int? sortColumnIndex;
  bool initialized = false;
  RxBool isLoading = false.obs;
  var selectedCustomerCd = RxnString();  // dropdown list
  var selectedCustomerName = RxnString();// dropdown list

  Future<void> fetchCustomers() async {
    try {
      isLoading.value = true;
      final response = await ApiService().get('/customer/');
      final data = response.data as List<dynamic>;

      debugPrint(jsonEncode(data), wrapWidth: 1024);

      final customers = data.map((e) => CustomerModel.fromJson(e)).toList();

      customerList.assignAll(customers);

      debugPrint(jsonEncode(customerList.map((e) => e.toJson()).toList()));

      isLoading.value = false;
    } catch (e) {
      showCustomSnackbar('에러', '고객 목록 조회 실패: $e');
      debugPrint('Error fetching customers: $e');
    }
  }


  @override
  void onInit() {
    super.onInit();
    // fetchCustomers();
  }

  @override
  void onClose() {
    controller.dispose();
    horizontalController.dispose();
    super.onClose();
  }

  Future<void> deleteCustomer(String companyCd) async {
    try {
      final response = await ApiService().delete('/customer/$companyCd');

      debugPrint('Delete response: ${response.statusCode} - ${response.data}');
      if (response.statusCode == 200) {
        showCustomSnackbar('성공', '고객이 삭제되었습니다.');
      } else if (response.statusCode == 404) {
        showCustomSnackbar('오류', '고객 정보를 찾을 수 없습니다.');
      } else {
        showCustomSnackbar('오류', '삭제 실패: ${response.statusCode}');
      }
    } on DioException catch (e) {
      // Dio 예외 명확히 처리
      showCustomSnackbar('네트워크 오류', '삭제 실패: ${e.response?.statusCode ?? ''}');
      rethrow;
    } catch (e) {
      showCustomSnackbar('에러', '알 수 없는 오류: $e');
      rethrow;
    }
  }

  void setSelectedCustomer(String? value) {
    debugPrint('setSelectedCustomer--------------------------${value}');
    final _companyCd = value!.split('(')[0];
    final index = this.customerList.indexWhere((e)=>e.companyCd == _companyCd);
    if (index < 0) {
      debugPrint('CustomerController:setSelectedCustomer index oob:${index}');
      return;
    }

    selectedCustomerName.value = this.customerList[index].companyName;
    selectedCustomerCd.value = _companyCd;

    debugPrint('selectedCustomerName.value--------------------------${selectedCustomerName.value}');
    debugPrint('index--------------------------${index}');
    debugPrint('selectedCustomerCd.value--------------------------${selectedCustomerCd.value}');

  }

  /*
  계약서 발송
   */
  Future<String?> sendContractDocument(ContractSendModel constractSendModel) async {
    String documentId = ''; // api 결과

    String? managerMobileNo = constractSendModel.managerMobile; // 담당자 휴대폰
    final managerEmail = constractSendModel.managerEmail; // 담당자 이메일
    String? managerName = constractSendModel.managerName;  // 담당자이름
    String? companyName = constractSendModel.companyName;
    String? companyCd = constractSendModel.companyCd;

    debugPrint('managerEmail:${managerEmail}, companyCd:${companyCd}');


    managerMobileNo = managerMobileNo?.replaceAll('-', '');

    final Map<String, dynamic> requestBody = {
      "manager_name": managerName,
      "manager_mobile_no": managerMobileNo,
      "manager_email": managerEmail,
      "company_name": companyName,
      "company_cd": companyCd
    };

    // null/빈문자열 제거
    // requestBody.removeWhere((k, v) => v == null || (v is String && v.trim().isEmpty));

    try {
      final response = await ApiService().post(
        '/eformsign/create',
        requestBody,
      );

      print('❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌ statusCode: {response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseDataMap = response.data as Map<String, dynamic>;
        documentId = responseDataMap['document_id'];

        debugPrint("[debug] respone.data ${response.data as Map<String, dynamic>}");
        showCustomSnackbar('성공', '계약서(${documentId}) 발송이 완료 되었습니다.');
      } else {
        print('4...........');
        // showCustomSnackbar('오류', '등록 실패: ${response.statusCode}');
        print('❌ statusCode: ${response.statusCode}');
      }

      if (response.statusCode! >= 400) {
        final msg = extractFastApiMessage(response.data);
        // UI 노출/분기
        debugPrint('❌ $msg');

        // ✅ 성공: data가 Map이면 그대로 사용하거나 모델로 매핑
        final map = _asMap(response.data);
        debugPrint('✅ ${map?['detail']['message'] ?? response.data}');

        final test = map?['detail']['message'];
        showCustomSnackbar('이폼사인', '계약서 발송을 할 수 없습니다.(사용한도 초과)');
        throw Exception(test);
      }


    } on DioException catch (e) {
      final data = e.response?.data;
      final msg = (data is Map && data['detail'] is Map)
          ? data['detail']['message'] ?? data['detail'].toString()
          : (data is Map ? data['message'] ?? data['error'] ?? data.toString()
          : e.message ?? 'network error');
      print('❌ $msg');
    // } on DioException catch (e) {
    //   final msg = humanMessageFromDio(e);
    //   print('❌ $e');
    //   print('❌ $msg');
    //   // showCustomSnackbar('에러', msg);
    //   showCustomSnackbar('에러', '계약서 발송 실패 했습니다.');

    } catch (e,st) {
      debugPrint('❌Error sendContractDocument: $e');
      debugPrint('$st'); // ← 스택트레이스로 정확한 파일/라인 확인
      debugPrint('네트워크 오류: $e');
      rethrow;
    }

    return documentId;


  }


  /*
  다운로드
   */
  Future<void> saveBytesImpl(List<int> bytes, String filename, String mimeType) async {
    final blob = html.Blob([bytes], mimeType);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..download = filename
      ..style.display = 'none';
    html.document.body!.append(anchor);
    anchor.click();
    anchor.remove();
    html.Url.revokeObjectUrl(url);
  }
  // 테스트
  String? _extractFileName(String contentDisposition) {
    // filename*=UTF-8''xxx.zip 또는 filename="xxx.zip" 모두 처리
    final utf8Match = RegExp(r"filename\*\s*=\s*UTF-8''([^;]+)").firstMatch(contentDisposition);
    if (utf8Match != null) return Uri.decodeComponent(utf8Match.group(1)!);

    final asciiMatch = RegExp(r'filename\s*=\s*"([^"]+)"').firstMatch(contentDisposition)
        ?? RegExp(r'filename\s*=\s*([^;]+)').firstMatch(contentDisposition);
    return asciiMatch?.group(1)?.trim();
  }
  Future<void> downloadZipWithHttp(String url) async {
    final resp = await http.get(Uri.parse(url), headers: {
      'Accept': 'application/zip',
    });
    final fileName = _extractFileName(resp.headers['content-disposition'] ?? '') ?? 'document.zip';

    final bytes = Uint8List.fromList(resp.bodyBytes);
    final blob = html.Blob([bytes], 'application/zip');
    final urlObj = html.Url.createObjectUrlFromBlob(blob);

    final a = html.AnchorElement(href: urlObj)..download = fileName;
    html.document.body!.append(a);
    a.click();
    a.remove();
    html.Url.revokeObjectUrl(urlObj);
  }




  Future<void> downloadDocument(String eformSignDocId) async {
    // final _dio = Dio();

    try {
      // 서버 API URL (FastAPI 라우터)
      final url = 'http://localhost:8000/eformsign/download/$eformSignDocId';

      final resp = await ApiService().get2('/eformsign/download/$eformSignDocId');

        /*
      final resp = await _dio.get<List<int>>(
        url,
        options: Options(
          responseType: ResponseType.bytes,
          // 400 같은 오류도 예외로 던지지 않게
          validateStatus: (_) => true,
          receiveDataWhenStatusError: true,
        ),
      );
      */




      print('status=${resp.statusCode}');
      print('headers=${resp.headers}');

      if (resp.statusCode == 200 && resp.data != null) {
        final filename = 'eformsign_${eformSignDocId}.pdf'; // 서버도 동일 이름을 내려주면 더 깔끔
        await saveBytesImpl(resp.data!, filename, 'application/pdf');
      } else {
        if (resp.data != null) {
          // 서버가 JSON/text로 에러를 내려줬다면 확인
          try {
            final text = String.fromCharCodes(resp.data!);

            final code = jsonDecode(jsonDecode(text)['detail'])['code'];
            if (code == '4000004') {
              //The document does not exist.
              showCustomSnackbar('안내', '다큐먼트가 존재하지 않습니다.');

            }

          } catch (_) {}
        }
        throw Exception('다운로드 실패: ${resp.statusCode} ${resp.statusMessage}');
      }


    } catch (e) {
      print('🚨 오류 발생: $e');
    }
  }

  /*
  첨부파일 다운로드(계약서)
   */
  Future<void> downloadAttachDocument(String eformSignDocId) async {

    try {

      final resp = await ApiService().get2('/eformsign/download/attach/$eformSignDocId');

      print('status=${resp.statusCode}');
      print('headers=${resp.headers}');
      if (resp.data != null) {
        // 서버가 JSON/text로 에러를 내려줬다면 확인
        try {
          final text = String.fromCharCodes(resp.data!);
          print('body=$text');
        } catch (_) {}
      }

      if (resp.statusCode == 200 && resp.data != null) {

        // 2) Content-Type: application/zip 인지 확인 (환경에 따라 octet-stream일 수도 있으므로 느슨하게)
        final ct = (resp.headers.value('content-type') ?? '').toLowerCase();
        final isZipContentType = ct.contains('application/zip') || ct.contains('application/x-zip-compressed');

        // 3) Content-Length가 최소 EOCD(End Of Central Directory) 22바이트 이상인지
        final clHeader = resp.headers.value('content-length');
        final contentLength = clHeader == null ? null : int.tryParse(clHeader);
        final lengthOkay = (contentLength ?? (resp.data?.length ?? 0)) >= 22;

        // 4) 바디 앞 2바이트가 ZIP 시그니처 "PK" (0x50, 0x4B) 인지
        final data = Uint8List.fromList(resp.data ?? const []);
        final isZipMagic = data.length >= 2 && data[0] == 0x50 && data[1] == 0x4B;

        bool isAttachExists = true;
        // 최종 판단(보수적): 200 + (zip 헤더 or zip content-type) + 길이 OK
        if (!lengthOkay) isAttachExists = false;
        if (!(isZipMagic || isZipContentType)) isAttachExists = false;

        debugPrint('resp.data?.length ?? 0==>${resp.data?.length ?? 0}');
        debugPrint('data.length ?? 0==>${data.length ?? 0}');
        if (!isAttachExists || (resp.data?.length ?? 0) == 22) {
          showCustomSnackbar('안내', '첨부파일이 존재하지 않습니다.');
          return;
        }




        final filename = 'eformsign_attach_${eformSignDocId}.zip'; // 서버도 동일 이름을 내려주면 더 깔끔
        await saveBytesImpl(resp.data!, filename, 'application/zip');


      } else {

        if (resp.data != null) {
          // 서버가 JSON/text로 에러를 내려줬다면 확인
          try {
            final text = String.fromCharCodes(resp.data!);

            final code = jsonDecode(jsonDecode(text)['detail'])['code'];
            if (code == '4000004') {
              //The document does not exist.
              showCustomSnackbar('안내', '첨부파일이 존재하지 않습니다.');

            }

          } catch (_) {}
        }

        throw Exception('다운로드 실패: ${resp.statusCode} ${resp.statusMessage}');
      }


    } catch (e) {
      print('🚨 오류 발생: $e');
    }
  }

  // 테스트
  Future<void> downloadZip(String url) async {
    final dio = Dio(BaseOptions(
      responseType: ResponseType.bytes,   // 중요: raw bytes로 받기
      headers: {
        'Accept': 'application/zip',
      },
    ));

    final resp = await dio.get<List<int>>(url);

    // 파일명 추출
    final cd = resp.headers.value('content-disposition') ?? '';
    final fileName = _extractFileName(cd) ?? 'document.zip';

    // Uint8List 변환
    final bytes = Uint8List.fromList(resp.data ?? []);

    // Blob 생성
    final blob = html.Blob([bytes]);
    final urlObj = html.Url.createObjectUrlFromBlob(blob);

    // 가짜 a 태그 클릭 → 다운로드 시작
    final anchor = html.AnchorElement(href: urlObj)
      ..download = fileName
      ..style.display = 'none';
    html.document.body!.children.add(anchor);
    anchor.click();
    anchor.remove();

    html.Url.revokeObjectUrl(urlObj);
  }

  /*
  첨부파일 다운로드(사업자등록증)
   */


}

// data를 Map으로 표준화 (Map 그대로 / JSON 문자열 / 이중인코딩 / 파이썬 dict 문자열까지 가급적 처리)
Map<String, dynamic>? _asMap(dynamic data) {
  if (data is Map) {
    // 키가 전부 String이면 그대로
    if (data.keys.every((k) => k is String)) {
      return Map<String, dynamic>.from(data);
    }
    // 그 외에는 key를 문자열로 강제 변환
    return data.map((key, value) => MapEntry(key.toString(), value));
  }

  if (data is String) {
    // 1차: 정상 JSON 시도
    try {
      final d = jsonDecode(data);
      if (d is Map) return _asMap(d);
      if (d is String) {
        final d2 = jsonDecode(d);
        if (d2 is Map) return _asMap(d2);
      }
    } catch (_) {
      // 파이썬 dict 스타일 보정
      final fixed = data
          .replaceAllMapped(RegExp(r'\bTrue\b'), (_) => 'true')
          .replaceAllMapped(RegExp(r'\bFalse\b'), (_) => 'false')
          .replaceAllMapped(RegExp(r'\bNone\b'), (_) => 'null')
          .replaceAll("'", '"');
      try {
        final d = jsonDecode(fixed);
        if (d is Map) return _asMap(d);
      } catch (_) {}
    }
  }
  return null;
}

/// FastAPI의 에러 메시지 추출 (detail 구조 전부 커버)
String extractFastApiMessage(dynamic root) {
  final map = _asMap(root) ?? {};
  final detail = map.containsKey('detail') ? map['detail'] : map;

  // detail이 문자열
  if (detail is String && detail.trim().isNotEmpty) return detail;

  // detail이 Map (서버가 {"detail":{"message":"..."}} 로 준 경우)
  if (detail is Map) {
    final m = detail['message'] ??
        detail['ErrorMessage'] ?? // 외부 서비스 에러 키 대응
        detail['E:'] ??
        detail['error'] ??
        detail['msg'];
    if (m is String && m.trim().isNotEmpty) return m;
    return detail.toString();
  }

  // FastAPI ValidationError: detail: [ {loc,msg,type}, ... ]
  if (detail is List) {
    return detail.map((e) {
      if (e is Map) {
        final loc = (e['loc'] is List) ? (e['loc'] as List).join('.') : '';
        final msg = e['msg'] ?? e['message'] ?? e['error'] ?? 'invalid';
        return loc.isNotEmpty ? '$loc: $msg' : '$msg';
      }
      return e.toString();
    }).join('\n');
  }

  // 서버가 최상위에 message만 준 경우
  final top = map['message'] ?? map['ErrorMessage'] ?? map['error'];
  if (top is String && top.trim().isNotEmpty) return top;

  return root?.toString() ?? 'Unknown error';
}