import 'dart:math' as math;

import 'package:HGPcWeb/app/data/model/user_model.dart';
import 'package:HGPcWeb/app/modules/user/user_controller.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../common/show_custom_snackbar.dart';
import '../common/widget/TableCellText.dart';
import '../common/widget/TableColumnText.dart';
import '../common/widget/confirm_approve.dart';
import '../common/widget/confirm_delete.dart';
import 'edit/user_edit_dialog.dart';

class UserScreen extends StatelessWidget {
  // const 제거(핫리로드 시 시그니처 충돌 방지)
  UserScreen({super.key});

  /// 화면이 넓을 때 테이블이 같이 커지도록 하는 기준 최소폭
  static const double _kBaselineMinWidth = 1600;

  /// 우리가 “고정”으로 두고 싶은 컬럼들의 합(선택/ID/빌딩/등록/수정)
  /// 선택(50) + 사용자ID(110) + 빌딩코드(160) + 등록일(150) + 수정일(150) = 620
  static const double _kFixedSumPlanned = 620;

  /// 고정폭을 적용할 최소 가용폭 임계치(버퍼 포함)
  static const double _kEnableFixedIfWiderThan = 720;

  @override
  Widget build(BuildContext context) {
    final controller = UserController.to;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            SizedBox(width: 10),
            // Text('User Management', style: TextStyle(color: Colors.black)),

            // const Spacer(),
            // 수정
            ElevatedButton(
              onPressed: () async {
                if (controller.selected.isNotEmpty) {
                  final selected = controller.getSelected()!;
                  final result = await showDialog<UserModel>(
                    context: context,
                    builder:
                        (_) => UserEditDialog(
                          mode: '수정',
                          initialData: selected,
                          onSave: (_) {},
                        ),
                  );
                  if (result != null) {
                    final idx = controller.userList.indexWhere(
                      (e) => e.userId == result.userId,
                    );
                    if (idx >= 0) {
                      controller.userList[idx] = result;
                      showCustomSnackbar('성공', '사용자 정보 수정이 완료되었습니다.');
                    } else {
                      showCustomSnackbar('실패', '사용자 정보 수정에 실패했습니다.');
                    }
                  }
                } else {
                  showCustomSnackbar('안내', '수정할 사용자를 선택해 주세요');
                }
              },
              child: const Text('수정'),
            ),
            const SizedBox(width: 8),

            // 승인
            ElevatedButton(
              onPressed: () async {
                if (controller.selected.isNotEmpty) {
                  final selected = controller.getSelected()!;
                  if (selected.isApproved == 'Y') {
                    showCustomSnackbar('안내', '이미 승인된 사용자입니다.');
                    return;
                  }
                  final ok = await confirmApprove(selected.userId);
                  if (ok == true) {
                    try {
                      await controller.approveUser(selected.userId);
                      showCustomSnackbar('성공', '사용자 승인이 완료되었습니다.');
                    } catch (e) {
                      showCustomSnackbar('오류', '사용자 승인 실패: $e');
                    }
                  }
                } else {
                  showCustomSnackbar('안내', '승인할 사용자를 선택해 주세요');
                }
              },
              child: const Text('승인'),
            ),
            const SizedBox(width: 8),

            // 삭제
            ElevatedButton(
              onPressed: () async {
                if (controller.selected.isNotEmpty) {
                  final userId = controller.getSelected()!.userId;
                  final ok = await confirmDelete(userId);
                  if (ok == true) {
                    try {
                      await controller.deleteUser(userId);
                      final idx = controller.userList.indexWhere(
                        (e) => e.userId == userId,
                      );
                      if (idx >= 0) controller.userList.removeAt(idx);
                      showCustomSnackbar('성공', '사용자 삭제가 완료되었습니다.');
                    } catch (e) {
                      showCustomSnackbar('오류', '사용자 삭제 실패: $e');
                    }
                  }
                } else {
                  showCustomSnackbar('안내', '삭제할 사용자를 선택해 주세요');
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
            final double availableW = constraints.maxWidth;

            // DataTable2의 assert 회피:
            // - 화면이 매우 좁을 땐 고정폭을 전부 해제(모두 가변)해서 "고정폭 합 > 가용폭"을 절대 만들지 않음
            final bool useFixedWidths = availableW >= _kEnableFixedIfWiderThan;

            // 화면이 넓으면 끝까지, 아니면 가로 스크롤
            final double tableMinWidth = math.max(
              _kBaselineMinWidth,
              availableW,
            );

            // 동적 컬럼 구성(고정/가변을 가용폭에 따라 스위칭)
            List<DataColumn2> buildColumns() {
              return [
                // 선택
                useFixedWidths
                    ? const DataColumn2(
                      label: Center(child: TableColumnText('선택')),
                      fixedWidth: 50,
                    )
                    : const DataColumn2(
                      label: Center(child: TableColumnText('선택')),
                    ),

                // 사용자ID
                useFixedWidths
                    ? const DataColumn2(
                      label: Center(child: TableColumnText('사용자ID')),
                      fixedWidth: 110,
                    )
                    : const DataColumn2(
                      label: Center(child: TableColumnText('사용자ID')),
                    ),

                // 가변 컬럼들
                const DataColumn2(
                  label: Center(child: TableColumnText('사용자이름')),
                ),
                const DataColumn2(
                  label: Center(child: TableColumnText('휴대폰번호')),
                ),
                const DataColumn2(label: Center(child: TableColumnText('회사명'))),
                const DataColumn2(label: Center(child: TableColumnText('부서명'))),
                const DataColumn2(label: Center(child: TableColumnText('직급'))),
                const DataColumn2(
                  label: Center(child: TableColumnText('로컬관리자\n여부')),
                ),

                // 빌딩코드(식별성 위해 넓을 때만 고정)
                useFixedWidths
                    ? const DataColumn2(
                      label: Center(child: TableColumnText('빌딩코드')),
                      fixedWidth: 160,
                    )
                    : const DataColumn2(
                      label: Center(child: TableColumnText('빌딩코드')),
                    ),

                const DataColumn2(label: Center(child: TableColumnText('빌딩명'))),

                const DataColumn2(
                  label: Center(child: TableColumnText('앱경보\n수신여부')),
                ),
                const DataColumn2(
                  label: Center(child: TableColumnText('일림톡\n수신여부')),
                ),
                const DataColumn2(
                  label: Center(child: TableColumnText('SMS\n수신여부')),
                ),
                const DataColumn2(
                  label: Center(child: TableColumnText('TTS\n수신여부')),
                ),
                const DataColumn2(
                  label: Center(child: TableColumnText('승인여부')),
                ),

                // 등록/수정일(넓을 때만 고정)
                useFixedWidths
                    ? const DataColumn2(
                      label: Center(child: TableColumnText('등록일')),
                      fixedWidth: 150,
                    )
                    : const DataColumn2(
                      label: Center(child: TableColumnText('등록일')),
                    ),
                useFixedWidths
                    ? const DataColumn2(
                      label: Center(child: TableColumnText('수정일')),
                      fixedWidth: 150,
                    )
                    : const DataColumn2(
                      label: Center(child: TableColumnText('수정일')),
                    ),
              ];
            }

            return Obx(() {
              return Container(
                width: double.infinity,
                padding: EdgeInsets.zero,
                color: Colors.white,
                child: DataTable2(
                  scrollController: controller.controller,
                  horizontalScrollController: controller.horizontalController,

                  // 좌우 여백/간격 최소화
                  horizontalMargin: 0,
                  columnSpacing: 0,

                  // 화면이 넓으면 끝까지, 좁으면 가로 스크롤
                  minWidth: tableMinWidth,

                  headingRowColor: MaterialStateProperty.all(
                    Colors.grey.shade200,
                  ),
                  sortColumnIndex: controller.sortColumnIndex,
                  sortAscending: controller.sortAscending,

                  columns: buildColumns(),

                  rows: List.generate(controller.userList.length, (index) {
                    final user = controller.userList[index];

                    return DataRow2.byIndex(
                      index: index,
                      selected: controller.isSelected(index),
                      onTap: () => controller.toggleSelection(index),
                      cells:
                          [
                                // 승인된 사용자는 체크박스 숨김
                                (user.isApproved == 'Y')
                                    ? const DataCell(SizedBox.shrink())
                                    : DataCell(
                                      Center(
                                        child: Checkbox(
                                          value: controller.isSelected(index),
                                          onChanged:
                                              (_) => controller.toggleSelection(
                                                index,
                                              ),
                                        ),
                                      ),
                                    ),
                                DataCell(
                                  Center(child: TableCellText(user.userId)),
                                ),
                                DataCell(
                                  Center(
                                    child: TableCellText(user.userName ?? ''),
                                  ),
                                ),
                                DataCell(
                                  Center(
                                    child: TableCellText(
                                      user.mobilePhoneNo ?? '',
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Center(
                                    child: TableCellText(
                                      user.companyName ?? '',
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Center(
                                    child: TableCellText(user.department ?? ''),
                                  ),
                                ),
                                DataCell(
                                  Center(
                                    child: TableCellText(user.position ?? ''),
                                  ),
                                ),
                                DataCell(
                                  Center(
                                    child: TableCellText(user.isLocalAdmin),
                                  ),
                                ),
                                DataCell(
                                  Center(child: TableCellText(user.buildingCd)),
                                ),
                                DataCell(
                                  Center(
                                    child: TableCellText(
                                      user.buildingName ?? '-',
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Center(
                                    child: TableCellText(
                                      user.isReceiveAppAlert,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Center(
                                    child: TableCellText(
                                      user.isReceiveKakaoAlert,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Center(
                                    child: TableCellText(user.isReceiveSms),
                                  ),
                                ),
                                DataCell(
                                  Center(
                                    child: TableCellText(user.isReceiveTts),
                                  ),
                                ),
                                DataCell(
                                  Center(child: TableCellText(user.isApproved)),
                                ),
                                DataCell(
                                  Center(
                                    child: TableCellText(user.formatCreateAt()),
                                  ),
                                ),
                                DataCell(
                                  Center(
                                    child: TableCellText(
                                      user.formatUpdatedAt(),
                                    ),
                                  ),
                                ),
                              ]
                              .map(
                                (c) => DataCell(
                                  DefaultTextStyle.merge(
                                    style: const TextStyle(fontSize: 14),
                                    child: c.child,
                                  ),
                                ),
                              )
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
