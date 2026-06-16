// import 'dart:core' as DateFormatUtil;
//
// import 'package:data_table_2/data_table_2.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../core/values/consts.dart';
// import '../../data/model/building_model.dart';
// import '../common/show_custom_snackbar.dart';
// import '../common/widget/TableCellText.dart';
// import '../common/widget/TableColumnText.dart';
// import '../common/widget/confirm_delete.dart';
// import 'building_controller.dart';
// import 'edit/building_edit_dialog.dart';
//
// class BuildingScreen extends StatelessWidget {
//   const BuildingScreen({super.key});
//
//   @DateFormatUtil.override
//   Widget build(BuildContext context) {
//     final controller = BuildingController.to;
//
//     return Scaffold(
//       appBar: AppBar(
//         titleSpacing: 0,
//         automaticallyImplyLeading: false,
//         title: Row(
//           children: [
//             const Spacer(),
//             /*
//             등록
//              */
//             ElevatedButton(
//               onPressed: () async {
//                 // 등록 로직
//                 final result = await showDialog(
//                   context: context,
//                   builder:
//                       (_) => BuildingEditDialog(
//                     mode: '등록',
//                     initialData: BuildingModel(companyCd: '', buildingCd: '', buildingName: '',
//                         contractTermMonths: 0,
//                         usageStartDate: null,
//                         // usageStartDate: DateFormatUtil.DateTime.parse('2025-11-01'),
//                         usageEndDate: null,
//                         // usageEndDate: DateFormatUtil.DateTime.parse('2025-11-01'),
//                         isReceivePaidMsg: 'Y',
//                         isServiceEnabled: 'Y'),
//                     onSave: (updated) {
//                       debugPrint('저장된 데이터: $updated');
//
//                       controller.buildingList.add(updated);
//                     },
//                   ),
//                 );
//
//                 if (result != null) {
//                   controller.buildingList.add(result);
//                   showCustomSnackbar('성공', '빌딩 정보 등록이  완료 되었습니다.');
//                 } else {
//                   showCustomSnackbar('성공', '빌딩 정보 등록이 실패 했습니다.');
//                 }
//
//
//               },
//               child: const Text('등록'),
//             ),
//             const SizedBox(width: 8),
//             /*
//             수정
//              */
//             ElevatedButton(
//               onPressed: () async {
//                 // 수정 로직
//                 if (controller.selected.isNotEmpty) {
//                   final _building = controller.getSelected()!;
//                   final result = await showDialog(
//                     context: context,
//                     builder:
//                         (_) => BuildingEditDialog(
//                       mode: '수정',
//                       initialData: _building, // 첫 번째 고객 데이터로 초기화
//                       // initialData: selectedCustomerData,
//                       onSave: (updated) {
//                         debugPrint('저장된 데이터: $updated');
//
//                       },
//                     ),
//                   );
//
//                   debugPrint('===================================>');
//                   if (result != null) {
//                     final _index = controller.buildingList.indexWhere((e) => e.buildingCd == result.buildingCd);
//
//                     debugPrint('=====>${result.toString()}');
//                     debugPrint('_index:${_index}');
//
//                     if (_index >= 0) {
//                       controller.buildingList[_index] = result;
//                       showCustomSnackbar('성공', '빌딩 정보 수정이  완료 되었습니다.');
//                     } else {
//                       showCustomSnackbar('성공', '빌딩 정보 수정이 실패 했습니다.');
//                     }
//
//                   }
//
//                 } else {
//                   showCustomSnackbar('안내', '수정 할 빌딩을 선택 해 주세요');
//                 }
//               },
//               child: const Text('수정'),
//             ),
//             const SizedBox(width: 8),
//             /*
//             상단 삭제 버튼
//              */
//             ElevatedButton(
//               onPressed: () async {
//                 // 삭제 로직
//                 if (controller.selected.isNotEmpty) {
//                   final _building = controller.getSelected()!;
//                   final result = await confirmDelete('');
//                   if (result == true) {
//                     try {
//                       await controller.deleteBuilding(_building);
//                       debugPrint('삭제 성공!');
//                       final index = controller.buildingList.indexWhere((e) => e.buildingCd == _building.buildingCd);
//                       if (index >= 0) {
//                         controller.buildingList.removeAt(index);
//                       }
//                       // showCustomSnackbar('성공', '빌딩 정보 삭제가  완료 되었습니다.');
//                     } catch (e) {
//                       debugPrint('삭제 실패 또는 취소됨: $e');
//                       // showCustomSnackbar('오류', '빌딩 정보 삭제가 실패 했습니다.: $e');
//                     }
//                   }
//                 } else {
//                   showCustomSnackbar('안내', '삭제 할 빌딩을 선택 해 주세요');
//                 }
//               },
//               child: const Text('삭제'),
//             ),
//             const SizedBox(width: 16),
//           ],
//         ),
//       ),
//
//       body: Padding(
//           padding: const EdgeInsets.all(DATATABLE_MARGIN),
//           child: Obx(() {
//             return DataTable2(
//               scrollController: controller.controller,
//               horizontalScrollController: controller.horizontalController,
//               columnSpacing: 0,
//               // horizontalMargin: 12,
//               // bottomMargin: 10,
//               minWidth: 2200,
//               // headingRowColor: MaterialStateProperty.all(Colors.grey.shade200), // 헤더 배경색
//
//               sortColumnIndex: controller.sortColumnIndex,
//               sortAscending: controller.sortAscending,
//               columns: const [
//                 DataColumn2(label: Center(child: TableColumnText('선택')), fixedWidth: 50),
//                 DataColumn2(label: Center(child: TableColumnText('회사코드')), fixedWidth: 100),
//                 DataColumn2(label: Center(child: TableColumnText('빌딩코드')), fixedWidth: 150),
//                 DataColumn2(label: Center(child: TableColumnText('빌딩명')), fixedWidth: 150),
//                 DataColumn2(label: Center(child: TableColumnText('빌딩주소')), fixedWidth: 100),
//                 DataColumn2(label: Center(child: TableColumnText('Edge수량')), fixedWidth: 100),
//                 DataColumn2(label: Center(child: TableColumnText('계약일')), fixedWidth: 100),
//                 DataColumn2(label: Center(child: TableColumnText('약정기간')), fixedWidth: 100),
//                 DataColumn2(label: Center(child: TableColumnText('사용기간\n시작일')), fixedWidth: 100),
//                 DataColumn2(label: Center(child: TableColumnText('사용기간\n종료일')), fixedWidth: 100),
//                 DataColumn2(label: Center(child: TableColumnText('담당자\n성명')), fixedWidth: 100),
//                 DataColumn2(label: Center(child: TableColumnText('담당자\n직책')), fixedWidth: 100),
//                 DataColumn2(label: Center(child: TableColumnText('담당자\n연락처')), fixedWidth: 100),
//                 DataColumn2(label: Center(child: TableColumnText('월 계약금액')), fixedWidth: 100),
//                 DataColumn2(label: Center(child: TableColumnText('유료 메시지\n수신여부')), fixedWidth: 100),
//                 DataColumn2(label: Center(child: TableColumnText('빌딩이미지')), fixedWidth: 100),
//                 DataColumn2(label: Center(child: TableColumnText('서비스\n사용여부')), fixedWidth: 100),
//                 DataColumn2(label: Center(child: TableColumnText('등록일')), fixedWidth: 150),
//                 DataColumn2(label: Center(child: TableColumnText('수정일')), fixedWidth: 150),
//
//                 // ...columns.map((title) => DataColumn2(label: Text(title)))
//               ],
//               rows: DateFormatUtil.List.generate(controller.buildingList.length, (index) {
//                 final customer = controller.buildingList[index];
//                 return DataRow2.byIndex(
//                   index: index,
//                   selected: controller.isSelected(index),
//                   onTap: () => controller.toggleSelection(index),
//
//                   cells:
//                   [
//                     DataCell(Center(child: Checkbox(value: controller.isSelected(index), onChanged: (_) => controller.toggleSelection(index)))),
//                     DataCell(Center(child: TableCellText(customer.companyCd))),
//                     DataCell(Center(child: TableCellText(customer.buildingCd))),
//                     DataCell(Center(child: TableCellText(customer.buildingName))),
//                     DataCell((customer.addressInfo().isNotEmpty)?Tooltip(message: customer.addressInfo(),child: Center(child: TableCellText
//                       (customer.addressInfo()))):Text(customer.addressInfo())),
//                     DataCell(Center(child: TableCellText(customer.edgeCount?.toString() ?? ''))),
//                     DataCell(Center(child: TableCellText(customer.contractDate?.toIso8601String().split('T')[0] ?? ''))),
//                     DataCell(Center(child: TableCellText(customer.contractTermMonths.toString() ?? ''))),
//                     DataCell(Center(child: TableCellText(customer.usageStartDate!.toIso8601String().split('T')[0]))),
//                     DataCell(Center(child: TableCellText(customer.usageEndDate!.toIso8601String().split('T')[0]))),
//                     DataCell(Center(child: TableCellText(customer.managerName ?? ''))),
//                     DataCell(Center(child: TableCellText(customer.managerPosition ?? ''))),
//                     DataCell(Center(child: TableCellText(customer.managerPhoneNo ?? ''))),
//                     DataCell(Center(child: TableCellText(customer.monthlyFee.toString() ?? ''))),
//                     DataCell(Center(child: TableCellText(customer.isReceivePaidMsg))),
//                     DataCell(Center(child: TableCellText(customer.buildingImageFileName ?? ''))),
//                     DataCell(Center(child: TableCellText(customer.isServiceEnabled))),
//                     DataCell(Center(child: TableCellText(customer.formatCreateAt()))),
//                     DataCell(Center(child: TableCellText(customer.formatUpdatedAt()))),
//                   ].map((cell) => DataCell(DefaultTextStyle.merge(style: TextStyle(fontSize: 14), child: cell.child))).toList(),
//                 );
//               }),
//             );
//           }),
//         ),
//
//     );
//   }
// }

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/values/consts.dart';
import '../../data/model/building_model.dart';
import '../common/show_custom_snackbar.dart';
import '../common/widget/TableCellText.dart';
import '../common/widget/TableColumnText.dart';
import '../common/widget/confirm_delete.dart';
import 'building_controller.dart';
import 'edit/building_edit_dialog.dart';

