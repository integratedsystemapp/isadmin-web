import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

/// 팝업에서 돌려줄 결과
class ContractSendModel {
  final bool? isSendToMobile;   // 발송 여부 (휴대전화)
  final String? managerName;       // 담당자 성명
  final String? managerEmail;       // 담당자 이메일
  final String? managerMobile;      // 담당자 휴대전화
  final String? message;       // 발송 메시지
  final String? companyName;       // 회사명
  final String? companyCd;       // 회사코드
  ContractSendModel({
    this.isSendToMobile,
    this.managerName,
    this.managerEmail,
    this.managerMobile,
    this.message,
    this.companyName,
    this.companyCd,
  });
}

/// 초기 데이터 (읽기전용으로 노출될 회사/사업자 정보 등)
class ContractInitData {
  final String companyCd;
  final String companyName;
  final String bizNo;
  final String ceoName;
  final String? managerName;
  final String? managerEmail;
  final String? managerMobile;
  const ContractInitData({
    required this.companyCd,
    required this.companyName,
    required this.bizNo,
    required this.ceoName,
    this.managerName,
    this.managerEmail,
    this.managerMobile,
  });
}

/// GetX Controller: 상태/검증/전송(API) 담당
class ContractSendController extends GetxController {

  static ContractSendController get to {
    if (Get.isRegistered<ContractSendController>()) {
      return Get.find<ContractSendController>();
    } else {
      return Get.put(ContractSendController());
    }
  }


  // UI 상태
  final isLoading = false.obs;
  final errorText = RxnString();

  // 폼키
  final formKey = GlobalKey<FormState>();

  // 읽기전용 값들
  late  String companyCd;
  late  String companyName;
  late  String bizNo;
  late  String ceoName;

  // 입력 컨트롤러
  late  TextEditingController managerNameCtrl;
  late  TextEditingController managerEmailCtrl;
  late  TextEditingController managerMobileCtrl;
  final TextEditingController messageCtrl = TextEditingController();

  // 발송 여부
  final sendMobile = false.obs;

  void init(ContractInitData d) {
    companyCd = d.companyCd;
    companyName = d.companyName;
    bizNo = d.bizNo;
    ceoName = d.ceoName;

    managerNameCtrl = TextEditingController(text: d.managerName ?? '');
    managerEmailCtrl = TextEditingController(text: d.managerEmail ?? '');
    managerMobileCtrl = TextEditingController(text: d.managerMobile ?? '');
  }

  @override
  void onClose() {
    managerNameCtrl.dispose();
    managerEmailCtrl.dispose();
    managerMobileCtrl.dispose();
    messageCtrl.dispose();
    super.onClose();
  }

  /// 실제 전송 로직 (FastAPI/Dio 연동 자리)
  Future<void> submit() async {
    if (!formKey.currentState!.validate()) return;

    try {
      isLoading.value = true;
      errorText.value = null;

      // TODO: Dio를 사용하여 FastAPI로 전송하는 예시
      // final dio = Dio(BaseOptions(baseUrl: envBaseUrl));
      // final resp = await dio.post('/contracts/send', data: {
      //   'company_cd': companyCd,
      //   'manager_name': managerNameCtrl.text.trim(),
      //   'manager_email': managerEmailCtrl.text.trim(),
      //   'send_sms': sendMobile.value,
      //   'manager_mobile': managerMobileCtrl.text.trim(),
      //   'message': messageCtrl.text.trim(),
      // });
      // if (resp.statusCode != 200) throw Exception('전송 실패: ${resp.statusCode}');

      // 성공 시 결과 반환
      final result = ContractSendModel(
        isSendToMobile: sendMobile.value,
        companyName: companyName,
        companyCd: companyCd,
        managerName: managerNameCtrl.text.trim().isEmpty ? null : managerNameCtrl.text.trim(),
        managerEmail: managerEmailCtrl.text.trim().isEmpty ? null : managerEmailCtrl.text.trim(),
        managerMobile: managerMobileCtrl.text.trim().isEmpty
            ? null
            : managerMobileCtrl.text.trim(),
        message: messageCtrl.text.trim().isEmpty
            ? null
            : messageCtrl.text.trim(),
      );

      Get.back(result: result);
    } catch (e) {
      errorText.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}

/// 팝업 열기 (Get.dialog)
Future<ContractSendModel?> openContractSendDialog(ContractInitData data) async {
  // 컨트롤러 생성 및 초기화
  final ctrl = ContractSendController.to;
  ctrl.init(data);

  final res = await Get.dialog<ContractSendModel>(
    const _ContractSendDialog(),
    barrierDismissible: false,
  );

  // 바로 지우지 말고 다음 프레임에서 삭제
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (Get.isRegistered<ContractSendController>(tag: 'contract')) {
      Get.delete<ContractSendController>(tag: 'contract', force: true);
    }
  });

