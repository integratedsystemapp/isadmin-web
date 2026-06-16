// import 'package:data_table_2/data_table_2.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../core/values/consts.dart';
// import '../../data/model/alert_category_model.dart';
// import '../../data/model/alert_level_model.dart';
// import '../../data/model/alert_status.dart';
// import '../../data/model/di_model.dart';
// import '../common/show_custom_snackbar.dart';
// import '../common/widget/TableCellText.dart';
// import '../common/widget/TableColumnText.dart';
// import '../common/widget/confirm_delete.dart';
// import 'di_controller.dart';
// import 'edit/di_edit_dialog.dart';
//
// class DiScreen extends StatelessWidget {
//   const DiScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = DiController.to;
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
//                       (_) => DiEditDialog(
//                     mode: '등록',
//                     initialData: DiModel(companyCd: '', buildingCd: '', edgeCd: '', diNo: -1, alertLevelCd: '', alertCategoryCd: '',
//                         isAlertReceivable: '', alertStatusType: ''),
//                     // initialData: selectedCustomerData,
//                     onSave: (updated) {
//                       print('저장된 데이터: $updated');
//
//                       controller.diList.add(updated);
//                     },
//                   ),
//                 );
//
//                 if (result != null) {
//                   // controller.diList.add(result);
//                   showCustomSnackbar('성공', 'DI 정보 등록이  완료 되었습니다.');
//                 } else {
//                   debugPrint('취소 버튼 클릭');
//                   // showCustomSnackbar('성공', 'DI 정보 등록이 실패 했습니다.');
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
//                   final _customer = controller.getSelected()!;
//                   final result = await showDialog(
//                     context: context,
//                     builder:
//                         (_) => DiEditDialog(
//                       mode: '수정',
//                       initialData: _customer, // 첫 번째 고객 데이터로 초기화
//                       // initialData: selectedCustomerData,
//                       onSave: (updated) {
//                         print('저장된 데이터: $updated');
//
//                       },
//                     ),
//                   );
//
//                   if (result != null) {
//                     final _index = controller.diList.indexWhere((e) => e.edgeCd == result.edgeCd);
//
//                     debugPrint('=====>${result.toString()}');
//                     debugPrint('_index:${_index}');
//
//                     if (_index >= 0) {
//                       controller.diList[_index] = result;
//                       showCustomSnackbar('성공', 'DI 정보 수정이  완료 되었습니다.');
//                     } else {
//                       showCustomSnackbar('성공', 'DI 정보 수정이 실패 했습니다.');
//                     }
//
//                   }
//
//                 } else {
//                   showCustomSnackbar('안내', '수정 할 DI를 선택 해 주세요');
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
//                   final _diModel = controller.getSelected()!;
//                   final result = await confirmDelete('');
//                   if (result == true) {
//                     try {
//                       await controller.deleteDi(_diModel);
//                       debugPrint('삭제 성공!');
//                       final index = controller.diList.indexWhere((e) => e.companyCd == _diModel.companyCd
//                                                                 &&  e.buildingCd == _diModel.buildingCd
//                                                                 &&  e.edgeCd == _diModel.edgeCd
//                                                                 &&  e.diNo == _diModel.diNo
//                       );
//                       if (index >= 0) {
//                         controller.diList.removeAt(index);
//                       }
//                       showCustomSnackbar('성공', 'DI 정보 삭제가  완료 되었습니다.');
//                     } catch (e) {
//                       debugPrint('삭제 실패 또는 취소됨: $e');
//                       showCustomSnackbar('오류', 'DI 정보 삭제가 실패 했습니다.: $e');
//                     }
//                   }
//                 } else {
//                   showCustomSnackbar('안내', '삭제 할 DI를 선택 해 주세요');
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
//               sortColumnIndex: controller.sortColumnIndex,
//               sortAscending: controller.sortAscending,
//               columns: [
//                 DataColumn2(label: const Center(child: TableColumnText('선택')), fixedWidth: 50),
//                 DataColumn2(label: const Center(child: TableColumnText('회사코드')), fixedWidth: 100),
//                 DataColumn2(label: const Center(child: TableColumnText('빌딩코드')), fixedWidth: 150),
//                 DataColumn2(label: const Center(child: TableColumnText('Edge코드')), fixedWidth: 200),
//                 DataColumn2(label: const Center(child: TableColumnText('DI번호')), fixedWidth: 100),
//                 DataColumn2(label: const Center(child: TableColumnText('DI명칭')), fixedWidth: 100),
//                 DataColumn2(label: const Center(child: TableColumnText('Floor정보')), fixedWidth: 100),
//                 DataColumn2(label: const Center(child: TableColumnText('Map이미지')), fixedWidth: 100),
//                 DataColumn2(label: const Center(child: TableColumnText('SOP이미지')), fixedWidth: 100),
//                 DataColumn2(label: const Center(child: TableColumnText('경보등급')), fixedWidth: 150),
//                 DataColumn2(label: const Center(child: TableColumnText('경보분류')), fixedWidth: 150),
//                 DataColumn2(label: const Center(child: TableColumnText('경보 수신 여부')), fixedWidth: 100),
//                 DataColumn2(label: const Center(child: TableColumnText('경보/상태 구분')), fixedWidth: 100),
//                 DataColumn2(label: const Center(child: TableColumnText('기본 연결 문자열')), fixedWidth: 150),
//                 DataColumn2(label: const Center(child: TableColumnText('등록일')), fixedWidth: 150),
//                 DataColumn2(label: const Center(child: TableColumnText('수정일')), fixedWidth: 150),
//
//                 // ...columns.map((title) => DataColumn2(label: Text(title)))
//               ],
//               rows: List.generate(controller.diList.length, (index) {
//                 final edge = controller.diList[index];
//                 return DataRow2.byIndex(
//                   index: index,
//                   selected: controller.isSelected(index),
//                   onTap: () => controller.toggleSelection(index),
//
//                   cells:
//                   [
//                     DataCell(Center(child: Checkbox(value: controller.isSelected(index), onChanged: (_) => controller.toggleSelection(index)))),
//                     DataCell(Center(child: TableCellText(edge.companyCd))),
//                     DataCell(Center(child: TableCellText(edge.buildingCd))),
//                     DataCell(Center(child: TableCellText(edge.edgeCd))),
//                     DataCell(Center(child: TableCellText(edge.diNo.toString()))),
//                     DataCell(Center(child: TableCellText(edge.diName ?? ''))),
//                     DataCell(Center(child: TableCellText(edge.floorInfo ?? ''))),
//                     DataCell(Center(child: TableCellText(edge.mapImageFileName ?? ''))),
//                     DataCell(Center(child: TableCellText(edge.sopImageFileName ?? ''))),
//                     DataCell(Center(child: TableCellText(alertLevelDesc(edge?.alertLevelCd)))),
//                     DataCell(Center(child: TableCellText(alertCategoryDesc(edge.alertCategoryCd)))),
//                     DataCell(Center(child: TableCellText(edge.isAlertReceivable ?? ''))),
//                     DataCell(Center(child: TableCellText(alertStatusDesc(edge?.alertStatusType)))),
//                     DataCell(Center(child: TableCellText(edge.defaultConnectionString ?? ''))),
//                     DataCell(Center(child: TableCellText(edge.formatCreateAt()))),
//                     DataCell(Center(child: TableCellText(edge.formatUpdatedAt()))),
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
import '../../data/model/alert_category_model.dart';
import '../../data/model/alert_level_model.dart';
import '../../data/model/alert_status.dart';
import '../../data/model/di_model.dart';
import '../common/show_custom_snackbar.dart';
import '../common/widget/TableCellText.dart';
import '../common/widget/TableColumnText.dart';
import '../common/widget/confirm_delete.dart';
import 'di_controller.dart';
import 'edit/di_edit_dialog.dart';