class BuildingScreen extends StatelessWidget {
  const BuildingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = BuildingController.to;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [

            SizedBox(width: 10,),
            Text('빌딩 관리', style: TextStyle(color: Colors.black),),


            const Spacer(),

            // 등록
            ElevatedButton(
              onPressed: () async {
                final result = await showDialog(
                  context: context,
                  builder: (_) => BuildingEditDialog(
                    mode: '등록',
                    initialData: BuildingModel(
                      companyCd: '',
                      buildingCd: '',
                      buildingName: '',
                      contractTermMonths: 0,
                      usageStartDate: null,
                      usageEndDate: null,
                      isReceivePaidMsg: 'Y',
                      isServiceEnabled: 'Y',
                    ),
                    onSave: (updated) {
                      // 모달 내부 저장 콜백(옵션)
                    },
                  ),
                );

                if (result != null) {
                  controller.buildingList.add(result);
                  showCustomSnackbar('성공', '빌딩 정보 등록이 완료되었습니다.');
                } else {
                  showCustomSnackbar('실패', '빌딩 정보 등록이 실패했습니다.');
                }
              },
              child: const Text('등록'),
            ),
            const SizedBox(width: 8),

            // 수정
            ElevatedButton(
              onPressed: () async {
                if (controller.selected.isNotEmpty) {
                  final selected = controller.getSelected()!;
                  final result = await showDialog(
                    context: context,
                    builder: (_) => BuildingEditDialog(
                      mode: '수정',
                      initialData: selected,
                      onSave: (updated) {},
                    ),
                  );

                  if (result != null) {
                    final idx = controller.buildingList
                        .indexWhere((e) => e.buildingCd == result.buildingCd);
                    if (idx >= 0) {
                      controller.buildingList[idx] = result;
                      showCustomSnackbar('성공', '빌딩 정보 수정이 완료되었습니다.');
                    } else {
                      showCustomSnackbar('실패', '빌딩 정보 수정이 실패했습니다.');
                    }
                  }
                } else {
                  showCustomSnackbar('안내', '수정할 빌딩을 선택해주세요.');
                }
              },
              child: const Text('수정'),
            ),
            const SizedBox(width: 8),

            // 삭제
            ElevatedButton(
              onPressed: () async {
                if (controller.selected.isNotEmpty) {
                  final target = controller.getSelected()!;
                  final result = await confirmDelete(target.buildingCd);
                  if (result == true) {
                    try {
                      await controller.deleteBuilding(target);
                      final index = controller.buildingList
                          .indexWhere((e) => e.buildingCd == target.buildingCd);
                      if (index >= 0) {
                        controller.buildingList.removeAt(index);
                      }
                      showCustomSnackbar('성공', '빌딩 정보 삭제가 완료되었습니다.');
                    } catch (e) {
                      showCustomSnackbar('오류', '빌딩 정보 삭제에 실패했습니다: $e');
                    }
                  }
                } else {
                  showCustomSnackbar('안내', '삭제할 빌딩을 선택해주세요.');
                }
              },
              child: const Text('삭제'),
            ),
            const SizedBox(width: 16),
          ],
        ),
      ),

      // ===== 본문: 좌우 여백 없이, 브라우저 폭에 맞춰 확장 =====
      body: SafeArea(
        left: false,
        right: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            // 브라우저 뷰포트 너비와 비교해서 minWidth 결정
            final double tableMinWidth =
            constraints.maxWidth > 2520 ? constraints.maxWidth : 2520;

            return Obx(() {
              return Container(
                padding: EdgeInsets.zero, // 좌우 여백 제거
                width: double.infinity,
                child: DataTable2(
                  scrollController: controller.controller,
                  horizontalScrollController: controller.horizontalController,

                  horizontalMargin: 0,
                  columnSpacing: 0,
                  minWidth: tableMinWidth,

                  // 컨트롤러 구현 형태에 맞춰 그대로 사용
                  sortColumnIndex: controller.sortColumnIndex,
                  sortAscending: controller.sortAscending,

                  columns: const [
                    DataColumn2(
                      label: Center(child: TableColumnText('선택')),
                      fixedWidth: 50,
                    ),
                    DataColumn2(
                      label: Center(child: TableColumnText('회사코드')),
                      fixedWidth: 100,
                    ),
                    DataColumn2(
                      label: Center(child: TableColumnText('회사명')),
                      fixedWidth: 150,
                    ),
                    DataColumn2(
                      label: Center(child: TableColumnText('빌딩코드')),
                      fixedWidth: 150,
                    ),
                    DataColumn2(
                      label: Center(child: TableColumnText('빌딩명')),
                      fixedWidth: 150,
                    ),

                    // 빌딩주소: 유동폭(남는 공간 흡수)
                    DataColumn2(
                      label: Center(child: TableColumnText('빌딩주소')),
                      fixedWidth: 200,
                    ),

                    DataColumn2(
                      label: Center(child: TableColumnText('Edge수량')),
                      fixedWidth: 100,
                    ),
                    DataColumn2(
                      label: Center(child: TableColumnText('계약일')),
                      fixedWidth: 100,
                    ),
                    DataColumn2(
                      label: Center(child: TableColumnText('약정기간')),
                      fixedWidth: 100,
                    ),
                    DataColumn2(
                      label: Center(child: TableColumnText('사용기간\n시작일')),
                      fixedWidth: 120,
                    ),
                    DataColumn2(
                      label: Center(child: TableColumnText('사용기간\n종료일')),
                      fixedWidth: 120,
                    ),
                    DataColumn2(
                      label: Center(child: TableColumnText('담당자\n성명')),
                      fixedWidth: 110,
                    ),
                    DataColumn2(
                      label: Center(child: TableColumnText('담당자\n직책')),
                      fixedWidth: 110,
                    ),
                    DataColumn2(
                      label: Center(child: TableColumnText('담당자\n연락처')),
                      fixedWidth: 130,
                    ),
                    DataColumn2(
                      label: Center(child: TableColumnText('월 계약금액')),
                      fixedWidth: 120,
                    ),
                    DataColumn2(
                      label: Center(child: TableColumnText('유료 메시지\n수신여부')),
                      fixedWidth: 120,
                    ),

                    // 빌딩이미지: 유동폭으로 두면 좌우 여백 없이 꽉 차는 데 도움됨
                    DataColumn2(
                      label: Center(child: TableColumnText('빌딩이미지')),
                      fixedWidth: 120,

                    ),

                    DataColumn2(
                      label: Center(child: TableColumnText('서비스\n사용여부')),
                      fixedWidth: 120,
                    ),
                    DataColumn2(
                      label: Center(child: TableColumnText('등록일')),
                      fixedWidth: 150,
                    ),
                    DataColumn2(
                      label: Center(child: TableColumnText('수정일')),
                      fixedWidth: 150,
                    ),
                  ],

                  rows: List.generate(controller.buildingList.length, (index) {
                    final b = controller.buildingList[index];

                    final address = b.addressInfo();
                    final contractDate =
                        b.contractDate?.toIso8601String().split('T').first ?? '-';
                    final usageStart =
                        b.usageStartDate?.toIso8601String().split('T').first ?? '-';
                    final usageEnd =
                        b.usageEndDate?.toIso8601String().split('T').first ?? '-';
                    final monthlyFeeStr = (b.monthlyFee == null)
                        ? '-'
                        : b.monthlyFee.toString();

                    return DataRow2.byIndex(
                      index: index,
                      selected: controller.isSelected(index),
                      onTap: () => controller.toggleSelection(index),
                      cells: [
                        // 선택 체크박스
                        DataCell(
                          Center(
                            child: Checkbox(
                              value: controller.isSelected(index),
                              onChanged: (_) => controller.toggleSelection(index),
                            ),
                          ),
                        ),

                        DataCell(Center(child: TableCellText(b.companyCd, fontSize: 14))),
                        // 회사명
                        DataCell(Center(child: TableCellText(b.companyName??'', fontSize: 14))),
                        DataCell(Center(child: TableCellText(b.buildingCd, fontSize: 14))),
                        DataCell(Center(child: TableCellText(b.buildingName, fontSize: 14))),

                        // 빌딩주소(유동폭) + 툴팁 + 말줄임
                        DataCell(
                          (address.isNotEmpty)
                              ? Tooltip(
                            message: address,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: TableCellText(
                                address,
                                textAlign: TextAlign.left,
                                fontSize: 14,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          )
                              : const SizedBox.shrink(),
                        ),

                        DataCell(Center(child: TableCellText(b.edgeCount?.toString() ?? '-', fontSize: 14))),
                        DataCell(Center(child: TableCellText(contractDate, fontSize: 14))),
                        DataCell(Center(child: TableCellText('${b.contractTermMonths}', fontSize: 14))),
                        DataCell(Center(child: TableCellText(usageStart, fontSize: 14))),
                        DataCell(Center(child: TableCellText(usageEnd, fontSize: 14))),
                        DataCell(Center(child: TableCellText(b.managerName ?? '-', fontSize: 14))),
                        DataCell(Center(child: TableCellText(b.managerPosition ?? '-', fontSize: 14))),
                        DataCell(Center(child: TableCellText(b.managerPhoneNo ?? '-', fontSize: 14))),
                        DataCell(Center(child: TableCellText(monthlyFeeStr, fontSize: 14))),
                        DataCell(Center(child: TableCellText(b.isReceivePaidMsg, fontSize: 14))),

                        // 빌딩이미지(유동폭) - 파일명 혹은 '-'
                        DataCell(
                          Align(
                            alignment: Alignment.center,
                            child: TableCellText(
                              b.buildingImageFileName ?? '-',
                              textAlign: TextAlign.left,
                              fontSize: 14,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),

                        DataCell(Center(child: TableCellText(b.isServiceEnabled, fontSize: 14))),
                        DataCell(Center(child: TableCellText(b.formatCreateAt(), fontSize: 14))),
                        DataCell(Center(child: TableCellText(b.formatUpdatedAt(), fontSize: 14))),
                      ],
                    );
                  }),
                ),
              );
            });
          },
        ),
      ),
    );
  }
}
