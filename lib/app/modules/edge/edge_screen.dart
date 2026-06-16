// import 'package:data_table_2/data_table_2.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../core/values/consts.dart';
// import '../../data/model/edge_model.dart';
// import '../../widgets/copy_icon_button.dart';
// import '../common/show_custom_snackbar.dart';
// import '../common/widget/TableCellText.dart';
// import '../common/widget/TableColumnText.dart';
// import '../common/widget/confirm_delete.dart';
// import 'edge_controller.dart';
// import 'edit/edge_edit_dialog.dart';
//
// class EdgeScreen extends StatelessWidget {
//   const EdgeScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = EdgeController.to;
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
//                       (_) => EdgeEditDialog(
//                     mode: '등록',
//                     initialData: EdgeModel(companyCd: '', buildingCd: '', edgeCd: '', diNo: 0, edgeName: ''),
//                     // initialData: selectedCustomerData,
//                     onSave: (updated) {
//                       print('저장된 데이터: $updated');
//
//                       controller.edgeList.add(updated);
//                     },
//                   ),
//                 );
//
//                 if (result != null) {
//                   controller.edgeList.add(result);
//                   showCustomSnackbar('성공', 'Edge 등록이  완료 되었습니다.');
//                 } else {
//                   showCustomSnackbar('성공', 'Edge 등록이 실패 했습니다.');
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
//                         (_) => EdgeEditDialog(
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
//                   debugPrint('===================================>');
//                   if (result != null) {
//                     final _index = controller.edgeList.indexWhere((e) => e.edgeCd == result.edgeCd);
//
//                     debugPrint('=====>${result.toString()}');
//                     debugPrint('_index:${_index}');
//
//                     if (_index >= 0) {
//                       controller.edgeList[_index] = result;
//                       showCustomSnackbar('성공', 'Edge 정보 수정이  완료 되었습니다.');
//                     } else {
//                       showCustomSnackbar('성공', 'Edge 정보 수정이 실패 했습니다.');
//                     }
//
//                   }
//
//                 } else {
//                   showCustomSnackbar('안내', '수정 할 Edge를 선택 해 주세요');
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
//                   final _edgeModel = controller.getSelected()!;
//                   final result = await confirmDelete('');
//                   if (result == true) {
//                     try {
//                       await controller.deleteEdge(_edgeModel);
//                       debugPrint('삭제 성공!');
//                       final index = controller.edgeList.indexWhere(
//                               (e) => e.companyCd == _edgeModel.companyCd
//                           && e.buildingCd == _edgeModel.buildingCd
//                           && e.edgeCd == _edgeModel.edgeCd);
//                       if (index >= 0) {
//                         controller.edgeList.removeAt(index);
//                       }
//                       showCustomSnackbar('성공', 'Edge 정보 삭제가  완료 되었습니다.');
//                     } catch (e) {
//                       debugPrint('삭제 실패 또는 취소됨: $e');
//                       showCustomSnackbar('오류', 'Edge 정보 삭제가 실패 했습니다.: $e');
//                     }
//                   }
//                 } else {
//                   showCustomSnackbar('안내', '삭제 할 Edge를 선택 해 주세요');
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
//               minWidth: 1500,
//               // 줄바꿈되면 행 높이가 늘어나도록
//               // dataRowHeight: 56,
//
//               sortColumnIndex: controller.sortColumnIndex,
//               sortAscending: controller.sortAscending,
//               columns: const [
//                 DataColumn2(label: Center(child: TableColumnText('선택')), fixedWidth: 50),
//                 DataColumn2(label: Center(child: TableColumnText('회사코드')), fixedWidth: 100),
//                 DataColumn2(label: Center(child: TableColumnText('빌딩코드')), fixedWidth: 150),
//                 DataColumn2(label: Center(child: TableColumnText('Edge코드')), fixedWidth: 150),
//                 DataColumn2(label: Center(child: TableColumnText('Edge명칭')), fixedWidth: 150),
//                 /*
//                 DataColumn2(label: Center(child: TableColumnText('DI번호')), fixedWidth: 100),
//                 DataColumn2(label: Center(child: TableColumnText('DI명칭')), fixedWidth: 100),
//                 DataColumn2(label: Center(child: TableColumnText('Floor정보')), fixedWidth: 100),
//                 DataColumn2(label: Center(child: TableColumnText('Map이미지')), fixedWidth: 100),
//                 DataColumn2(label: Center(child: TableColumnText('SOP이미지')), fixedWidth: 100),
//                 DataColumn2(label: Center(child: TableColumnText('경보등급')), fixedWidth: 100),
//                 DataColumn2(label: Center(child: TableColumnText('경보분류')), fixedWidth: 100),
//                 DataColumn2(label: Center(child: TableColumnText('경보수신\n여부')), fixedWidth: 100),
//                 DataColumn2(label: Center(child: TableColumnText('경보/상태구분')), fixedWidth: 100),
//
//                  */
//
//                 DataColumn2(label: Center(child: TableColumnText('기본연결문자열')), fixedWidth: 300),
//                 DataColumn2(label: Center(child: TableColumnText('Edge설치위치')), fixedWidth: 100),
//                 DataColumn2(label: Center(child: TableColumnText('등록일')), fixedWidth: 150),
//                 DataColumn2(label: Center(child: TableColumnText('수정일')), fixedWidth: 150),
//
//                 // ...columns.map((title) => DataColumn2(label: Text(title)))
//               ],
//               rows: List.generate(controller.edgeList.length, (index) {
//                 final edge = controller.edgeList[index];
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
//                     DataCell(Center(child: TableCellText(edge.edgeCd ?? ''))),
//                     DataCell(Center(child: TableCellText(edge.edgeName ?? ''))),
//                     /*
//                     DataCell(Center(child: TableCellText(edge.diNo.toString()))),
//                     DataCell(Center(child: TableCellText(edge.diName ?? ''))),
//                     DataCell(Center(child: TableCellText(edge.floorInfo ?? ''))),
//                     DataCell(Center(child: TableCellText(edge.mapImageUrl ?? ''))),
//                     DataCell(Center(child: TableCellText(edge.sopImageUrl ?? ''))),
//                     DataCell(Center(child: TableCellText(edge.alertLevelCd ?? ''))),
//                     DataCell(Center(child: TableCellText(edge.alertCategoryCd ?? ''))),
//                     DataCell(Center(child: TableCellText(edge.isAlertReceivable ?? ''))),
//                     DataCell(Center(child: TableCellText(edge.alertStatusType ?? ''))),
//                      */
//
//                     buildDefaultConnectionCell(edge),  // 기본연결문자열
//
//                     DataCell(Center(child: TableCellText(edge.edgeInstallLocation ?? ''))),
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
//
// DataCell buildDefaultConnectionCell(EdgeModel edge) {
//   final controller = EdgeController.to;
//   if (edge.defaultConnectionString != null &&
//       edge.defaultConnectionString!.length > 5) {
//     return
//       DataCell(
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//
//           children: [
//             Expanded(
//               child: Text(
//                 edge.defaultConnectionString ?? '',
//                 softWrap: true,                 // 줄바꿈 허용
//                 overflow: TextOverflow.ellipsis, // 잘리지 않게
//                 maxLines: 1,                 // 여러 줄 허용
//               ),
//             ),
//             const SizedBox(width: 8),
//             CopyIconButton(textToCopy: edge.defaultConnectionString ?? ''),
//           ],
//         ),
//       );    ;
//   } else {
//     return DataCell(  // 버튼 표시
//       Center(
//         child: ElevatedButton(
//           onPressed: () {
//             // Azure IoT Edge 등록 로직 추가
//             controller.createIotHubDevice(edge);
//           },
//           child: const Text('Azure IoT Edge 등록', style: TextStyle(fontSize: 14)),
//         ),
//       ),
//     );
//   }
// }

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/values/consts.dart';
import '../../data/model/edge_model.dart';
import '../../widgets/copy_icon_button.dart';
import '../common/show_custom_snackbar.dart';
import '../common/widget/TableCellText.dart';
import '../common/widget/TableColumnText.dart';
import '../common/widget/confirm_delete.dart';
import 'edge_controller.dart';
import 'edit/edge_edit_dialog.dart';