  // 팝업 종료 후 컨트롤러 정리
  // Get.delete<ContractSendController>();
  return res;
}

/// Material 3 스타일 팝업 위젯
class _ContractSendDialog extends StatelessWidget {
  const _ContractSendDialog();

  InputDecoration _roHint(String hint) => InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(fontSize: 14),
    filled: true,
    fillColor: const Color(0xFF9E9E9E).withOpacity(0.08),
    border: const OutlineInputBorder(),
    isDense: true,
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
  );

  InputDecoration _editHint(String hint) => InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(fontSize: 14),
    border: const OutlineInputBorder(),
    isDense: true,
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
  );

  Widget _label(String text, {bool required = false}) {
    return SizedBox(
      width: 140,
      child: Row(
        children: [
          if (required)
            const Text('*', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          Flexible(child: Text(text)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<ContractSendController>();
    const dialogWidth = 760.0;

    return Obx(() {
      return Stack(
        children: [
          AlertDialog(
            title: const Text('계약서 발송'),
            contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
            content: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: dialogWidth),
                child: Form(
                  key: ctrl.formKey,
                  child: Column(
                    children: [
                      if (ctrl.errorText.value != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: MaterialBanner(
                            padding: const EdgeInsets.all(8),
                            content: Text(
                              ctrl.errorText.value!,
                              style: const TextStyle(fontSize: 13),
                            ),
                            leading: const Icon(Icons.error_outline),
                            backgroundColor: Theme.of(context).colorScheme.errorContainer,
                            actions: [
                              TextButton(
                                onPressed: () => ctrl.errorText.value = null,
                                child: const Text('닫기'),
                              )
                            ],
                          ),
                        ),

                      // 회사코드
                      Row(children: [
                        _label('회사코드'),
                        Expanded(
                          child: TextFormField(
                            readOnly: true,
                            initialValue: ctrl.companyCd,
                            decoration: _roHint('회사코드 수정불가'),
                          ),
                        ),
                      ]),
                      const SizedBox(height: 8),

                      // 회사명
                      Row(children: [
                        _label('회사명'),
                        Expanded(
                          child: TextFormField(
                            readOnly: true,
                            initialValue: ctrl.companyName,
                            decoration: _roHint('(수정불가)'),
                          ),
                        ),
                      ]),
                      const SizedBox(height: 8),

                      // 사업자 등록번호
                      Row(children: [
                        _label('사업자 등록번호'),
                        Expanded(
                          child: TextFormField(
                            readOnly: true,
                            initialValue: ctrl.bizNo,
                            decoration: _roHint('(수정불가)'),
                          ),
                        ),
                      ]),
                      const SizedBox(height: 8),

                      // 대표자
                      Row(children: [
                        _label('대표자'),
                        Expanded(
                          child: TextFormField(
                            readOnly: true,
                            initialValue: ctrl.ceoName,
                            decoration: _roHint('(수정불가)'),
                          ),
                        ),
                      ]),
                      const SizedBox(height: 8),

                      // 담당자 성명
                      Row(children: [
                        _label('담당자 성명'),
                        Expanded(
                          child: TextFormField(
                            controller: ctrl.managerNameCtrl,
                            decoration: _editHint('담당자 성명을 입력하세요'),
                          ),
                        ),
                      ]),
                      const SizedBox(height: 8),

                      // 담당자 이메일
                      Row(children: [
                        _label('담당자 이메일'),
                        Expanded(
                          child: TextFormField(
                            controller: ctrl.managerEmailCtrl,
                            keyboardType: TextInputType.emailAddress,
                            decoration: _editHint('이메일 주소를 입력하세요'),
                            validator: (v) {
                              if ((v ?? '').isEmpty) return null; // 선택 입력
                              final ok = RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(v!);
                              return ok ? null : '이메일 형식을 확인해주세요';
                            },
                          ),
                        ),
                      ]),
                      const SizedBox(height: 8),

                      // 담당자 휴대전화 + 발송/미발송
                      Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                        _label('담당자 휴대전화', required: true),
                        Row(children: [
                          Radio<bool>(
                            value: true,
                            groupValue: ctrl.sendMobile.value,
                            onChanged: (v) => ctrl.sendMobile.value = v!,
                          ),
                          const Text('발송'),
                          const SizedBox(width: 8),
                          Radio<bool>(
                            value: false,
                            groupValue: ctrl.sendMobile.value,
                            onChanged: (v) => ctrl.sendMobile.value = v!,
                          ),
                          const Text('미발송'),
                        ]),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: ctrl.managerMobileCtrl,
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            decoration: _editHint('DB값이 있으면 호출 (수정 가능)'),
                            validator: (v) {
                              if (ctrl.sendMobile.value) {
                                if ((v ?? '').isEmpty) return '휴대전화 번호를 입력하세요';
                                if (v!.length < 9 || v.length > 12) return '휴대전화 자리수를 확인해주세요';
                              }
                              return null;
                            },
                          ),
                        ),
                      ]),
                      const SizedBox(height: 8),

                      // 발송 메시지
                      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        _label('발송 메시지'),
                        Expanded(
                          child: TextFormField(
                            controller: ctrl.messageCtrl,
                            maxLines: 3,
                            decoration: _editHint('사용자 입력'),
                          ),
                        ),
                      ]),
                    ]
                        .map((w) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: w,
                    ))
                        .toList(),
                  ),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(result: null),
                child: const Text('취소'),
              ),
              FilledButton(
                onPressed: ctrl.isLoading.value ? null : ctrl.submit,
                child: const Text('발송'),
              ),
            ],
          ),

          // 로딩 오버레이 (Material 3 톤다운 백드롭)
          if (ctrl.isLoading.value)
            Positioned.fill(
              child: ColoredBox(
                color: Theme.of(context).colorScheme.surface.withOpacity(0.6),
                child: const Center(child: CircularProgressIndicator()),
              ),
            ),
        ],
      );
    });
  }
}

/// 샘플: MaterialApp (Material 3) 설정과 호출 예
/*
class DemoApp extends StatelessWidget {
  const DemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Contract Send Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF3F5FDB),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          isDense: true,
        ),
      ),
      home: Scaffold(
        appBar: AppBar(title: const Text('Material 3 + GetX Dialog')),
        body: Center(
          child: FilledButton.icon(
            icon: const Icon(Icons.send),
            label: const Text('계약서 발송 팝업 열기'),
            onPressed: () async {


              final data = ContractInitData(
                companyCd: 'BP20250006',
                companyName: 'ACME',
                bizNo: '123-45-67890',
                ceoName: '홍길동',
                managerName: '김담당',
                managerEmail: 'kim@example.com',
                managerMobile: '01012345678',
              );

              final res = await openContractSendDialog(data);
              if (res != null) {
                Get.snackbar(
                  '결과',
                  '발송: ${res.sendToMobile}, 휴대폰: ${res.mobileNo ?? '-'}, 메시지: ${res.message ?? '-'}',
                  snackPosition: SnackPosition.BOTTOM,
                  duration: const Duration(seconds: 3),
                );
              }


            },
          ),
        ),
      ),
    );
  }
}

 */
