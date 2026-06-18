import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../core/values/consts.dart';
import '../../../data/model/building_model.dart';
import '../../../widgets/file_attach_row.dart';
import '../../common/show_custom_snackbar.dart';
import '../../customer/customer_controller.dart';
import '../building_controller.dart';
import 'building_edit_controller.dart';
import 'dart:html' as html;

class BuildingEditDialog extends StatelessWidget {
  final String mode; // '등록' 또는 '수정'
  final BuildingModel initialData;
  final void Function(BuildingModel) onSave;

  BuildingEditDialog({
    super.key,
    required this.mode,
    required this.initialData,
    required this.onSave,
  });

  final _formKey = GlobalKey<FormState>();
  final controller = BuildingEditController.to;

  @override
  Widget build(BuildContext context) {
    controller.initFields(initialData);

    final labelWidth = 160.0;
    final dialogWidth = 800.0;

    final customerController = CustomerController.to;
    // customerController.fetchCustomers();

    return AlertDialog(
      title: Text('빌딩 정보 $mode'),
      content: Obx(
        () => SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: SCROLL_BAR_MARGIN),
            width: dialogWidth,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  /// 회사코드 드롭다운
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        /*
                          회사코드
                           */
                        // 필수여부 아이콘 표시
                        Text('*', style: TextStyle(color: Colors.red)),
                        SizedBox(width: labelWidth, child: Text('회사코드')),
                        Expanded(
                          child:
                              mode == '등록'
                                  ? Obx(() {
                                    if (customerController.isLoading.value) {
                                      return const Text('로딩 중...');
                                      // return const CircularProgressIndicator();
                                    }
                                    if (customerController
                                        .customerList
                                        .isEmpty) {
                                      return const Text('회사 목록이 없습니다.');
                                    }
                                    return DropdownButtonFormField<String>(
                                      // value: customerController.selectedCustomerCd.value,
                                      decoration: const InputDecoration(
                                        labelText: '회사 선택',
                                        border: OutlineInputBorder(),
                                      ),
                                      validator:
                                          (value) =>
                                              value == null
                                                  ? '회사를 선택하세요'
                                                  : null,
                                      items:
                                          customerController.customerList.map((
                                            customer,
                                          ) {
                                            return DropdownMenuItem<String>(
                                              value: customer.companyCd,
                                              child: Text(
                                                '${customer.companyCd}(${customer.companyName})',
                                              ),
                                            );
                                          }).toList(),
                                      onChanged:
                                          (value) => customerController
                                              .setSelectedCustomer(value),
                                    );
                                  })
                                  :
                                  // 수정 시 회사코드 수정 불가
                                  TextFormField(
                                    controller:
                                        controller.controllers['companyCd'],
                                    readOnly: true,
                                    style: TextStyle(fontSize: 12),
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                        ),
                      ],
                    ),
                  ),

