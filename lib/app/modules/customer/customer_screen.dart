import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/values/consts.dart';
import '../../data/model/customer_model.dart';
import '../../widgets/copy_icon_button.dart';
import '../common/show_custom_snackbar.dart';
import '../common/widget/TableCellText.dart';
import '../common/widget/TableColumnText.dart';
import '../common/widget/confirm_delete.dart';
import 'contract/contract_send.dart';
import 'customer_controller.dart';
import 'edit/customer_edit_dialog.dart';

class CustomerScreen extends StatelessWidget {
  CustomerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = CustomerController.to;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            SizedBox(width: 10),
            // Text('Customer Management', style: TextStyle(color: Colors.black)),
            // const Spacer(),
            // 등록
            ElevatedButton(
              onPressed: () async {
                final result = await showDialog(
                  context: context,
                  builder:
                      (_) => CustomerEditDialog(
                        mode: '등록',
                        initialData: CustomerModel(
                          companyCd: '',
                          companyName: '',
                        ),
                        onSave: (updated) {
                          // 모달 내부 저장 콜백 (옵션)
                        },
                      ),
                );

                if (result != null) {
                  controller.customerList.add(result);
                  showCustomSnackbar('성공', '고객 정보 등록이  완료 되었습니다.');
                }
              },
              child: const Text('등록'),
            ),
            const SizedBox(width: 8),

            // 수정
            ElevatedButton(
              onPressed: () async {
                if (controller.selected.isNotEmpty) {
                  final selectedCustomer = controller.getSelected()!;
                  final result = await showDialog(
                    context: context,
                    builder:
                        (_) => CustomerEditDialog(
                          mode: '수정',
                          initialData: selectedCustomer,
                          onSave: (updated) {},
                        ),
                  );

                  if (result != null) {
                    final idx = controller.customerList.indexWhere(
                      (e) => e.companyCd == result.companyCd,
                    );
                    if (idx >= 0) {
                      controller.customerList[idx] = result;
                      showCustomSnackbar('성공', '고객 정보 수정이  완료 되었습니다.');
                    } else {
                      showCustomSnackbar('실패', '고객 정보 수정이 실패 했습니다.');
                    }
                  }
                } else {
                  showCustomSnackbar('안내', '수정 할 고객을 선택 해 주세요');
                }
              },
              child: const Text('수정'),
            ),
            const SizedBox(width: 8),

