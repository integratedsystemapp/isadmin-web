import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/values/consts.dart';
import '../../../data/model/edge_model.dart';
import '../../building/building_controller.dart';
import '../../customer/customer_controller.dart';
import '../edge_controller.dart';
import 'edge_edit_controller.dart';

class EdgeEditDialog extends StatelessWidget {
  final String mode; // '등록' 또는 '수정'
  final EdgeModel initialData;
  final void Function(EdgeModel) onSave;

  EdgeEditDialog({
    super.key,
    required this.mode,
    required this.initialData,
    required this.onSave,
  });

  final _formKey = GlobalKey<FormState>();
  final double _labelWidth = 160.0;
  final double _dialogWidth = 800.0;

  // 로딩시에 필드 높이를 유지하며 오른쪽에 작은 스피너만 표시
  Widget _loadingField(String label) {
    return TextFormField(
      enabled: false,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        isDense: true,
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 8),
          child: SizedBox(
            width: 16,
            height: 16,
            child: const CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      ),
    );
  }

  InputDecoration _denseInput({String? label}) => InputDecoration(
    labelText: label,
    border: const OutlineInputBorder(),
    isDense: true,
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
  );

  @override
  Widget build(BuildContext context) {
    final controller = EdgeEditController.to;
    controller.initFields(initialData);

    final customerController = CustomerController.to..fetchCustomers();
    final buildingController = BuildingController.to..fetchBuildings();

    return AlertDialog(
      title: Text('Edge 정보 $mode'),
      content: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(right: 20), // 오른쪽 스크롤바 넓이 확보
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: SCROLL_BAR_MARGIN),
            width: _dialogWidth,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // 회사코드
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text('*', style: TextStyle(color: Colors.red)),
                        SizedBox(width: _labelWidth, child: const Text('회사코드')),
                        Expanded(
                          child: mode == '등록'
                              ? Obx(() {
                            if (customerController.isLoading.value) {
                              return _loadingField('회사 목록 불러오는 중...');
                            }
                            if (customerController.customerList.isEmpty) {
                              return const Text('회사 목록이 없습니다.');
                            }
                            return DropdownButtonFormField<String>(
                              isDense: true,
                              decoration: _denseInput(label: '회사 선택'),
                              validator: (value) =>
                              value == null ? '회사를 선택하세요' : null,
                              items: customerController.customerList
                                  .map((customer) => DropdownMenuItem<String>(
                                value: customer.companyCd,
                                child: Text(
                                    '${customer.companyCd} (${customer.companyName})'),
                              ))
                                  .toList(),
                              onChanged: (value) =>
                                  customerController.setSelectedCustomer(value),
                            );
                          })
                              : TextFormField(
                            controller: controller.controllers['companyCd'],
                            readOnly: true,
                            style: const TextStyle(fontSize: 12),
                            decoration: _denseInput(),
                          ),
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
                        SizedBox(width: _labelWidth, child: const Text('빌딩코드')),
                        Expanded(
                          child: mode == '등록'
                              ? Obx(() {
                            if (buildingController.isLoading.value) {
                              return _loadingField('빌딩 목록 불러오는 중...');
                            }
                            if (buildingController.buildingList.isEmpty) {
                              return const Text('빌딩 목록이 없습니다.');
                            }

                            final selectedCompany =
                                customerController.selectedCustomerCd.value;

                            // 회사 선택 전/후 분기
                            if (selectedCompany == null) {
                              return DropdownButtonFormField<String>(
                                isDense: true,
                                decoration:
                                _denseInput(label: '빌딩 선택'),
                                validator: (value) =>
                                value == null ? '빌딩을 선택하세요' : null,
                                items: const [
                                  DropdownMenuItem<String>(
                                    value: null,
                                    child: Text('등록할 Edge의 회사를 먼저 선택해주세요'),
                                  )
                                ],
                                onChanged: (_) {},
                              );
                            }

                            // 회사 선택 후 해당 회사의 빌딩만 노출
                            final filteredList = buildingController.buildingList
                                .where((e) => e.companyCd == selectedCompany)
                                .toList();

                            if (filteredList.isEmpty) {
                              return DropdownButtonFormField<String>(
                                isDense: true,
                                decoration: _denseInput(label: '빌딩 선택'),
                                validator: (value) =>
                                value == null ? '빌딩을 선택하세요' : null,
                                items: const [
                                  DropdownMenuItem<String>(
                                    value: null,
                                    child: Text('선택한 회사의 빌딩이 존재하지 않습니다.'),
                                  )
                                ],
                                onChanged: (_) {},
                              );
                            }

                            return DropdownButtonFormField<String>(
                              isDense: true,
                              decoration: _denseInput(label: '빌딩 선택'),
                              validator: (value) =>
                              value == null ? '빌딩을 선택하세요' : null,
                              items: filteredList
                                  .map((b) => DropdownMenuItem<String>(
                                value: b.buildingCd,
                                child: Text(
                                    '${b.buildingCd} (${b.buildingName})'),
                              ))
                                  .toList(),
                              onChanged: (value) =>
                                  buildingController.setSelectedBuilding(value),
                            );
                          })
                              : TextFormField(
                            controller: controller.controllers['buildingCd'],
                            readOnly: true,
                            style: const TextStyle(fontSize: 12),
                            decoration: _denseInput(),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Edge코드 (수정만 표시)
                  if (mode == '수정')
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text('*', style: TextStyle(color: Colors.red)),
                          SizedBox(width: _labelWidth, child: const Text('Edge코드')),
                          Expanded(
                            child: TextFormField(
                              controller: controller.controllers['edgeCd'],
                              readOnly: true,
                              style: const TextStyle(fontSize: 12),
                              decoration: _denseInput(),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Edge코드를 입력해주세요';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Edge명칭
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text('*', style: TextStyle(color: Colors.red)),
                        SizedBox(width: _labelWidth, child: const Text('Edge명칭')),
                        Expanded(
                          child: TextFormField(
                            controller: controller.controllers['edgeName'],
                            style: const TextStyle(fontSize: 12),
                            decoration: _denseInput(),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Edge명을 입력해주세요';
                              }
                              if (value.length > 30) {
                                return '30자리 이내로 입력해주세요';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 기본 연결 문자열 (수정만)
                  // if (mode == '수정')
                  //   Padding(
                  //     padding: const EdgeInsets.symmetric(vertical: 6),
                  //     child: Row(
                  //       crossAxisAlignment: CrossAxisAlignment.center,
                  //       children: [
                  //         const Text('*',
                  //             style: TextStyle(color: Colors.transparent)),
                  //         SizedBox(
                  //             width: _labelWidth,
                  //             child: const Text('기본 연결 문자열')),
                  //         Expanded(
                  //           child: TextFormField(
                  //             controller:
                  //             controller.controllers['defaultConnectionString'],
                  //             readOnly: true,
                  //             style: const TextStyle(fontSize: 12),
                  //             decoration: _denseInput(),
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),

                  // Edge 설치 위치
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text('*',
                            style: TextStyle(color: Colors.transparent)),
                        SizedBox(
                            width: _labelWidth,
                            child: const Text('Edge설치위치')),
                        Expanded(
                          child: TextFormField(
                            controller: controller.controllers['edgeInstallLocation'],
                            style: const TextStyle(fontSize: 12),
                            decoration: _denseInput(),
                          ),
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
            Get.delete<EdgeEditController>();
          },
          child: const Text('취소'),
        ),
        ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              try {
                if (mode == '등록') {
                  final newEdge = controller.createEdge();
                  Get.back(result: newEdge);
                } else {
                  final updatedEdge = controller.updateEdge();
                  Get.back(result: updatedEdge);
                }
              } catch (e) {
                Get.snackbar('에러', '처리 중 오류 발생: $e');
              }
            }
          },
          child: Text(mode == '등록' ? '등록' : '저장'),
        ),
      ],
    );
  }
}