                  // 빌딩코드
                  // 등록 시 자동생성
                  if (mode == '수정')
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // 필수여부 아이콘 표시
                          Text('*', style: TextStyle(color: Colors.red)),
                          SizedBox(width: labelWidth, child: Text('빌딩코드')),
                          Expanded(
                            child: TextFormField(
                              controller: controller.controllers['buildingCd'],
                              readOnly: true,
                              style: TextStyle(fontSize: 12),
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return '빌딩코드를 입력해주세요';
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                  // 빌딩명
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // 필수여부 아이콘 표시
                        Text('*', style: TextStyle(color: Colors.red)),
                        SizedBox(width: labelWidth, child: Text('빌딩명')),
                        Expanded(
                          child: TextFormField(
                            controller: controller.controllers['buildingName'],
                            style: TextStyle(fontSize: 12),
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return '빌딩명을 입력해주세요';
                              }
                              if (value.length > 30) {
                                return '30자리 이내로 입력해주세요';
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 회사명
                  /*
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // 필수여부 아이콘 표시
                          Text('*', style: TextStyle(color: Colors.red)),
                          SizedBox(width: labelWidth, child: Text('회사명')),
                          Expanded(
                            child: TextFormField(
                              controller: controller.controllers['companyName'],
                              style: TextStyle(fontSize: 12),
                              decoration: const InputDecoration(border: OutlineInputBorder()),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return '사용자ID를 입력해주세요';
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                     */

                  // 빌딩주소
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(vertical: 6),
                  //   child: Row(
                  //     crossAxisAlignment: CrossAxisAlignment.center,
                  //     children: [
                  //       // 필수여부 아이콘 표시
                  //       Text('*', style: TextStyle(color: Colors.transparent)),
                  //       SizedBox(width: labelWidth, child: Text('빌딩주소')),
                  //       Expanded(
                  //         child: TextFormField(
                  //           controller: controller.controllers['buildingAddress'],
                  //           style: TextStyle(fontSize: 12),
                  //           decoration: const InputDecoration(border: OutlineInputBorder()),
                  //           validator: (value) {
                  //             /*
                  //             if (value == null || value.trim().isEmpty) {
                  //               return '빌딩주소를 입력해주세요';
                  //             }
                  //              */
                  //
                  //           },
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '*',
                              style: TextStyle(color: Colors.transparent),
                            ),
                            SizedBox(width: labelWidth, child: Text('주소')),
                            Expanded(
                              child: InkWell(
                                onTap: () async {
                                  html.window.open(
                                    '/kakao_address_popup.html',
                                    'kakaoPostcodePopup',
                                    'width=500,height=600,scrollbars=yes',
                                  );

                                  html.window.onMessage.first.then((event) {
                                    final data = event.data;
                                    if (data is Map) {
                                      final zc = data['zonecode'];
                                      final addr = data['roadAddress'];
                                      // onSelected(zc ?? '', addr ?? '');

                                      controller.controllers['address']?.text =
                                          '${zc} ${addr}';
                                    }
                                  });
                                },
                                child: AbsorbPointer(
                                  child: TextFormField(
                                    controller:
                                        controller.controllers['address'],
                                    style: TextStyle(fontSize: 12),

                                    // maxLines: 2,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // 필수여부 아이콘 표시
                            Text(
                              '*',
                              style: TextStyle(color: Colors.transparent),
                            ),
                            SizedBox(width: labelWidth),
                            Expanded(
                              child: TextFormField(
                                controller:
                                    controller.controllers['address_detail'],
                                style: TextStyle(fontSize: 12),
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (controller
                                              .controllers['address_detail'] !=
                                          null &&
                                      controller
                                          .controllers['address_detail']!
                                          .text
                                          .isNotEmpty) {
                                    if (value == null || value.trim().isEmpty) {
                                      return '상세주소를 입력해주세요';
                                    }
                                  } else {
                                    /*
                        if (value != null || value!.trim().isEmpty) {
                          return '주소 입력 후에 상세주소를 입력해주세요';
                        }

                         */
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Edge수량
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // 필수여부 아이콘 표시
                        Text('*', style: TextStyle(color: Colors.transparent)),
                        SizedBox(width: labelWidth, child: Text('Edge수량')),
                        Expanded(
                          child: TextFormField(
                            controller: controller.controllers['edgeCount'],
                            style: TextStyle(fontSize: 12),
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              // if (value == null || value.trim().isEmpty) {
                              //   return 'Edge수량을 입력해주세요';
                              // }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 계약일
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // 필수여부 아이콘 표시
                        Text('*', style: TextStyle(color: Colors.transparent)),
                        SizedBox(width: labelWidth, child: Text('계약일')),
                        Expanded(
                          child: TextFormField(
                            controller: controller.controllers['contractDate'],
                            style: TextStyle(fontSize: 12),
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              // if (value == null || value.trim().isEmpty) {
                              //   return '계약일을 입력해주세요';
                              // }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 약정기간
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // 필수여부 아이콘 표시
                        Text('*', style: TextStyle(color: Colors.red)),
                        SizedBox(width: labelWidth, child: Text('약정기간(개월)')),
                        Expanded(
                          child: TextFormField(
                            controller:
                                controller.controllers['contractTermMonths'],
                            inputFormatters: [
                              FilteringTextInputFormatter
                                  .digitsOnly, // 숫자만 입력 허용
                            ],
                            style: TextStyle(fontSize: 12),
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return '약정기간을 입력해주세요';
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 사용시간 시작일
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // 필수여부 아이콘 표시
                        Text('*', style: TextStyle(color: Colors.red)),
                        SizedBox(width: labelWidth, child: Text('사용기간 시작일')),
                        Expanded(
                          child: TextFormField(
                            controller:
                                controller.controllers['usageStartDate'],
                            style: TextStyle(fontSize: 12),
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: '20251101',
                              // helperText: '년-월-일 (예) 2025.11.01'
                            ),

                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return '사용기간 시작일을 입력해주세요';
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 사용시간 종료일
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // 필수여부 아이콘 표시
                        Text('*', style: TextStyle(color: Colors.red)),
                        SizedBox(width: labelWidth, child: Text('사용기간 종료일')),
                        Expanded(
                          child: TextFormField(
                            controller: controller.controllers['usageEndDate'],
                            style: TextStyle(fontSize: 12),
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: '20251201',
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return '사용기간 종료일을 입력해주세요';
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 담당자 성명
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // 필수여부 아이콘 표시
                        Text('*', style: TextStyle(color: Colors.transparent)),
                        SizedBox(width: labelWidth, child: Text('담당자 성명')),
                        Expanded(
                          child: TextFormField(
                            controller: controller.controllers['managerName'],
                            style: TextStyle(fontSize: 12),
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              /*
                                if (value == null || value.trim().isEmpty) {
                                  return '담당자 성명을 입력해주세요';
                                }

                                 */
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 담당자 직책
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // 필수여부 아이콘 표시
                        Text('*', style: TextStyle(color: Colors.transparent)),
                        SizedBox(width: labelWidth, child: Text('담당자 직책')),
                        Expanded(
                          child: TextFormField(
                            controller:
                                controller.controllers['managerPosition'],
                            style: TextStyle(fontSize: 12),
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              /*
                                if (value == null || value.trim().isEmpty) {
                                  return '담당자 직책을 입력해주세요';
                                }

                                 */
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 담당자 연락처
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // 필수여부 아이콘 표시
                        Text('*', style: TextStyle(color: Colors.transparent)),
                        SizedBox(width: labelWidth, child: Text('담당자 연락처')),
                        Expanded(
                          child: TextFormField(
                            controller:
                                controller.controllers['managerPhoneNo'],
                            style: TextStyle(fontSize: 12),
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              /*
                                if (value == null || value.trim().isEmpty) {
                                  return '담당자 연락처를 입력해주세요';
                                }

                                 */
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 월 계약금액
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // 필수여부 아이콘 표시
                        Text('*', style: TextStyle(color: Colors.transparent)),
                        SizedBox(width: labelWidth, child: Text('월 계약금액')),
                        Expanded(
                          child: TextFormField(
                            controller: controller.controllers['monthlyFee'],
                            style: TextStyle(fontSize: 12),
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              /*
                                if (value == null || value.trim().isEmpty) {
                                  return '월 계약금액을 입력해주세요';
                                }

                                 */
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 유료 메시지 수신 여부
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // 필수여부 아이콘 표시
                        Text('*', style: TextStyle(color: Colors.red)),
                        SizedBox(
                          width: labelWidth,
                          child: Text('유료 메시지 수신 여부'),
                        ),
                        Spacer(),
                        Switch(
                          value: controller.isReceivePaidMsg.value,
                          onChanged:
                              (val) => controller.isReceivePaidMsg.value = val,
                        ),
                      ],
                    ),
                  ),

                  // 빌딩 이미지 파일 첨부
                  FileAttachRow(
                    label: '빌딩 이미지',
                    labelWidth: 100,
                    fileName: controller.buildingImageFileName.value,
                    onAttach: controller.selectFile,
                    isRequired: true,
                  ),

                  // 서비스 사용 여부
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // 필수여부 아이콘 표시
                        Text('*', style: TextStyle(color: Colors.red)),
                        SizedBox(width: labelWidth, child: Text('서비스 사용 여부')),
                        Spacer(),
                        Switch(
                          value: controller.isServiceEnabled.value,
                          onChanged:
                              (val) => controller.isServiceEnabled.value = val,
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
          onPressed: () {
            Get.back();

            // Get.delete<BuildingEditController>();
            Future.microtask(() {
              if (Get.isRegistered<BuildingEditController>()) {
                Get.delete<BuildingEditController>();
              }
            });
          },
          child: const Text('취소'),
        ),
        ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              try {
                // final data = controller.collectModel();
                // final userController = BuildingController.to;

                if (mode == '등록') {
                  debugPrint('111:등록');
                  final newCustomer = controller.createBuilding();
                  // onSave(data); 또는 snackbar 시에 안닫힘
                  Get.back(result: newCustomer);
                } else {
                  try {
                    // debugPrint('update 시작');
                    final newCustomer = controller.updateBuilding();
                    Get.back(result: newCustomer);
                  } catch (e, stack) {
                    debugPrint('에러 발생: $e');
                    debugPrint('Stack: $stack');
                    // Get.snackbar('에러', '수정 중 오류 발생: $e');
                  }
                }
              } catch (e) {
                showCustomSnackbar('에러', '${mode} 중 오류 발생: $e');
              }
            }
          },
          child: Text(mode == '등록' ? '등록' : '저장'),
        ),
      ],
    );
  }
}
