import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/values/consts.dart';
import '../../../data/model/alert_category_model.dart';
import '../../../data/model/alert_level_model.dart';
import '../../../data/model/alert_status.dart';
import '../../../data/model/customer_model.dart';
import '../../../data/model/di_model.dart';
import '../../../data/model/edge_model.dart';
import '../../../data/model/user_model.dart';
import '../../../widgets/file_attach_row.dart';
import '../../building/building_controller.dart';
import '../../common/show_custom_snackbar.dart';
import '../../customer/customer_controller.dart';
import '../../edge/edge_controller.dart';
import '../di_controller.dart';
import 'di_edit_controller.dart';

class DiEditDialog extends StatelessWidget {
  final String mode; // '등록' 또는 '수정'
  final DiModel initialData;
  final void Function(DiModel) onSave;

  DiEditDialog({
    super.key,
    required this.mode,
    required this.initialData,
    required this.onSave,
  });

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final controller = DiEditController.to;
    controller.initFields(initialData);
    final labelWidth = 160.0;
    final dialogWidth = 800.0;

    final customerController = CustomerController.to;
    customerController.fetchCustomers();

    final buildingController = BuildingController.to;
    buildingController.fetchBuildings();

    final edgeController = EdgeController.to;
    edgeController.fetchEdges();

    return AlertDialog(
      title: Text('DI 정보 $mode'),
      content:

      Obx(()=>
          SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(right: 20), // 오른쪽 스크롤바 넓이 확보용
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: SCROLL_BAR_MARGIN),
                  width: dialogWidth,
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
                              // 필수여부 아이콘 표시
                              Text('*', style: TextStyle(color: Colors.red)),
                              SizedBox(width: labelWidth, child: Text('회사코드')),
                              Expanded(
                                child:
                                mode == '등록' ?
                                Obx(() {
                                  if (customerController.isLoading.value) {
                                    return const Text('로딩 중...');
                                  }
                                  if (customerController.customerList.isEmpty) {
                                    return const Text('회사 목록이 없습니다.');
                                  }
                                  return DropdownButtonFormField<String>(
                                    // value: customerController.selectedCustomerCd.value,
                                    // 안내 문구
                                    hint: const Text('회사를 선택해주세요'),
                                    decoration: const InputDecoration(
                                        // labelText: '회사 선택',
                                        border: OutlineInputBorder()),
                                    validator: (value) => value == null ? '회사를 선택하세요' : null,
                                    items:
                                    customerController.customerList.map((customer) {
                                      return DropdownMenuItem<String>(value: customer.companyCd, child: Text('${customer.companyCd}(${customer
                                          .companyName})'));
                                    }).toList(),
                                    onChanged: (value) => customerController.setSelectedCustomer(value),
                                  );
                                })
                                    :
                                // 수정 시 회사코드 수정 불가
                                TextFormField(
                                  controller: controller.controllers['companyCd'],
                                  readOnly: true,
                                  style: TextStyle(fontSize: 12),
                                  decoration: const InputDecoration(border: OutlineInputBorder()),
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


                              // 필수여부 아이콘 표시
                              Text('*', style: TextStyle(color: Colors.red)),
                              SizedBox(width: labelWidth, child: Text('빌딩코드')),
                              Expanded(
                                child:
                                mode == '등록' ?
                                Obx(() {
                                  if (buildingController.isLoading.value) {
                                    return const Text('로딩 중...');
                                  }
                                  if (buildingController.buildingList.isEmpty) {
                                    return const Text('빌딩 목록이 없습니다.');
                                  }
                                  return DropdownButtonFormField<String>(
                                    // value: customerController.selectedCustomerCd.value,
                                    hint: const Text('빌딩을 선택해주세요'),

                                    decoration: const InputDecoration(
                                        // labelText: '빌딩 선택',
                                        border: OutlineInputBorder()),
                                    validator: (value) => value == null ? '빌딩을 선택하세요' : null,


                                    items: customerController.selectedCustomerCd.value == null
                                    // 회사가 선택되지 않았을 때 → 안내 문구
                                        ? [
                                      const DropdownMenuItem<String>(
                                        value: null,
                                        child: Text('등록할 Edge의 회사를 먼저 선택해주세요'),
                                      )
                                    ]
                                    // 회사가 선택되었을 때 → 해당 회사 코드로 필터링
                                        : (() {
                                      final filteredList = buildingController.buildingList
                                          .where((e) =>
                                      e.companyCd == customerController.selectedCustomerCd.value)
                                          .toList();

                                      // 필터링 결과가 없을 때 안내 문구 노출
                                      if (filteredList.isEmpty) {
                                        return [
                                          const DropdownMenuItem<String>(
                                            value: null,
                                            child: Text('선택한 회사의 빌딩이 존재하지 않습니다.'),
                                          )
                                        ];
                                      }

                                      // 결과가 있을 때 DropdownMenuItem 생성
                                      return filteredList
                                          .map((building) => DropdownMenuItem<String>(
                                        value: building.buildingCd,
                                        child: Text('${building.buildingCd} (${building.buildingName})'),
                                      ))
                                          .toList();
                                    })(),


                                    onChanged: (value) => buildingController.setSelectedBuilding(value),
                                  );
                                })
                                    :
                                // 수정 시 회사코드 수정 불가
                                TextFormField(
                                  controller: controller.controllers['companyCd'],
                                  readOnly: true,
                                  style: TextStyle(fontSize: 12),
                                  decoration: const InputDecoration(border: OutlineInputBorder()),
                                ),

                              ),
                            ],
                          ),
                        ),


