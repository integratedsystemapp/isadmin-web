import 'dart:math' as math;

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/utils/date_web_utils.dart';
import '../../../core/values/consts.dart';
import '../common/widget/TableCellText.dart';
import '../common/widget/TableColumnText.dart';
import 'altert_send_history_controller.dart';

class AlertSendHistoryScreen extends StatelessWidget {
  const AlertSendHistoryScreen({super.key});

  /// 고정폭 합계(가변: 푸시제목, 푸시내용, 유료메시지 내용 제외)
  static const double _kFixedSum = 1900;
  static const double _kExtra = 200; // 버퍼

  @override
  Widget build(BuildContext context) {
    final controller = AlertSendHistoryController.to;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            SizedBox(width: 10,),
            Text('경보 발송 히스토리', style: TextStyle(color: Colors.black),),

            const Spacer(),
            IconButton(
              tooltip: '새로고침',
              onPressed: () => controller.refreshAll(),
              icon: const Icon(Icons.refresh, color: Colors.black,),
            ),
          ],
        ),
      ),
      body: Obx(() {
        return Stack(
          children: [
            // ===== 본문 =====
            Column(
              children: [
                Expanded(
                  child: SafeArea(
                    left: false,
                    right: false,
                    top: false,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final available = constraints.maxWidth;
                        final minWidth = math.max(available, _kFixedSum + _kExtra);

                        return Padding(
                          // 좌우 여백 제거, 상하만 유지(원하면 0으로)
                          padding: const EdgeInsets.only(
                            top: 0,
                            bottom: DATATABLE_MARGIN,   // 필요 없으면 0으로
                            // horizontal은 이미 0
                          ),
                          child: DataTable2(
                            scrollController: controller.controller,
                            horizontalScrollController: controller.horizontalController,
                            columnSpacing: 0,
                            horizontalMargin: 0,
                            minWidth: minWidth,
                            sortColumnIndex: controller.sortColumnIndex,
                            sortAscending: controller.sortAscending,

                            // ✅ 가변 컬럼(푸시제목, 푸시내용, 유료메시지 내용)은 fixedWidth 미지정
                            columns: const [
                              DataColumn2(label: Center(child: TableColumnText('순번')), fixedWidth: 50),
                              DataColumn2(label: Center(child: TableColumnText('경보ID')), fixedWidth: 50),
                              DataColumn2(label: Center(child: TableColumnText('수신전화번호')), fixedWidth: 100),
                              DataColumn2(label: Center(child: TableColumnText('수신자명')), fixedWidth: 100),
                              DataColumn2(label: Center(child: TableColumnText('푸시발송시간')), fixedWidth: 150),

                              // ⬇️ 가변 1
                              DataColumn2(label: Center(child: TableColumnText('푸시제목'))),

                              // ⬇️ 가변 2
                              DataColumn2(label: Center(child: TableColumnText('푸시내용'))),

                              DataColumn2(label: Center(child: TableColumnText('유료메시지\n발송시간')), fixedWidth: 150),
                              DataColumn2(label: Center(child: TableColumnText('유료메시지\n발송타입')), fixedWidth: 100),

                              // ⬇️ 가변 3
                              DataColumn2(label: Center(child: TableColumnText('유료메시지\n내용'))),

                              DataColumn2(label: Center(child: TableColumnText('빌딩코드')), fixedWidth: 150),
                              DataColumn2(label: Center(child: TableColumnText('빌딩명')), fixedWidth: 150),
                              DataColumn2(label: Center(child: TableColumnText('Edge코드')), fixedWidth: 150),
                              DataColumn2(label: Center(child: TableColumnText('DI No')), fixedWidth: 50),
                              DataColumn2(label: Center(child: TableColumnText('DI명칭')), fixedWidth: 100),
                              DataColumn2(label: Center(child: TableColumnText('Floor정보')), fixedWidth: 100),
                              DataColumn2(label: Center(child: TableColumnText('경보등급')), fixedWidth: 100),
                              DataColumn2(label: Center(child: TableColumnText('경보분류')), fixedWidth: 100),
                              DataColumn2(label: Center(child: TableColumnText('등록일')), fixedWidth: 150),
                              DataColumn2(label: Center(child: TableColumnText('수정일')), fixedWidth: 150),
                            ],

                            rows: List<DataRow2>.generate(
                              controller.alertSendHistoryList.length,
                                  (index) {
                                final a = controller.alertSendHistoryList[index];
                                return DataRow2.byIndex(
                                  index: index,
                                  selected: controller.isSelected(index),
                                  onTap: () => controller.toggleSelection(index),
                                  cells: [
                                    DataCell(Center(child: TableCellText(a.id.toString()))),
                                    DataCell(Center(child: TableCellText(a.alertId.toString()))),
                                    DataCell(Center(child: TableCellText(a.recipientPhoneNo ?? ''))),
                                    DataCell(Center(child: TableCellText(a.recipientName ?? ''))),
                                    DataCell(Center(child: TableCellText(DateWebUtils.toYYYYMMDDWithTime(a.pushSentAt)))),

                                    // 가변 1: 푸시제목 (툴팁 + 말줄임)
                                    DataCell(
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Tooltip(
                                          message: a.pushTitleString(),
                                          child: TableCellText(a.pushTitleString()),
                                        ),
                                      ),
                                    ),

                                    // 가변 2: 푸시내용 (툴팁 + 말줄임)
                                    DataCell(
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Tooltip(
                                          message: a.pushMessageString(),
                                          child: TableCellText(a.pushMessageString()),
                                        ),
                                      ),
                                    ),

                                    DataCell(Center(child: TableCellText(DateWebUtils.toYYYYMMDDWithTime(a.paidMsgSentAt)))),
                                    DataCell(Center(child: TableCellText(a.paidMsgTypeCd ?? ''))),

                                    // 가변 3: 유료메시지 내용 (툴팁 + 말줄임)
                                    DataCell(
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Tooltip(
                                          message: a.paidMsgContent ?? '',
                                          child: TableCellText(a.paidMsgContent ?? ''),
                                        ),
                                      ),
                                    ),

                                    DataCell(Center(child: TableCellText(a.buildingCd ?? ''))),
                                    DataCell(Center(child: TableCellText(a.buildingName ?? ''))),
                                    DataCell(Center(child: TableCellText(a.edgeCd ?? ''))),
                                    DataCell(Center(child: TableCellText(a.diNo.toString()))),
                                    DataCell(Center(child: TableCellText(a.diName ?? ''))),
                                    DataCell(Center(child: TableCellText(a.floorInfo ?? ''))),
                                    DataCell(Center(child: TableCellText(a.alertLevelCd ?? ''))),
                                    DataCell(Center(child: TableCellText(a.alertCategoryCd ?? ''))),
                                    DataCell(Center(child: TableCellText(a.formatCreateAt()))),
                                    DataCell(Center(child: TableCellText(a.formatUpdatedAt()))),
                                  ].map(
                                        (cell) => DataCell(
                                      DefaultTextStyle.merge(
                                        style: const TextStyle(fontSize: 14),
                                        child: cell.child,
                                      ),
                                    ),
                                  ).toList(),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // ===== 하단 상태바 =====
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: () {
                    if (controller.isLoading.value &&
                        controller.alertSendHistoryList.isEmpty) {
                      return const CupertinoActivityIndicator();
                    }
                    if (controller.isLoading.value &&
                        controller.alertSendHistoryList.isNotEmpty) {
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

            // ===== 오버레이(#1) =====
            if (controller.isLoading.value) ...[
              Positioned.fill(
                child: AbsorbPointer(
                  absorbing: true, // 터치 차단
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
      }),
    );
  }
}