class EdgeScreen extends StatelessWidget {
  const EdgeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = EdgeController.to;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [

            SizedBox(width: 10,),
            Text('Edge 관리', style: TextStyle(color: Colors.black),),

            const Spacer(),

            // 등록
            ElevatedButton(
              onPressed: () async {
                final result = await showDialog(
                  context: context,
                  builder: (_) => EdgeEditDialog(
                    mode: '등록',
                    initialData: EdgeModel(
                      companyCd: '',
                      buildingCd: '',
                      edgeCd: '',
                      // diNo: 0,
                      edgeName: '',
                    ),
                    onSave: (updated) {
                      // 모달 내부 저장 콜백(옵션)
                    },
                  ),
                );

                if (result != null) {
                  controller.edgeList.add(result);
                  showCustomSnackbar('성공', 'Edge 등록이 완료되었습니다.');
                } else {
                  showCustomSnackbar('실패', 'Edge 등록이 실패했습니다.');
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
                    builder: (_) => EdgeEditDialog(
                      mode: '수정',
                      initialData: selected,
                      onSave: (updated) {},
                    ),
                  );

                  if (result != null) {
                    final idx = controller.edgeList
                        .indexWhere((e) => e.edgeCd == result.edgeCd);
                    if (idx >= 0) {
                      controller.edgeList[idx] = result;
                      showCustomSnackbar('성공', 'Edge 정보 수정이 완료되었습니다.');
                    } else {
                      showCustomSnackbar('실패', 'Edge 정보 수정이 실패했습니다.');
                    }
                  }
                } else {
                  showCustomSnackbar('안내', '수정할 Edge를 선택해주세요.');
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
                  final result = await confirmDelete(target.edgeCd ?? '');
                  if (result == true) {
                    try {
                      await controller.deleteEdge(target);
                      final index = controller.edgeList.indexWhere((e) =>
                      e.companyCd == target.companyCd &&
                          e.buildingCd == target.buildingCd &&
                          e.edgeCd == target.edgeCd);
                      if (index >= 0) {
                        controller.edgeList.removeAt(index);
                      }
                      showCustomSnackbar('성공', 'Edge 정보 삭제가 완료되었습니다.');
                    } catch (e) {
                      showCustomSnackbar('오류', 'Edge 정보 삭제가 실패했습니다: $e');
                    }
                  }
                } else {
                  showCustomSnackbar('안내', '삭제할 Edge를 선택해주세요.');
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
            // 브라우저 뷰포트 너비와 비교하여 minWidth 동적 결정
            final double tableMinWidth =
            constraints.maxWidth > 1820 ? constraints.maxWidth : 1820;

            return Obx(() {
              return Container(
                padding: EdgeInsets.zero, // 좌우 마진 제거
                width: double.infinity,
                child: DataTable2(
                  scrollController: controller.controller,
                  horizontalScrollController: controller.horizontalController,

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
                      fixedWidth: 160,
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
                      fixedWidth: 160,
                    ),
                    DataColumn2(
                      label: Center(child: TableColumnText('Edge명칭')),
                      // fixedWidth: 160,
                    ),

                    // 기본연결문자열: 유동폭(남는 공간 흡수)
                    /*
                    DataColumn2(
                      label: Center(child: TableColumnText('기본연결문자열')),
                    ),

                     */

                    DataColumn2(
                      label: Center(child: TableColumnText('Edge설치위치')),
                      // fixedWidth: 140,
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

                  rows: List.generate(controller.edgeList.length, (index) {
                    final edge = controller.edgeList[index];

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

                        DataCell(Center(child: TableCellText(edge.companyCd, fontSize: 14))),
                        DataCell(Center(child: TableCellText(edge.companyName ??'-', fontSize: 14))),
                        DataCell(Center(child: TableCellText(edge.buildingCd, fontSize: 14))),
                        DataCell(Center(child: TableCellText(edge.buildingName ?? '-', fontSize: 14))),
                        DataCell(Center(child: TableCellText(edge.edgeCd ?? '-', fontSize: 14))),
                        DataCell(Center(child: TableCellText(edge.edgeName ?? '-', fontSize: 14))),

                        // 기본연결문자열(유동폭) + 복사 버튼 + 말줄임
                        // buildDefaultConnectionCell(edge),

                        DataCell(Center(child: TableCellText(edge.edgeInstallLocation ?? '-', fontSize: 14))),
                        DataCell(Center(child: TableCellText(edge.formatCreateAt(), fontSize: 14))),
                        DataCell(Center(child: TableCellText(edge.formatUpdatedAt(), fontSize: 14))),
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

// DataCell buildDefaultConnectionCell(EdgeModel edge) {
//   final controller = EdgeController.to;
//
//   // final conn = edge.defaultConnectionString ?? '';
//
//   if (conn.length > 5) {
//     return DataCell(
//       Row(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           // 유동폭 셀: 좌측 정렬 + 말줄임
//           Expanded(
//             child: Align(
//               alignment: Alignment.centerLeft,
//               child: Tooltip(
//                 message: conn,
//                 child: TableCellText(
//                   conn,
//                   textAlign: TextAlign.left,
//                   fontSize: 14,
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(width: 8),
//           CopyIconButton(textToCopy: conn),
//         ],
//       ),
//     );
//   } else {
//     // 등록 버튼
//     return DataCell(
//       Center(
//         child: ElevatedButton(
//           onPressed: () {
//             controller.createIotHubDevice(edge);
//           },
//           child: const Text('Azure IoT Edge 등록', style: TextStyle(fontSize: 14)),
//         ),
//       ),
//     );
//   }
// }
//

