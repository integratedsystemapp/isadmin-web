import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/model/customer_model.dart';
import '../../common/api_service.dart';
import '../../common/show_custom_snackbar.dart';

class CustomerEditController extends GetxController {
  final isServiceActive = true.obs;

  final Map<String, TextEditingController> controllers = {
    'company_cd': TextEditingController(),
    'company_name': TextEditingController(),
    'business_registration_no': TextEditingController(),
    'address': TextEditingController(),
    'address_detail': TextEditingController(),
    'company_phone_no': TextEditingController(),
    'ceo_name': TextEditingController(),
    'business_type_cd': TextEditingController(),
    'business_item': TextEditingController(),
    'manager_name': TextEditingController(),
    'manager_position': TextEditingController(),
    'manager_tel_no': TextEditingController(),
    'manager_mobile_no': TextEditingController(),
    'manager_email': TextEditingController(),
    'invoice_issue_date': TextEditingController(),
    'contract_amount': TextEditingController(),
    'eformsign_doc_id': TextEditingController(),
  };

  void initFields(CustomerModel model) {
    controllers['company_cd']?.text = model.companyCd;
    controllers['company_name']?.text = model.companyName;
    controllers['business_registration_no']?.text = model.businessRegistrationNo ?? '';
    controllers['address']?.text = model.address ?? '';
    controllers['address_detail']?.text = model.addressDetail ?? '';
    controllers['company_phone_no']?.text = model.companyPhoneNo ?? '';
    controllers['ceo_name']?.text = model.ceoName ?? '';
    controllers['business_type_cd']?.text = model.businessTypeCd ?? '';
    controllers['business_item']?.text = model.businessItem ?? '';
    controllers['manager_name']?.text = model.managerName ?? '';
    controllers['manager_position']?.text = model.managerPosition ?? '';
    controllers['manager_tel_no']?.text = model.managerTelNo ?? '';
    controllers['manager_mobile_no']?.text = model.managerMobileNo ?? '';
    controllers['manager_email']?.text = model.managerEmail ?? '';
    controllers['invoice_issue_date']?.text = model.invoiceIssueDate ?? '';

    // controllers['contract_amount']?.text = model.formatContractAmount();

    controllers['contract_amount']?.text = model.contractAmount?.toString() ?? '';
    controllers['eformsign_doc_id']?.text = model.eformsignDocId ?? '';
    isServiceActive.value = model.isServiceEnabled == 'Y';
  }

  CustomerModel collectModel() {
    return CustomerModel(
      companyCd: controllers['company_cd']!.text,
      companyName: controllers['company_name']!.text,
      businessRegistrationNo: controllers['business_registration_no']?.text,
      address: controllers['address']?.text,
      addressDetail: controllers['address_detail']?.text,
      companyPhoneNo: controllers['company_phone_no']?.text,
      ceoName: controllers['ceo_name']?.text,
      businessTypeCd: controllers['business_type_cd']?.text,
      businessItem: controllers['business_item']?.text,
      managerName: controllers['manager_name']?.text,
      managerPosition: controllers['manager_position']?.text,
      managerTelNo: controllers['manager_tel_no']?.text,
      managerMobileNo: controllers['manager_mobile_no']?.text,
      managerEmail: controllers['manager_email']?.text,
      invoiceIssueDate: controllers['invoice_issue_date']?.text.isNotEmpty ?? false
          ? controllers['invoice_issue_date']!.text
          : null,
      contractAmount: int.tryParse( controllers['contract_amount']!.text.replaceAll(',', '')),
      eformsignDocId: controllers['eformsign_doc_id']?.text,
      isServiceEnabled: isServiceActive.value ? 'Y' : 'N',
    );
  }

  @override
  void onClose() {
    for (final controller in controllers.values) {
      controller.dispose();
    }
    super.onClose();
  }

  Future<CustomerModel?> updateCustomer() async {
    final updatedCustomer = collectModel(); // 폼에서 데이터 수집
    CustomerModel? _newCustomerModel ;

    debugPrint('updateCustomer:${updatedCustomer.toJson().toString()}');
    try {
      final response = await ApiService().put(
        '/customer/${updatedCustomer.companyCd}',  // URL에 companyCd 포함
        updatedCustomer.toJson(), // JSON 바디
      );

      // debugPrint('--->');
      // debugPrint(response.toString());
      // debugPrint('--->');



      if (response.statusCode == 200) {
        // showCustomSnackbar('성공', '고객 정보가 수정되었습니다.');
        _newCustomerModel = CustomerModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        // showCustomSnackbar('오류', '수정 실패: ${response.statusCode}');
      }
      return _newCustomerModel;

    } catch (e) {
      debugPrint('Error updating customer: $e');
      // showCustomSnackbar('에러', '네트워크 오류: $e');
      rethrow;
    }
  }

  Future<CustomerModel?> createCustomer() async {
    final newCustomer = collectModel();
    CustomerModel? _newCustomerModel ;
    try {
      final response = await ApiService().post(
        '/customer/',
        newCustomer.toJson(),
      );

      // debugPrint('============>');
      // debugPrint(response.toString());
      // debugPrint('============>');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // showCustomSnackbar('성공', '고객이 등록되었습니다.');
        _newCustomerModel = CustomerModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        // showCustomSnackbar('오류', '등록 실패: ${response.statusCode}');
      }
      return _newCustomerModel;
    } catch (e) {
      debugPrint('Error create customer: $e');
      // debugPrint('네트워크 오류: $e');
      rethrow;
    }
  }





}
