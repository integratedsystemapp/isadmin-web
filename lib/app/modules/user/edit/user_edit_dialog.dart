import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../core/values/consts.dart';
import '../../../data/model/user_model.dart';

class UserEditDialog extends StatefulWidget {
  final String mode; // '등록' 또는 '수정'
  final UserModel initialData;
  final void Function(UserModel)? onSave; // 필요 없으면 null 로 두고 사용 안 해도 됨

  const UserEditDialog({
    super.key,
    required this.mode,
    required this.initialData,
    this.onSave,
  });

  @override
  State<UserEditDialog> createState() => _UserEditDialogState();
}

class _UserEditDialogState extends State<UserEditDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _userIdController;
  late final TextEditingController _userNameController;
  late final TextEditingController _mobilePhoneController;
  late final TextEditingController _companyNameController;
  late final TextEditingController _departmentController;
  late final TextEditingController _positionController;
  late final TextEditingController _buildingCdController;

  // 스위치용 상태 (Y/N ↔ bool)
  late bool _isLocalAdmin;
  late bool _isReceiveAppAlert;
  late bool _isReceiveKakaoAlert;
  late bool _isReceiveSms;
  late bool _isReceiveTts;
  late bool _isApproved;

  @override
  void initState() {
    super.initState();
    final d = widget.initialData;

    _userIdController = TextEditingController(text: d.userId);
    _userNameController = TextEditingController(text: d.userName ?? '');
    _mobilePhoneController = TextEditingController(text: d.mobilePhoneNo ?? '');
    _companyNameController = TextEditingController(text: d.companyName ?? '');
    _departmentController = TextEditingController(text: d.department ?? '');
    _positionController = TextEditingController(text: d.position ?? '');
    _buildingCdController = TextEditingController(text: d.buildingCd);

    _isLocalAdmin = (d.isLocalAdmin == 'Y');
    _isReceiveAppAlert = (d.isReceiveAppAlert == 'Y');
    _isReceiveKakaoAlert = (d.isReceiveKakaoAlert == 'Y');
    _isReceiveSms = (d.isReceiveSms == 'Y');
    _isReceiveTts = (d.isReceiveTts == 'Y');
    _isApproved = (d.isApproved == 'Y');
  }

  @override
  void dispose() {
    _userIdController.dispose();
    _userNameController.dispose();
    _mobilePhoneController.dispose();
    _companyNameController.dispose();
    _departmentController.dispose();
    _positionController.dispose();
    _buildingCdController.dispose();
    super.dispose();
  }

  // Y/N 변환 헬퍼
  String _boolToYN(bool v) => v ? 'Y' : 'N';

  void _onCancel() {
    Get.back(); // result 없이 닫기
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      // UserModel에 copyWith가 있다고 가정
      final updated = widget.initialData.copyWith(
        userName: _userNameController.text.trim(),
        mobilePhoneNo: _mobilePhoneController.text.trim(),
        companyName: _companyNameController.text.trim(),
        department: _departmentController.text.trim(),
        position: _positionController.text.trim(),
        buildingCd: _buildingCdController.text.trim(),
        isLocalAdmin: _boolToYN(_isLocalAdmin),
        isReceiveAppAlert: _boolToYN(_isReceiveAppAlert),
        isReceiveKakaoAlert: _boolToYN(_isReceiveKakaoAlert),
        isReceiveSms: _boolToYN(_isReceiveSms),
        isReceiveTts: _boolToYN(_isReceiveTts),
        isApproved: _boolToYN(_isApproved),
      );

      // 필요하다면 여기서 API 호출
      // final userController = UserController.to;
      // final saved = await userController.updateUser(updated);
      // Get.back(result: saved);

      widget.onSave?.call(updated);
      Get.back(result: updated);
    } catch (e, stack) {
      debugPrint('수정 중 오류: $e');
      debugPrint(stack.toString());
      Get.snackbar('에러', '수정 중 오류 발생: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    const labelWidth = 160.0;
    const dialogWidth = 800.0;

    return AlertDialog(
      title: Text('사용자 정보 ${widget.mode}'),
      content: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(right: 20), // 오른쪽 스크롤바 여유
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: SCROLL_BAR_MARGIN),
            width: dialogWidth,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // 사용자ID
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text('*', style: TextStyle(color: Colors.red)),
                        const SizedBox(width: labelWidth, child: Text('사용자ID')),
                        Expanded(
                          child: TextFormField(
                            controller: _userIdController,
                            readOnly: widget.mode == '수정',
                            style: const TextStyle(fontSize: 12),
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return '사용자ID를 입력해주세요';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 사용자 이름
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text('*', style: TextStyle(color: Colors.red)),
                        const SizedBox(width: labelWidth, child: Text('사용자 이름')),
                        Expanded(
                          child: TextFormField(
                            controller: _userNameController,
                            style: const TextStyle(fontSize: 12),
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return '사용자 이름을 입력해주세요';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 휴대폰 번호
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text('*', style: TextStyle(color: Colors.red)),
                        const SizedBox(width: labelWidth, child: Text('휴대폰 번호')),
                        Expanded(
                          child: TextFormField(
                            controller: _mobilePhoneController,
                            style: const TextStyle(fontSize: 12),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              final v = value?.trim() ?? '';
                              if (v.isEmpty) {
                                return '휴대폰 번호를 입력해주세요';
                              }
                              if (v.length != 11) {
                                return '11자리 숫자로 입력해주세요';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 회사명
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text('*', style: TextStyle(color: Colors.red)),
                        const SizedBox(width: labelWidth, child: Text('회사명')),
                        Expanded(
                          child: TextFormField(
                            controller: _companyNameController,
                            style: const TextStyle(fontSize: 12),
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return '회사명을 입력해주세요';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 부서명
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text('*', style: TextStyle(color: Colors.red)),
                        const SizedBox(width: labelWidth, child: Text('부서명')),
                        Expanded(
                          child: TextFormField(
                            controller: _departmentController,
                            style: const TextStyle(fontSize: 12),
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return '부서명을 입력해주세요';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 직급
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text('*', style: TextStyle(color: Colors.red)),
                        const SizedBox(width: labelWidth, child: Text('직급')),
                        Expanded(
                          child: TextFormField(
                            controller: _positionController,
                            style: const TextStyle(fontSize: 12),
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return '직급을 입력해주세요';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 로컬관리자 여부
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text('*', style: TextStyle(color: Colors.red)),
                        const SizedBox(width: labelWidth, child: Text('로컬관리자 여부')),
                        const Spacer(),
                        Switch(
                          value: _isLocalAdmin,
                          onChanged: (val) {
                            setState(() {
                              _isLocalAdmin = val;
                            });
                          },
                        ),
                      ],
                    ),
                  ),

                  // 빌딩코드
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text('*', style: TextStyle(color: Colors.red)),
                        const SizedBox(width: labelWidth, child: Text('빌딩코드')),
                        Expanded(
                          child: TextFormField(
                            controller: _buildingCdController,
                            readOnly: true, // 필요 시 false 로 변경
                            style: const TextStyle(fontSize: 12),
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return '빌딩코드를 입력해주세요';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 앱경보 수신 여부
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text('*', style: TextStyle(color: Colors.red)),
                        const SizedBox(width: labelWidth, child: Text('앱경보 수신 여부')),
                        const Spacer(),
                        Switch(
                          value: _isReceiveAppAlert,
                          onChanged: (val) {
                            setState(() {
                              _isReceiveAppAlert = val;
                            });
                          },
                        ),
                      ],
                    ),
                  ),

                  // 알림톡 수신 여부
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text('*', style: TextStyle(color: Colors.red)),
                        const SizedBox(width: labelWidth, child: Text('알림톡 수신 여부')),
                        const Spacer(),
                        Switch(
                          value: _isReceiveKakaoAlert,
                          onChanged: (val) {
                            setState(() {
                              _isReceiveKakaoAlert = val;
                            });
                          },
                        ),
                      ],
                    ),
                  ),

                  // SMS 수신 여부
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text('*', style: TextStyle(color: Colors.red)),
                        const SizedBox(width: labelWidth, child: Text('SMS 수신 여부')),
                        const Spacer(),
                        Switch(
                          value: _isReceiveSms,
                          onChanged: (val) {
                            setState(() {
                              _isReceiveSms = val;
                            });
                          },
                        ),
                      ],
                    ),
                  ),

                  // TTS 수신 여부
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text('*', style: TextStyle(color: Colors.red)),
                        const SizedBox(width: labelWidth, child: Text('TTS 수신 여부')),
                        const Spacer(),
                        Switch(
                          value: _isReceiveTts,
                          onChanged: (val) {
                            setState(() {
                              _isReceiveTts = val;
                            });
                          },
                        ),
                      ],
                    ),
                  ),

                  // 승인 여부
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text('*', style: TextStyle(color: Colors.red)),
                        const SizedBox(width: labelWidth, child: Text('승인 여부')),
                        const Spacer(),
                        Switch(
                          value: _isApproved,
                          onChanged: (val) {
                            setState(() {
                              _isApproved = val;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _onCancel,
          child: const Text('취소'),
        ),
        ElevatedButton(
          onPressed: _onSubmit,
          child: Text(widget.mode == '등록' ? '등록' : '저장'),
        ),
      ],
    );
  }
}
