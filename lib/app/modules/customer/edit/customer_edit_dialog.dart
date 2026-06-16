import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/extension/thousands_separator_input_formatter.dart';
import '../../../../core/values/consts.dart';
import '../../../data/model/customer_model.dart';
import '../customer_controller.dart';
import 'address_form_page.dart';
import 'customer_edit_controller.dart';
import 'dart:html' as html;

class CustomerEditDialog extends StatelessWidget {
  final String mode; // '등록' 또는 '수정'
  final CustomerModel initialData;
  final void Function(CustomerModel) onSave;

  CustomerEditDialog({super.key, required this.mode, required this.initialData, required this.onSave});

  final _formKey = GlobalKey<FormState>();
  final customerEditController = Get.put(CustomerEditController());
  final customerController = CustomerController.to;

  final List<String> fieldLabels = [
    "회사코드",
    "회사명",
    "사업자등록번호",
    "주소",
    "대표번호",
    "대표자",
    "업태",
    "종목",
    "담당자성명",
    "담당자직책",
    "담당자유선전화",
    "담당자휴대전화",
    "담당자이메일",
    "계산서발행일",
    "계산서발행금액",
    "이폼사인ID",
  ];

  final List<String> fieldKeys = [
    "company_cd",
    "company_name",
    "business_registration_no",
    "address",
    "company_phone_no",
    "ceo_name",
    "business_type_cd",
    "business_item",
    "manager_name",
    "manager_position",
    "manager_tel_no",
    "manager_mobile_no",
    "manager_email",
    "invoice_issue_date",
    "contract_amount",
    "eformsign_doc_id",
  ];