class DiScreen extends StatelessWidget {
  const DiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = DiController.to;

    return Scaffold(
      // appBar: AppBar(
      //   titleSpacing: 0,
      //   automaticallyImplyLeading: false,
      //   title: Row(
      //     children: [
      //
      //       SizedBox(width: 10,),
      //       Text('Digital Input 관리', style: TextStyle(color: Colors.black),),
      //
      //       const Spacer(),
      //
      //       // 등록
      //       ElevatedButton(
      //         onPressed: () async {
      //           final result = await showDialog(
      //             context: context,
      //             builder: (_) => DiEditDialog(
      //               mode: '등록',
      //               initialData: DiModel(
      //                 companyCd: '',
      //                 buildingCd: '',
      //                 edgeCd: '',
      //                 diNo: -1,
      //                 alertLevelCd: '',
      //                 alertCategoryCd: '',
      //                 isAlertReceivable: '',
      //                 alertStatusType: '',
      //               ),
      //               onSave: (updated) {
      //                 print('onSave========================1');
      //                 controller.diList.value.add(updated);
      //                 controller.diList.refresh();
      //                 print('onSave========================2');
      //
      //               },
      //             ),
      //           );
      //
      //           if (result != null) {
      //             // 등록이 실제 반영되는 곳이 컨트롤러 로직이라면 여기서 add는 생략 가능
      //             // controller.diList.add(result);
      //             showCustomSnackbar('성공', 'DI 정보 등록이 완료되었습니다.');
      //           } else {
      //             debugPrint('등록 취소');
      //           }
      //         },
      //         child: const Text('등록'),
      //       ),
      //       const SizedBox(width: 8),
      //
      //       // 수정
      //       ElevatedButton(
      //         onPressed: () async {
      //           if (controller.selected.isNotEmpty) {
      //             final selected = controller.getSelected()!;
      //             final result = await showDialog(
      //               context: context,
      //               builder: (_) => DiEditDialog(
      //                 mode: '수정',
      //                 initialData: selected,
      //                 onSave: (updated) {},
      //               ),
      //             );
      //
      //             if (result != null) {
      //               final idx = controller.diList.indexWhere((e) =>
      //               e.companyCd == result.companyCd &&
      //                   e.buildingCd == result.buildingCd &&
      //                   e.edgeCd == result.edgeCd &&
      //                   e.diNo == result.diNo);
      //               if (idx >= 0) {
      //                 controller.diList[idx] = result;
      //                 showCustomSnackbar('성공', 'DI 정보 수정이 완료되었습니다.');
      //               } else {
      //                 showCustomSnackbar('실패', 'DI 정보 수정이 실패했습니다.');
      //               }
      //             }
      //           } else {
      //             showCustomSnackbar('안내', '수정할 DI를 선택해주세요.');
      //           }
      //         },
      //         child: const Text('수정'),
      //       ),
      //       const SizedBox(width: 8),
      //
      //       // 삭제
      //       ElevatedButton(
      //         onPressed: () async {
      //           if (controller.selected.isNotEmpty) {
      //             final target = controller.getSelected()!;
      //             final ok = await confirmDelete(
      //                 '${target.edgeCd}-${target.diNo.toString()}');
      //             if (ok == true) {
      //               try {
      //                 await controller.deleteDi(target);
      //                 final index = controller.diList.indexWhere((e) =>
      //                 e.companyCd == target.companyCd &&
      //                     e.buildingCd == target.buildingCd &&
      //                     e.edgeCd == target.edgeCd &&
      //                     e.diNo == target.diNo);
      //                 if (index >= 0) {
      //                   controller.diList.removeAt(index);
      //                 }
      //                 showCustomSnackbar('성공', 'DI 정보 삭제가 완료되었습니다.');
      //               } catch (e) {
      //                 showCustomSnackbar('오류', 'DI 정보 삭제 실패: $e');
      //               }
      //             }
      //           } else {
      //             showCustomSnackbar('안내', '삭제할 DI를 선택해주세요.');
      //           }
      //         },
      //         child: const Text('삭제'),
      //       ),
      //       const SizedBox(width: 16),
      //     ],
      //   ),
      // ),

      appBar: AppBar(
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            const SizedBox(width: 10),
            const Text('Digital Input 관리', style: TextStyle(color: Colors.black)),

            const Spacer(),

            // 🔎 검색 위젯
            ConstrainedBox(
              constraints: const BoxConstraints.tightFor(width: 320, height: 36),
              child: TextField(
                controller: controller.searchCtrl,
                onChanged: controller.onSearchChanged,   // 300ms 디바운스 내장 (컨트롤러 코드 아래)
                onSubmitted: controller.onSearchChanged, // Enter로 즉시 검색
                textInputAction: TextInputAction.search,
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  isDense: true,
                  hintText: '검색 (회사/빌딩)',
                  prefixIcon: const Icon(Icons.search, size: 18),
                  suffixIcon: Obx(() => controller.searchText.value.isEmpty
                      ? const SizedBox.shrink()
                      : IconButton(
                    tooltip: '지우기',
                    icon: const Icon(Icons.close, size: 18),
                    onPressed: controller.clearSearch,
                  )),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 12),

            // 등록
            ElevatedButton(
              onPressed: () async {
                final result = await showDialog(
                  context: context,
                  builder: (_) => DiEditDialog(
                    mode: '등록',
                    initialData: DiModel(
                      companyCd: '',
                      buildingCd: '',
                      edgeCd: '',
                      diNo: -1,
                      alertLevelCd: '',
                      alertCategoryCd: '',
                      isAlertReceivable: '',
                      alertStatusType: '',
                    ),
                    onSave: (updated) {
                      controller.diList.value.add(updated);
                      controller.diList.refresh();
                    },
                  ),
                );
                if (result != null) {
                  showCustomSnackbar('성공', 'DI 정보 등록이 완료되었습니다.');
                } else {
                  debugPrint('등록 취소');
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
                    builder: (_) => DiEditDialog(
                      mode: '수정',
                      initialData: selected,
                      onSave: (updated) {},
                    ),
                  );

                  if (result != null) {
                    final idx = controller.diList.indexWhere((e) =>
                    e.companyCd == result.companyCd &&
                        e.buildingCd == result.buildingCd &&
                        e.edgeCd == result.edgeCd &&
                        e.diNo == result.diNo);
                    if (idx >= 0) {
                      controller.diList[idx] = result;
                      showCustomSnackbar('성공', 'DI 정보 수정이 완료되었습니다.');
                    } else {
                      showCustomSnackbar('실패', 'DI 정보 수정이 실패했습니다.');
                    }
                  }
                } else {
                  showCustomSnackbar('안내', '수정할 DI를 선택해주세요.');
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
                  final ok = await confirmDelete('${target.edgeCd}-${target.diNo}');
                  if (ok == true) {
                    try {
                      await controller.deleteDi(target);
                      final index = controller.diList.indexWhere((e) =>
                      e.companyCd == target.companyCd &&
                          e.buildingCd == target.buildingCd &&
                          e.edgeCd == target.edgeCd &&
                          e.diNo == target.diNo);
                      if (index >= 0) {
                        controller.diList.removeAt(index);
                      }
                      showCustomSnackbar('성공', 'DI 정보 삭제가 완료되었습니다.');
                    } catch (e) {
                      showCustomSnackbar('오류', 'DI 정보 삭제 실패: $e');
                    }
                  }
                } else {
                  showCustomSnackbar('안내', '삭제할 DI를 선택해주세요.');
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
            // CustomerScreen과 동일한 패턴: 화면이 넓어지면 테이블도 같이 확장
            final double tableMinWidth =
            constraints.maxWidth > 2670 ? constraints.maxWidth : 2670;

            return Obx(() {
              return Container(
                width: double.infinity,
                padding: EdgeInsets.zero, // 여백 제거
                child: DataTable2(
                  scrollController: controller.controller,
                  horizontalScrollController: controller.horizontalController,

                  // 좌우 여백/간격 최소화
                  horizontalMargin: 0,
                  columnSpacing: 0,
                  minWidth: tableMinWidth,

                  sortColumnIndex: controller.sortColumnIndex,
                  sortAscending: controller.sortAscending,

                  columns: const [
                    DataColumn2(
                      label: Center(child: TableColumnText('선택')),
                      fixedWidth: 50,
                    ),
                    DataColumn2(
                      label: Center(child: TableColumnText('회사코드')),
                      fixedWidth: 110,
                    ),
                    DataColumn2(
                      label: Center(child: TableColumnText('회사명')),
                      fixedWidth: 110,
                    ),
                    DataColumn2(
                      label: Center(child: TableColumnText('빌딩코드')),
                      fixedWidth: 160,
                    ),
                    DataColumn2(
                      label: Center(child: TableColumnText('빌딩명')),
                      fixedWidth: 160,
                    ),
                    DataColumn2(
                      label: Center(child: TableColumnText('Edge코드')),
                      fixedWidth: 200,
                    ),
                    DataColumn2(
                      label: Center(child: TableColumnText('Edge명')),
                      fixedWidth: 200,
                    ),
                    DataColumn2(
                      label: Center(child: TableColumnText('DI번호')),
                      fixedWidth: 100,
                    ),
                    DataColumn2(
                      label: Center(child: TableColumnText('DI명칭')),
                      fixedWidth: 140,
                    ),
                    DataColumn2(
                      label: Center(child: TableColumnText('Floor정보')),
                      fixedWidth: 120,
                    ),
                    DataColumn2(
                      label: Center(child: TableColumnText('Map이미지')),
                      fixedWidth: 140,
                    ),
                    DataColumn2(
                      label: Center(child: TableColumnText('SOP이미지')),
                      fixedWidth: 140,
                    ),
                    DataColumn2(
                      label: Center(child: TableColumnText('경보등급')),
                      fixedWidth: 150,
                    ),
                    DataColumn2(
                      label: Center(child: TableColumnText('경보분류')),
                      fixedWidth: 160,
                    ),
                    DataColumn2(
                      label: Center(child: TableColumnText('경보 수신 여부')),
                      fixedWidth: 130,
                    ),
                    DataColumn2(
                      label: Center(child: TableColumnText('경보/상태 구분')),
                      fixedWidth: 140,
                    ),
                    // 기본 연결 문자열: 가변 폭(남는 공간 사용)
                    DataColumn2(
                      label: Center(child: TableColumnText('기본 연결 문자열')),
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

                  rows: List.generate(controller.diList.length, (index) {
                    final di = controller.diList[index];

                    return DataRow2.byIndex(
                      index: index,
                      selected: controller.isSelected(index),
                      onTap: () => controller.toggleSelection(index),
                      cells: [
                        // 선택
                        DataCell(
                          Center(
                            child: Checkbox(
                              value: controller.isSelected(index),
                              onChanged: (_) => controller.toggleSelection(index),
                            ),
                          ),
                        ),

                        DataCell(Center(child: TableCellText(di.companyCd))),
                        DataCell(Center(child: TableCellText(di.companyName??'-'))),
                        DataCell(Center(child: TableCellText(di.buildingCd??'-'))),
                        DataCell(Center(child: TableCellText(di.buildingName??'-'))),
                        DataCell(Center(child: TableCellText(di.edgeCd))),
                        DataCell(Center(child: TableCellText(di.edgeName??'-'))),
                        DataCell(Center(child: TableCellText(di.diNo.toString()))),
                        DataCell(Center(child: TableCellText(di.diName ?? ''))),
                        DataCell(Center(child: TableCellText(di.floorInfo ?? ''))),

                        // Map/SOP 파일명은 길 수 있으니 Tooltip + 말줄임
                        DataCell(
                          Center(
                            child: Tooltip(
                              message: di.mapImageFileName ?? '',
                              child: TableCellText(di.mapImageFileName ?? ''),
                            ),
                          ),
                        ),
                        DataCell(
                          Center(
                            child: Tooltip(
                              message: di.sopImageFileName ?? '',
                              child: TableCellText(di.sopImageFileName ?? ''),
                            ),
                          ),
                        ),

                        DataCell(
                          Center(
                            child: TableCellText(alertLevelDesc(di.alertLevelCd)),
                          ),
                        ),
                        DataCell(
                          Center(
                            child: TableCellText(alertCategoryDesc(di.alertCategoryCd)),
                          ),
                        ),
                        DataCell(Center(child: TableCellText(di.isAlertReceivable ?? ''))),
                        DataCell(
                          Center(
                            child: TableCellText(alertStatusDesc(di.alertStatusType)),
                          ),
                        ),

                        // 기본 연결 문자열(가변 폭 셀): 좌측 정렬 + Tooltip + 말줄임
                        DataCell(
                          Row(
                            children: [
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Tooltip(
                                    message: di.defaultConnectionString ?? '',
                                    child: TableCellText(di.defaultConnectionString ?? ''),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        DataCell(Center(child: TableCellText(di.formatCreateAt()))),
                        DataCell(Center(child: TableCellText(di.formatUpdatedAt()))),
                      ]
                      // 공통 텍스트 스타일(필요 시): 이미 TableCellText 내부에서 처리 중이면 생략 가능
                          .map((c) => DataCell(
                        DefaultTextStyle.merge(
                          style: const TextStyle(fontSize: 14),
                          child: c.child,
                        ),
                      ))
                          .toList(),
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