                        // Edge코드
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [


                              // 필수여부 아이콘 표시
                              Text('*', style: TextStyle(color: Colors.red)),
                              SizedBox(width: labelWidth, child: Text('Edge코드')),
                              Expanded(
                                child:
                                mode == '등록' ?
                                Obx(() {
                                  if (edgeController.isLoading.value) {
                                    return const Text('로딩 중...');
                                  }
                                  if (edgeController.edgeList.isEmpty) {
                                    return const Text('Edge 목록이 없습니다.');
                                  }
                                  return DropdownButtonFormField<String>(
                                    // value: customerController.selectedCustomerCd.value,
                                    hint: const Text('Edge를 선택해주세요'),

                                    decoration: const InputDecoration(
                                        // labelText: 'Edge 선택',
                                        border: OutlineInputBorder()),
                                    validator: (value) => value == null ? 'Edge를 선택하세요' : null,


                                    items: buildingController.selectedBuildingCd.value == null
                                    // 빌딩이 선택되지 않았을 때 → 안내 문구
                                        ? [
                                      const DropdownMenuItem<String>(
                                        value: null,
                                        child: Text('빌딩을 먼저 선택해주세요'),
                                      )
                                    ]
                                    // 회사가 선택되었을 때 → 해당 회사 코드로 필터링
                                        : (() {
                                      final filteredList = edgeController.edgeList
                                          .where((e) =>
                                      e.buildingCd == buildingController.selectedBuildingCd.value)
                                          .toList();

                                      // 필터링 결과가 없을 때 안내 문구 노출
                                      if (filteredList.isEmpty) {
                                        return [
                                          const DropdownMenuItem<String>(
                                            value: null,
                                            child: Text('선택한 빌딩에 Edge가 존재하지 않습니다.'),
                                          )
                                        ];
                                      }

                                      // 결과가 있을 때 DropdownMenuItem 생성
                                      return filteredList
                                          .map((edge) => DropdownMenuItem<String>(
                                        value: edge.edgeCd,
                                        child: Text('${edge.edgeCd} (${edge.edgeName})'),
                                      ))
                                          .toList();
                                    })(),


                                    onChanged: (value) => edgeController.setSelectedEdge(value),
                                  );
                                })
                                    :
                                // 수정 시 Edge 수정 불가
                                TextFormField(
                                  controller: controller.controllers['edgeCd'],
                                  readOnly: true,
                                  style: TextStyle(fontSize: 12),
                                  decoration: const InputDecoration(border: OutlineInputBorder()),
                                ),

                              ),
                            ],
                          ),
                        ),

                        // DI번호
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // 필수여부 아이콘 표시
                          const Text('*', style: TextStyle(color: Colors.red)),
                          SizedBox(width: labelWidth, child: const Text('DI번호')),
                          Expanded(
                            child:
                            mode == '등록' ?
                            DropdownButtonFormField<int>(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) => value == null ? 'DI 번호를 선택하세요' : null,
                              style: const TextStyle(fontSize: 12, color: Colors.black),
                              value: () {
                                final currentValue = int.tryParse(controller.controllers['diNo']?.text ?? '');
                                return (currentValue != null && currentValue >= 1 && currentValue <= 16)
                                    ? currentValue
                                    : null;
                              }(),
                              items: List.generate(
                                16,  // di 수
                                    (index) => DropdownMenuItem(
                                  value: index + 1,
                                  child: Text('${index + 1}'),
                                ),
                              ),
                              onChanged: (value) {
                                if (value != null) {
                                  debugPrint('########################선택한 di no:[${value}]');
                                  (mode == '등록')?controller.selectedDiNo.value = value : controller.controllers['diNo']?.text = value.toString();
                                  debugPrint('########################선택한 controller.controllers[diNo]?.text:[${controller.controllers['diNo']?.text}]');
                                }
                              },
                            )
                                :
                            // 수정 시 Edge 수정 불가
                            TextFormField(
                              controller: controller.controllers['diNo'],
                              readOnly: true,
                              style: TextStyle(fontSize: 12),
                              decoration: const InputDecoration(border: OutlineInputBorder()),
                            ),

                          ),
                        ],
                      ),
                    ),

                        // DI명칭
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // 필수여부 아이콘 표시
                              Text('*', style: TextStyle(color: Colors.red)),
                              SizedBox(width: labelWidth, child: Text('DI명칭')),
                              Expanded(
                                child: TextFormField(
                                  controller: controller.controllers['diName'],
                                  style: TextStyle(fontSize: 12),
                                  decoration: const InputDecoration(border: OutlineInputBorder()),
                                  validator: (value) {

                                    if (value == null || value.trim().isEmpty) {
                                      return 'DI명을 입력해주세요';
                                    }
                                    if (value.length > 20) {
                                      return '20자리 이내로 입력해주세요';
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Floor정보
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // 필수여부 아이콘 표시
                              Text('*', style: TextStyle(color: Colors.transparent)),
                              SizedBox(width: labelWidth, child: Text('Floor정보')),
                              Expanded(
                                child: TextFormField(
                                  controller: controller.controllers['floorInfo'],
                                  style: TextStyle(fontSize: 12),
                                  decoration: const InputDecoration(border: OutlineInputBorder()),
                                  validator: (value) {

                                    // if (value == null || value.trim().isEmpty) {
                                    //   return 'Floor정보를 입력해주세요';
                                    // }
                                    if (value!.length > 10) {
                                      return '10자리 이내로 입력해주세요';
                                    }

                                  },
                                ),
                              ),
                            ],
                          ),
                        ),

                        // MAP 이미지 파일 첨부
                        FileAttachRow(
                          label: 'Map 이미지',
                          labelWidth: 100,
                          fileName: controller.pickedMapFile.value?.fileName,
                          onAttach: controller.selectMapFile,
                          isRequired: false,
                        ),

                        // SOP 이미지 파일 첨부
                        FileAttachRow(
                          label: 'SOP 이미지',
                          labelWidth: 100,
                          fileName: controller.pickedSopFile.value?.fileName,
                          onAttach: controller.selectSopFile,
                          isRequired: false,
                        ),

                        // 경보등급
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // 필수여부 아이콘 표시
                          const Text('*', style: TextStyle(color: Colors.red)),
                          SizedBox(width: labelWidth, child: const Text('경보등급')),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              decoration: const InputDecoration(border: OutlineInputBorder()),
                              style: const TextStyle(fontSize: 14, color: Colors.black),
                              // 힌트 텍스트
                              hint: const Text('경보등급을 선택해주세요'),
                              // 초기값: controller의 값이 있을 때 설정
                              value: controller.controllers['alertLevelCd']?.text.isNotEmpty == true
                                  ? controller.controllers['alertLevelCd']!.text
                                  : null,

                              // alertLevels 리스트로 DropdownMenuItem 생성
                              items: alertLevels
                                  .map(
                                    (level) => DropdownMenuItem<String>(
                                  value: level.value, // ex) '1', '2', '3', '4'
                                  child: Text('${level.label}(${level.value})'), // ex) '관심', '주의'
                                ),
                              )
                                  .toList(),

                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return '경보등급을 선택해주세요';
                                }
                                return null;
                              },

                              // 선택 시 controller에 값 저장
                              onChanged: (value) {
                                controller.controllers['alertLevelCd']?.text = value ?? '';
                              },
                            ),
                          ),
                        ],
                      ),
                    ),


                        // 경보분류
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // 필수여부 아이콘 표시
                          const Text('*', style: TextStyle(color: Colors.red)),
                          SizedBox(width: labelWidth, child: const Text('경보분류')),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              decoration: const InputDecoration(border: OutlineInputBorder()),
                              style: const TextStyle(fontSize: 14, color: Colors.black),
                              hint: const Text('경보분류를 선택해주세요'),

                              // 초기값 설정 (controller 값이 비어있지 않을 때)
                              value: controller.controllers['alertCategoryCd']?.text.isNotEmpty == true
                                  ? controller.controllers['alertCategoryCd']!.text
                                  : null,

                              // alertCategories 리스트를 DropdownMenuItem으로 변환
                              items: alertCategories
                                  .map(
                                    (category) => DropdownMenuItem<String>(
                                  value: category.value, // ex) '01', '02', '03'
                                  child: Text('${category.label}(${category.value})'), // ex) '소방설비', '냉난방설비'
                                ),
                              )
                                  .toList(),

                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return '경보분류를 선택해주세요';
                                }
                                return null;
                              },

                              // 선택 시 controller 값 갱신
                              onChanged: (value) {
                                controller.controllers['alertCategoryCd']?.text = value ?? '';
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 경보 수신 여부
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // 필수여부 아이콘 표시
                              Text('*', style: TextStyle(color: Colors.red)),
                              SizedBox(width: labelWidth, child: Text('경보 수신 여부')),
                              Spacer(),
                              Switch(
                                value: controller.isAlertReceivable.value,
                                onChanged: (val) => controller.isAlertReceivable.value = val,
                              ),
                            ],
                          ),
                        ),

                        // 경보 상태 구분
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // 필수여부 아이콘 표시
                              Text('*', style: TextStyle(color: Colors.red)),
                              SizedBox(width: labelWidth, child: Text('경보 상태 구분')),
                              Expanded(
                                child:
                                DropdownButtonFormField<String>(
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    // labelText: '경보 상태',
                                  ),
                                  hint: const Text('경보 상태를 선택해주세요'),
                                  value: controller.controllers['alertStatusType']?.text.isNotEmpty == true
                                      ? controller.controllers['alertStatusType']!.text
                                      : null,
                                  items: alertStatuses
                                      .map(
                                        (status) => DropdownMenuItem<String>(
                                      value: status.value,
                                      child: Text(status.label),
                                    ),
                                  )
                                      .toList(),
                                  validator: (value) =>
                                  value == null || value.trim().isEmpty ? '경보 상태를 선택해주세요' : null,
                                  onChanged: (value) {
                                    controller.controllers['alertStatusType']?.text = value ?? '';
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),

                        // 기본 연결 문자열
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // 필수여부 아이콘 표시
                              Text('*', style: TextStyle(color: Colors.transparent)),
                              SizedBox(width: labelWidth, child: Text('기본 연결 문자열')),
                              Expanded(
                                child:
                                TextFormField(
                                  readOnly: true,
                                  controller: controller.controllers['defaultConnectionString'],
                                  style: TextStyle(fontSize: 12),
                                  decoration: const InputDecoration(border: OutlineInputBorder()),
                                  validator: (value) {
                                    // if (value == null || value.trim().isEmpty) {
                                    //   return '기본 연결 문자열을 입력해주세요';
                                    // }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),




                      ],
                    ),

                  ),
                ),
              )
          ),),


      actions: [
        TextButton(
          onPressed: () {
            Get.back();
            Get.delete<DiEditController>();
          },
          child: const Text('취소'),
        ),
        ElevatedButton(
          onPressed: ()  async {
            if (_formKey.currentState!.validate()) {
              try {

                if (mode == '등록') {
                  debugPrint('111:등록');
                  final newDi = await controller.createDi();
                  onSave(newDi!);

                  debugPrint('newDi==============>:${newDi.toJson().toString()}');
                  // DiController.to.diList.add(newDi!);
                  // DiController.to.diList.refresh();

                  showCustomSnackbar('성공', 'DI 정보 등록이 완료 되었습니다.');


                  // 연속 입력 가능하게Get.back(result: newDi);
                } else {
                  try {
                    debugPrint('update 시작');
                    final newDi = controller.updateDi();
                    Get.back(result: newDi);

                  } catch (e, stack) {
                    debugPrint('에러 발생: $e');
                    debugPrint('Stack: $stack');
                    // Get.snackbar('에러', '수정 중 오류 발생: $e');
                  }
                }
              } catch (e) {
                if (e is DioException) {
                  if (e.response?.statusCode == 409) {
                    showCustomSnackbar('오류', '동일한 DI정보가 이미 등록되어 있습니다.(${e.response?.statusCode})');

                  } else {
                    showCustomSnackbar('오류', '데이터베이스 에러가 발생 했습니다.(${e.response?.statusCode})');
                  }
                } else {
                  // 다른 예외 처리
                  print('Unexpected error: $e');
                  showCustomSnackbar('에러', '${mode} 중 오류 발생(${e.toString()})');
                }



              }
            }
          },
          child: Text(mode == '등록' ? '등록' : '저장'),
        ),
      ],
    );
  }
}