  @override
  Widget build(BuildContext context) {
    customerEditController.initFields(initialData);
    final labelWidth = 160.0;
    final dialogWidth = 800.0;

    return AlertDialog(
      title: Text('고객 정보 $mode'),
      content: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: SCROLL_BAR_MARGIN),
          width: dialogWidth,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                /*
                회사코드
                 */
                if (mode == '수정')
                  Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // 필수여부 아이콘 표시
                      Text('*', style: TextStyle(color: Colors.red)),
                      SizedBox(width: labelWidth, child: Text('회사코드')),
                      Expanded(
                        child: TextFormField(
                          readOnly: true,
                          controller: customerEditController.controllers['company_cd'],
                          style: TextStyle(fontSize: 12),
                          decoration: const InputDecoration(border: OutlineInputBorder()),
                          validator: (value) {
                          },
                        ),
                      ),
                    ],
                  ),
                ),


                /*
                회사명
                 */
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
                          controller: customerEditController.controllers['company_name'],
                          style: TextStyle(fontSize: 12),
                          decoration: const InputDecoration(border: OutlineInputBorder()),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return '회사명을 입력해주세요';
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



                /*
                사업자등록번호
                 */
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // 필수여부 아이콘 표시
                      Text('*', style: TextStyle(color: Colors.transparent)),
                      SizedBox(width: labelWidth, child: Text('사업자등록번호')),
                      Expanded(
                        child: TextFormField(
                          controller: customerEditController.controllers['business_registration_no'],
                          style: TextStyle(fontSize: 12),
                          decoration: const InputDecoration(border: OutlineInputBorder()),
                          validator: (value) {
                            /*
                            if (value == null || value.trim().isEmpty) {
                              return '사업자등록번호를 입력해주세요';
                            }
                             */
                            if (value != null && value.length > 12) {
                              return '12자리 이내로 입력해주세요';
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),



                /*
                주소
                 */
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Column(children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('*', style: TextStyle(color: Colors.transparent),),
                SizedBox(
                  width: labelWidth,
                  child: Text('주소'),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () async {

                      /*
                    final selected = await Get.dialog<String>(AddressFormPage());
                    if (selected != null && selected is String) {
                      customerEditController.controllers['address']?.text = selected;
                      debugPrint('Selected address: $selected');
                    }

                     */

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

                          customerEditController.controllers['address']?.text = '${zc} ${addr}';
                        }
                      });


                    },
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: customerEditController.controllers['address'],
                        style: TextStyle(fontSize: 12),

                        // maxLines: 2,
                        decoration: const InputDecoration(border: OutlineInputBorder()),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10,),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 필수여부 아이콘 표시
                Text('*', style: TextStyle(color: Colors.transparent)),
                SizedBox(width: labelWidth),
                Expanded(
                  child: TextFormField(
                    controller: customerEditController.controllers['address_detail'],
                    style: TextStyle(fontSize: 12),
                    decoration: const InputDecoration(border: OutlineInputBorder()),
                    validator: (value) {
                      if(customerEditController.controllers['address_detail'] != null
                          && customerEditController.controllers['address_detail']!.text.isNotEmpty) {
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
          ],)
        ),



                /*
                대표전화
                 */
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child:
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // 필수여부 아이콘 표시
                      Text('*', style: TextStyle(color: Colors.transparent)),
                      SizedBox(width: labelWidth, child: Text('대표번호')),
                      Expanded(
                        child: TextFormField(
                          controller: customerEditController.controllers['company_phone_no'],
                          style: TextStyle(fontSize: 12),
                          decoration: const InputDecoration(border: OutlineInputBorder()),
                          validator: (value) {
                            /*
                            if (value == null || value.trim().isEmpty) {
                              return '사업자등록번호를 입력해주세요';
                            }
                             */
                            if (value != null && value.length > 12) {
                              return '12자리 이내로 입력해주세요';
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),



                /*
                대표자
                 */
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // 필수여부 아이콘 표시
                      Text('*', style: TextStyle(color: Colors.transparent)),
                      SizedBox(width: labelWidth, child: Text('대표자')),
                      Expanded(
                        child: TextFormField(
                          controller: customerEditController.controllers['ceo_name'],
                          style: TextStyle(fontSize: 12),
                          decoration: const InputDecoration(border: OutlineInputBorder()),
                          validator: (value) {
                            /*
                            if (value == null || value.trim().isEmpty) {
                              return '사업자등록번호를 입력해주세요';
                            }
                             */
                            if (value != null && value.length > 12) {
                              return '12자리 이내로 입력해주세요';
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),




                /*
                업태
                 */
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // 필수여부 아이콘 표시
                      Text('*', style: TextStyle(color: Colors.transparent)),
                      SizedBox(width: labelWidth, child: Text('업태')),
                      Expanded(
                        child: TextFormField(
                          controller: customerEditController.controllers['business_type_cd'],
                          style: TextStyle(fontSize: 12),
                          decoration: const InputDecoration(border: OutlineInputBorder()),
                          validator: (value) {
                            /*
                            if (value == null || value.trim().isEmpty) {
                              return '사업자등록번호를 입력해주세요';
                            }
                             */
                            if (value != null && value.length > 12) {
                              return '12자리 이내로 입력해주세요';
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),



                /*
                종목
                 */
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // 필수여부 아이콘 표시
                      Text('*', style: TextStyle(color: Colors.transparent)),
                      SizedBox(width: labelWidth, child: Text('종목')),
                      Expanded(
                        child: TextFormField(
                          controller: customerEditController.controllers['business_item'],
                          style: TextStyle(fontSize: 12),
                          decoration: const InputDecoration(border: OutlineInputBorder()),
                          validator: (value) {
                            /*
                            if (value == null || value.trim().isEmpty) {
                              return '사업자등록번호를 입력해주세요';
                            }
                             */
                            if (value != null && value.length > 12) {
                              return '12자리 이내로 입력해주세요';
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),



                /*
                담당자성명
                 */
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
                          controller: customerEditController.controllers['manager_name'],
                          style: TextStyle(fontSize: 12),
                          decoration: const InputDecoration(border: OutlineInputBorder()),
                          validator: (value) {
                            /*
                            if (value == null || value.trim().isEmpty) {
                              return '사업자등록번호를 입력해주세요';
                            }
                             */
                            if (value != null && value.length > 10) {
                              return '12자리 이내로 입력해주세요';
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),



                /*
                담당자직책
                 */
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
                          controller: customerEditController.controllers['manager_position'],
                          style: TextStyle(fontSize: 12),
                          decoration: const InputDecoration(border: OutlineInputBorder()),
                          validator: (value) {
                            /*
                            if (value == null || value.trim().isEmpty) {
                              return '사업자등록번호를 입력해주세요';
                            }
                             */
                            if (value != null && value.length > 10) {
                              return '12자리 이내로 입력해주세요';
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),



                /*
                담당자유선전화
                 */
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // 필수여부 아이콘 표시
                      Text('*', style: TextStyle(color: Colors.transparent)),
                      SizedBox(width: labelWidth, child: Text('담당자 유선전화')),
                      Expanded(
                        child: TextFormField(
                          controller: customerEditController.controllers['manager_tel_no'],
                          style: TextStyle(fontSize: 12),
                          decoration: const InputDecoration(border: OutlineInputBorder()),
                          validator: (value) {
                            /*
                            if (value == null || value.trim().isEmpty) {
                              return '사업자등록번호를 입력해주세요';
                            }
                             */
                            if (value != null && value.length > 10) {
                              return '12자리 이내로 입력해주세요';
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),



                /*
                담당자휴대전화
                 */
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // 필수여부 아이콘 표시
                      Text('*', style: TextStyle(color: Colors.transparent)),
                      SizedBox(width: labelWidth, child: Text('담당자 휴대전화')),
                      Expanded(
                        child: TextFormField(
                          controller: customerEditController.controllers['manager_mobile_no'],
                          style: TextStyle(fontSize: 12),
                          decoration: const InputDecoration(border: OutlineInputBorder()),
                          validator: (value) {
                            /*
                            if (value == null || value.trim().isEmpty) {
                              return '사업자등록번호를 입력해주세요';
                            }
                             */
                            if (value != null && value.length > 13) {
                              return '13자리 이내로 입력해주세요';
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                /*
                담당자 이메일
                 */
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // 필수여부 아이콘 표시
                      Text('*', style: TextStyle(color: Colors.transparent)),
                      SizedBox(width: labelWidth, child: Text('담당자 이메일')),
                      Expanded(
                        child: TextFormField(
                          controller: customerEditController.controllers['manager_email'],
                          style: TextStyle(fontSize: 12),
                          decoration: const InputDecoration(border: OutlineInputBorder()),
                          validator: (value) {
                            /*
                            if (value == null || value.trim().isEmpty) {
                              return '사업자등록번호를 입력해주세요';
                            }
                             */
                            if (value != null && value.length > 20) {
                              return '20자리 이내로 입력해주세요';
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),



                /*
                계산서발행일
                 */
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // 필수여부 아이콘 표시
                      Text('*', style: TextStyle(color: Colors.transparent)),
                      SizedBox(width: labelWidth, child: Text('계산서 발행일')),
                      Expanded(
                        child: TextFormField(
                          controller: customerEditController.controllers['invoice_issue_date'],
                          style: TextStyle(fontSize: 12),
                          decoration: const InputDecoration(border: OutlineInputBorder()),
                          validator: (value) {
                            /*
                            if (value == null || value.trim().isEmpty) {
                              return '사업자등록번호를 입력해주세요';
                            }
                             */
                            if (value != null && value.length > 12) {
                              return '12자리 이내로 입력해주세요';
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                /*
                계산서발행금액
                 */
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // 필수여부 아이콘 표시
                      Text('*', style: TextStyle(color: Colors.red)),
                      SizedBox(width: labelWidth, child: Text('계산서 발행금액')),
                      Expanded(
                        child: TextFormField(
                          controller: customerEditController.controllers['contract_amount'],
                          style: TextStyle(fontSize: 12),
                          keyboardType: TextInputType.number,
                            inputFormatters: [ThousandsSeparatorInputFormatter()],
                          decoration: const InputDecoration(border: OutlineInputBorder()),
                          validator: (value) {

                            if (value == null || value.trim().isEmpty) {
                              return '계산서 발행금액을 입력해주세요';
                            }

                            if (value != null && value.length > 10) {
                              // return '12자리 이내로 입력해주세요';
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),


                /*
                서비스사용여부
                 */

                Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('서비스사용여부'),
                    Switch(
                      value: customerEditController.isServiceActive.value,
                      onChanged: (val) => customerEditController.isServiceActive.value = val,
                    ),
                  ],
                )),


              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
            Get.delete<CustomerEditController>();
          },
          child: const Text('취소'),
        ),
        ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              try {
                final data = customerEditController.collectModel();

                final custController = CustomerController.to;

                if (mode == '등록') {
                  // debugPrint('111:등록');
                  final newCustomer = customerEditController.createCustomer();
                  // onSave(data); 또는 snackbar 시에 안닫힘
                  Get.back(result: newCustomer);
                } else {
                  try {
                    debugPrint('update 시작');
                    final newCustomer = customerEditController.updateCustomer();
                    Get.back(result: newCustomer);
                  } catch (e, stack) {
                    debugPrint('에러 발생: $e');
                    debugPrint('Stack: $stack');
                    // Get.snackbar('에러', '수정 중 오류 발생: $e');
                  }
                }
              } catch (e) {
                Get.snackbar('에러', '수정 중 오류 발생: $e');
              }
            }
          },
          child: Text(mode == '등록' ? '등록' : '저장'),
        ),
      ],
    );
  }
}
