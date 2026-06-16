import 'dart:math' as math;

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/utils/date_web_utils.dart';
import '../../../core/values/consts.dart';
import '../common/show_custom_snackbar.dart';
import '../common/widget/TableCellText.dart';
import '../common/widget/TableColumnText.dart';
import 'altert_history_controller.dart';

class AlertHistoryScreen extends StatelessWidget {
  AlertHistoryScreen({super.key});

  /// 고정폭 합(가변인 ‘경보발생사유’는 제외)
  /// 80+160+160+140+160+220+160+100+140+120+110+110+110+120+160+160 = 2260
  static const double _kFixedWidthSum = 3390;
  /// 테이블 최소 확보 폭(버퍼 200)
  static const double _kBaselineMinWidth = _kFixedWidthSum + 300; // 2460

  @override
  Widget build(BuildContext context) {
    final controller = AlertHistoryController.to;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            SizedBox(width: 10,),
            Text('경보 히스토리', style: TextStyle(color: Colors.black),),

            const Spacer(),
            IconButton(
              tooltip: '새로고침',
              onPressed: () => controller.refreshAll(),
              icon: const Icon(Icons.refresh,color: Colors.black),
            ),
          ],
        ),
      ),
      body: SafeArea(
        left: false,
        right: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            // 화면이 넓으면 그 폭만큼, 좁으면 가로 스크롤(최소폭 유지)
            final double tableMinWidth =
            math.max(_kBaselineMinWidth, constraints.maxWidth);

            return Obx(() {
              return Stack(
                children: [
                  // ===== 본문 =====
                  Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.zero, // 좌우 여백 제거
                          child: DataTable2(
                            scrollController: controller.controller,
                            horizontalScrollController:
                            controller.horizontalController,
                            columnSpacing: 0,
                            horizontalMargin: 0,
                            minWidth: tableMinWidth,
                            sortColumnIndex: controller.sortColumnIndex,
                            sortAscending: controller.sortAscending,
                            columns: const [
                              DataColumn2(label: Center(child: TableColumnText('경보ID')), fixedWidth: 80),
                              DataColumn2(label: Center(child: TableColumnText('경보발송시간')), fixedWidth: 160),
                              DataColumn2(label: Center(child: TableColumnText('경보확인시간')), fixedWidth: 160),
                              DataColumn2(label: Center(child: TableColumnText('경보확인사용자ID')), fixedWidth: 140),
                              DataColumn2(label: Center(child: TableColumnText('회사코드')), fixedWidth: 160),
                              DataColumn2(label: Center(child: TableColumnText('빌딩코드')), fixedWidth: 160),
                              DataColumn2(label: Center(child: TableColumnText('빌딩명')), fixedWidth: 220),
                              DataColumn2(label: Center(child: TableColumnText('Edge코드')), fixedWidth: 160),
                              // DataColumn2(label: Center(child: TableColumnText('DI No')), fixedWidth: 100),
                              // DataColumn2(label: Center(child: TableColumnText('DI 이름')), fixedWidth: 140),
                              DataColumn2(label: Center(child: TableColumnText('경보명')), fixedWidth: 180),
                              DataColumn2(label: Center(child: TableColumnText('센서명')), fixedWidth: 180),
                              DataColumn2(label: Center(child: TableColumnText('map id')), fixedWidth: 300),
                              DataColumn2(label: Center(child: TableColumnText('sop id')), fixedWidth: 300),
                              DataColumn2(label: Center(child: TableColumnText('cctv id')), fixedWidth: 300),

                              DataColumn2(label: Center(child: TableColumnText('Floor정보')), fixedWidth: 120),
                              DataColumn2(label: Center(child: TableColumnText('경보등급')), fixedWidth: 110),
                              DataColumn2(label: Center(child: TableColumnText('경보분류')), fixedWidth: 110),
                              DataColumn2(label: Center(child: TableColumnText('경보상태')), fixedWidth: 110),
                              DataColumn2(label: Center(child: TableColumnText('오경보여부')), fixedWidth: 120),

                              // ⬇️ 가변 폭 — 남는 공간 흡수
                              DataColumn2(label: Center(child: TableColumnText('경보발생사유'))),

                              DataColumn2(label: Center(child: TableColumnText('등록일')), fixedWidth: 160),
                              DataColumn2(label: Center(child: TableColumnText('수정일')), fixedWidth: 160),
                            ],
                            rows: List<DataRow2>.generate(
                              controller.alertHistoryList.length,
                                  (index) {
                                final a = controller.alertHistoryList[index];
                                return DataRow2.byIndex(
                                  index: index,
                                  selected: controller.isSelected(index),
                                  onTap: () => controller.toggleSelection(index),
                                  cells: [
                                    DataCell(Center(child: TableCellText(a.alertId?.toString() ?? ''))),
                                    DataCell(Center(child: TableCellText(DateWebUtils.toYYYYMMDDWithTime(a.alertOccurredAt)))),
                                    DataCell(Center(child: TableCellText(DateWebUtils.toYYYYMMDDWithTime(a.alertConfirmedAt)))),
                                    DataCell(Center(child: TableCellText(a.alertConfirmUserId ?? ''))),
                                    DataCell(Center(child: TableCellText(a.companyCd ?? ''))),
                                    DataCell(Center(child: TableCellText(a.buildingCd ?? ''))),
                                    DataCell(Center(child: TableCellText(a.buildingName ?? ''))),
                                    DataCell(Center(child: TableCellText(a.edgeCd ?? ''))),
                                    // DataCell(Center(child: TableCellText((a.diNo ?? '').toString()))),
                                    // DataCell(Center(child: TableCellText(a.diName ?? ''))),

                                    DataCell(Center(child: TableCellText(a.sysAlertName ?? ''))),
                                    DataCell(Center(child: TableCellText(a.primarySensorName ?? ''))),

                                    DataCell(
                                      Center(
                                        child: (!a.isValidMapId())
                                            ? const Text('-', style: TextStyle(fontSize: 14))
                                            :
                                        TextButton(
                                          style: TextButton.styleFrom(
                                            padding: EdgeInsets.zero, // 여백 제거
                                            minimumSize: Size(0, 0),
                                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                          ),                                          onPressed: () {
                                            if (a.mapBlobUrl != null) {
                                              controller.downloadImageUrl(a.mapBlobUrl!);
                                            } else {
                                              showCustomSnackbar(
                                                  '안내', 'map 이미지 다운로드 주소가 존재하지 않습니다.');
                                            }
                                          },
                                          child: Text(
                                            a.mapId!,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              decoration: TextDecoration.underline, // 밑줄
                                              // color: Colors.blue,  // 원하시면 링크처럼 파란색 지정
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    DataCell(
                                      Center(
                                        child: (!a.isValidSopId())
                                            ? const Text('-', style: TextStyle(fontSize: 14))
                                            :
                                    TextButton(
                                    style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero, // 여백 제거
                                    minimumSize: Size(0, 0),
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    ),
                                          onPressed: () {
                                            if (a.sopBlobUrl != null) {
                                              controller.downloadImageUrl(a.sopBlobUrl!);
                                            } else {
                                              showCustomSnackbar(
                                                  '안내', 'sop 이미지 다운로드 주소가 존재하지 않습니다.');
                                            }
                                          },
                                          child: Text(
                                              a.sopId!,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              decoration: TextDecoration.underline, // 밑줄
                                              // color: Colors.blue,  // 원하시면 링크처럼 파란색 지정
                                            ),

                                          ),
                                        ),
                                      ),
                                    ),

                                    DataCell(
                                      Center(
                                        child: (!a.isValidCctvId())
                                            ? const Text('-', style: TextStyle(fontSize: 14))
                                            :
                                        TextButton(
                                          style: TextButton.styleFrom(
                                            padding: EdgeInsets.zero, // 여백 제거
                                            minimumSize: Size(0, 0),
                                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                          ),
                                          onPressed: () {
                                            if (a.cctvBlobUrl != null) {
                                              controller.downloadImageUrl(a.cctvBlobUrl!);
                                            } else {
                                              showCustomSnackbar(
                                                  '안내', 'cctv 이미지 다운로드 주소가 존재하지 않습니다.');
                                            }
                                          },
                                          child: Text(a.cctvId!,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              decoration: TextDecoration.underline, // 밑줄
                                              // color: Colors.blue,  // 원하시면 링크처럼 파란색 지정
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),


                                    DataCell(Center(child: TableCellText(a.floorInfo ?? ''))),
                                    DataCell(Center(child: TableCellText(a.alertLevelCd ?? ''))),
                                    DataCell(Center(child: TableCellText(a.alertCategoryCd ?? ''))),
                                    DataCell(Center(child: TableCellText(a.alertStatus ?? ''))),
                                    DataCell(Center(child: TableCellText(a.isFalseAlert ?? ''))),

                                    // 가변 폭 셀: 좌측 정렬 + Tooltip + 말줄임
                                    DataCell(
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Tooltip(
                                          message: a.alertReason ?? '',
                                          child: TableCellText(a.alertReason ?? ''),
                                        ),
                                      ),
                                    ),

                                    DataCell(Center(child: TableCellText(a.formatCreateAt()))),
                                    DataCell(Center(child: TableCellText(a.formatUpdatedAt()))),
                                  ]
                                      .map((c) => DataCell(
                                    DefaultTextStyle.merge(
                                      style: const TextStyle(fontSize: 14),
                                      child: c.child,
                                    ),
                                  ))
                                      .toList(),
                                );
                              },
                            ),
                          ),
                        ),
                      ),

                      // 하단 상태바(원하시면 유지)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: () {
                          if (controller.isLoading.value &&
                              controller.alertHistoryList.isEmpty) {
                            return const CupertinoActivityIndicator();
                          }
                          if (controller.isLoading.value &&
                              controller.alertHistoryList.isNotEmpty) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                CupertinoActivityIndicator(),
                                SizedBox(width: 8),
                                Text('불러오는 중...'),
                              ],
                            );
                          }
                          if (!controller.hasMore.value) {
                            return const Text('마지막 페이지입니다.');
                          }
                          return const SizedBox.shrink();
                        }(),
                      ),
                    ],
                  ),

                  // ===== 오버레이 =====
                  if (controller.isLoading.value) ...[
                    Positioned.fill(
                      child: AbsorbPointer(
                        absorbing: true, // 터치 막기
                        child: Container(
                          color: Colors.black.withOpacity(0.2),
                          child: const Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // CircularProgressIndicator(),
                                // SizedBox(height: 12),
                                Text(
                                  '데이터 조회 중...',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              );
            });
          },
        ),
      ),
    );
  }
}