            // 삭제
            ElevatedButton(
              onPressed: () async {
                if (controller.selected.isNotEmpty) {
                  final companyCd = controller.getSelected()!.companyCd;
                  final result = await confirmDelete(companyCd);
                  if (result == true) {
                    try {
                      await controller.deleteCustomer(companyCd);
                      final index = controller.customerList.indexWhere(
                        (e) => e.companyCd == companyCd,
                      );
                      if (index >= 0) {
                        controller.customerList.removeAt(index);
                      }
                      showCustomSnackbar('성공', '고객 정보 삭제가  완료 되었습니다.');
                    } catch (e) {
                      showCustomSnackbar('오류', '고객 정보 삭제가 실패 했습니다.: $e');
                    }
                  }
                } else {
                  showCustomSnackbar('안내', '삭제 할 고객을 선택 해 주세요');
                }
              },
              child: const Text('삭제'),
            ),
            const SizedBox(width: 16),
          ],
        ),
      ),

      // ===== 본문: 좌우 여백 없이, 브라우저 폭 커지면 테이블도 같이 확대 =====
      body: SafeArea(
        left: false,
        right: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            // 브라우저 뷰포트 너비와 비교해서 minWidth 를 결정
            final double tableMinWidth =
                constraints.maxWidth > 3000 ? constraints.maxWidth : 3000;

            return Obx(() {
              return Container(
                padding: EdgeInsets.zero, // 좌우 여백 제거
                width: double.infinity,
                child: DataTable2(
                  // 스크롤 컨트롤러 (수직/수평)
                  scrollController: controller.controller,
                  horizontalScrollController: controller.horizontalController,

                  // 좌우 셀 내부 여백 최소화
                  horizontalMargin: 0,
                  columnSpacing: 0,

                  // 브라우저 폭 커질 때 함께 확장
                  minWidth: tableMinWidth,

                  sortColumnIndex: controller.sortColumnIndex.value,
                  sortAscending: controller.sortAscending.value,

                  columns: [
                    const DataColumn2(
                      label: Center(child: TableColumnText('선택')),
                      fixedWidth: 50,
                    ),

                    DataColumn2(
                      label: const Center(child: TableColumnText('회사코드')),
                      fixedWidth: 100,
                      onSort:
                          (columnIndex, ascending) => controller.sortBy<String>(
                            (e) => e.companyCd,
                            columnIndex,
                            ascending,
                          ),
                    ),

                    DataColumn2(
                      label: const Center(child: TableColumnText('회사명')),
                      fixedWidth: 150,
                      onSort:
                          (columnIndex, ascending) => controller.sortBy<String>(
                            (e) => e.companyName,
                            columnIndex,
                            ascending,
                          ),
                    ),

                    const DataColumn2(
                      label: Center(child: TableColumnText('사업자\n등록번호')),
                      fixedWidth: 150,
                    ),

                    // 주소: 유동 폭으로 둬서 남는 공간 흡수
                    const DataColumn2(
                      label: Center(child: TableColumnText('주소')),
                      // fixedWidth: 250
                      size: ColumnSize.S,
                    ),

                    const DataColumn2(
                      label: Center(child: TableColumnText('대표번호')),
                      fixedWidth: 100,
                    ),
                    const DataColumn2(
                      label: Center(child: TableColumnText('대표자')),
                      fixedWidth: 100,
                    ),
                    const DataColumn2(
                      label: Center(child: TableColumnText('업태')),
                      fixedWidth: 100,
                    ),
                    const DataColumn2(
                      label: Center(child: TableColumnText('종목')),
                      fixedWidth: 100,
                    ),
                    const DataColumn2(
                      label: Center(child: TableColumnText('담당자\n성명')),
                      fixedWidth: 100,
                    ),
                    const DataColumn2(
                      label: Center(child: TableColumnText('담당자\n직책')),
                      fixedWidth: 100,
                    ),
                    const DataColumn2(
                      label: Center(child: TableColumnText('담당자\n유선전화')),
                      fixedWidth: 100,
                    ),
                    const DataColumn2(
                      label: Center(child: TableColumnText('담당자\n휴대전화')),
                      fixedWidth: 120,
                    ),

                    // 이메일: 유동 폭
                    const DataColumn2(
                      label: Center(child: TableColumnText('담당자\n이메일')),
                      // fixedWidth: 120
                      size: ColumnSize.S,
                    ),

                    const DataColumn2(
                      label: Center(child: TableColumnText('계산서\n발행일')),
                      fixedWidth: 100,
                    ),
                    const DataColumn2(
                      label: Center(child: TableColumnText('계산서\n발행금액')),
                      fixedWidth: 100,
                    ),
                    /*
                    const DataColumn2(
                        label: Center(child: TableColumnText('이폼사인ID')),
                        fixedWidth: 180),

                     */
                    const DataColumn2(
                      label: Center(child: TableColumnText('서비스\n사용여부')),
                      fixedWidth: 100,
                    ),
                    /*
                    const DataColumn2(
                        label: Center(child: TableColumnText('계약서 발송')),
                        fixedWidth: 110),
                    const DataColumn2(
                        label: Center(child: TableColumnText('다운로드')),
                        fixedWidth: 110),
                    const DataColumn2(
                        label: Center(child: TableColumnText('첨부파일\n다운로드')),
                        fixedWidth: 130),

                     */
                    const DataColumn2(
                      label: Center(child: TableColumnText('등록일')),
                      fixedWidth: 150,
                    ),
                    const DataColumn2(
                      label: Center(child: TableColumnText('수정일')),
                      fixedWidth: 150,
                    ),
                  ],

                  rows: List.generate(controller.customerList.length, (index) {
                    final customer = controller.customerList[index];

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
                              onChanged:
                                  (_) => controller.toggleSelection(index),
                            ),
                          ),
                        ),

                        // 회사 코드/명
                        DataCell(
                          Center(
                            child: TableCellText(
                              customer.companyCd,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        DataCell(
                          Center(
                            child: TableCellText(
                              customer.companyName,
                              fontSize: 14,
                            ),
                          ),
                        ),

                        // 사업자번호
                        DataCell(
                          Center(
                            child: TableCellText(
                              customer.businessRegistrationNo ?? '',
                              fontSize: 14,
                            ),
                          ),
                        ),

                        // 주소(유동폭) + 툴팁 + 한 줄 말줄임
                        DataCell(
                          customer.addressInfo().isNotEmpty
                              ? Tooltip(
                                message: customer.addressInfo(),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: TableCellText(
                                    customer.addressInfo(),
                                    fontSize: 14,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              )
                              : const SizedBox.shrink(),
                        ),

                        // 대표번호/대표자/업태/종목
                        DataCell(
                          Center(
                            child: TableCellText(
                              customer.companyPhoneNo ?? '',
                              fontSize: 14,
                            ),
                          ),
                        ),
                        DataCell(
                          Center(
                            child: TableCellText(
                              customer.ceoName ?? '',
                              fontSize: 14,
                            ),
                          ),
                        ),
                        DataCell(
                          Center(
                            child: TableCellText(
                              customer.businessTypeCd ?? '',
                              fontSize: 14,
                            ),
                          ),
                        ),
                        DataCell(
                          Center(
                            child: TableCellText(
                              customer.businessItem ?? '',
                              fontSize: 14,
                            ),
                          ),
                        ),

                        // 담당자 정보
                        DataCell(
                          Center(
                            child: TableCellText(
                              customer.managerName ?? '',
                              fontSize: 14,
                            ),
                          ),
                        ),
                        DataCell(
                          Center(
                            child: TableCellText(
                              customer.managerPosition ?? '',
                              fontSize: 14,
                            ),
                          ),
                        ),
                        DataCell(
                          Center(
                            child: TableCellText(
                              customer.managerTelNo ?? '',
                              fontSize: 14,
                            ),
                          ),
                        ),
                        DataCell(
                          Center(
                            child: TableCellText(
                              customer.managerMobileNo ?? '',
                              fontSize: 14,
                            ),
                          ),
                        ),

                        // 이메일(유동폭, 말줄임)
                        DataCell(
                          Align(
                            alignment: Alignment.centerLeft,
                            child: TableCellText(
                              customer.managerEmail ?? '',
                              fontSize: 14,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),

                        // 계산서 발행일/금액
                        DataCell(
                          Center(
                            child: TableCellText(
                              customer.invoiceIssueDate ?? '',
                              fontSize: 14,
                            ),
                          ),
                        ),

                        DataCell(
                          Center(
                            child: TableCellText(
                              customer.formatContractAmount(),
                              fontSize: 14,
                            ),
                          ),
                        ),

                        // 이폼사인 DocId + 복사 버튼
                        // buildEformSignIdCell(customer.eformsignDocId),

                        // 서비스 사용여부
                        DataCell(
                          Center(
                            child: TableCellText(
                              customer.isServiceEnabled,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        /*
                        // 계약서 발송 버튼
                        DataCell(
                          Center(
                            child: (customer.isValidEformDocId())
                                ? const Text('발송 완료',
                                style: TextStyle(fontSize: 14))
                                : ElevatedButton(
                              onPressed: () async {
                                if (customer.managerMobileNo == null ||
                                    customer.managerMobileNo!
                                        .replaceAll('-', '')
                                        .length !=
                                        11) {
                                  showCustomSnackbar(
                                      '오류', '담당자 휴대전화 등록 후 이용하세요');
                                  return;
                                }
                                if (customer.companyName.isEmpty) {
                                  showCustomSnackbar(
                                      '오류', '회사명 등록 후 이용하세요');
                                  return;
                                }
                                if (customer.managerName == null ||
                                    customer.managerName!.isEmpty) {
                                  showCustomSnackbar(
                                      '오류', '담당자 이름 등록 후 이용하세요');
                                  return;
                                }

                                final data = ContractInitData(
                                  companyCd: customer.companyCd,
                                  companyName: customer.companyName,
                                  bizNo:
                                  customer.businessRegistrationNo ??
                                      '-',
                                  ceoName: customer.ceoName ?? '-',
                                  managerName: customer.managerName,
                                  managerEmail: customer.managerEmail,
                                  managerMobile: customer.managerMobileNo,
                                );

                                final contractSendModel =
                                await openContractSendDialog(data);
                                if (contractSendModel == null) {
                                  return;
                                }

                                final documentId = await controller
                                    .sendContractDocument(
                                    contractSendModel);

                                // 계약서발송 다큐먼트ID 업데이트
                                if (documentId != null &&
                                    documentId.isNotEmpty) {
                                  final idx = controller.customerList
                                      .indexWhere((e) =>
                                  e.companyCd ==
                                      customer.companyCd);
                                  customer.eformsignDocId = documentId;
                                  if (idx >= 0) {
                                    controller.customerList[idx] =
                                        customer;
                                  }
                                }
                              },
                              child: const Text('발송'),
                            ),
                          ),
                        ),

                        // 다운로드1 (계약 문서 다운로드)
                        DataCell(
                          Center(
                            child: (!customer.isValidEformDocId())
                                ? const Text('-', style: TextStyle(fontSize: 14))
                                : ElevatedButton(
                              onPressed: () {
                                if (customer.eformsignDocId != null) {
                                  final docId = customer.eformsignDocId!;
                                  controller.downloadDocument(docId);
                                } else {
                                  showCustomSnackbar(
                                      '안내', '계약 문서가 존재하지 않습니다.');
                                }
                              },
                              child: const Text('다운로드'),
                            ),
                          ),
                        ),

                        // 첨부문서 다운로드2
                        DataCell(
                          Center(
                            child: (!customer.isValidEformDocId())
                                ? const Text('-', style: TextStyle(fontSize: 14))
                                : ElevatedButton(
                              onPressed: (customer.eformsignDocId ==
                                  null)
                                  ? null
                                  : () {
                                if (customer.eformsignDocId !=
                                    null) {
                                  final docId =
                                  customer.eformsignDocId!;
                                  controller
                                      .downloadAttachDocument(
                                      docId);
                                } else {
                                  showCustomSnackbar(
                                      '안내', '계약문서 존재하지 않습니다.');
                                }
                              },
                              child: const Text('다운로드'),
                            ),
                          ),
                        ),


 */
                        // 등록일/수정일
                        DataCell(
                          Center(
                            child: TableCellText(
                              customer.formatCreateAt(),
                              fontSize: 14,
                            ),
                          ),
                        ),
                        DataCell(
                          Center(
                            child: TableCellText(
                              customer.formatUpdatedAt(),
                              fontSize: 14,
                            ),
                          ),
                        ),
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

// 이폼사인 DocId 셀 + 복사 버튼
DataCell buildEformSignIdCell(String? docId) {
  if (docId != null && docId.length > 5) {
    return DataCell(
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              docId,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          const SizedBox(width: 8),
          CopyIconButton(textToCopy: docId),
        ],
      ),
    );
  } else {
    return const DataCell(
      Center(child: Text('-', style: TextStyle(fontSize: 14))),
    );
  }
}
