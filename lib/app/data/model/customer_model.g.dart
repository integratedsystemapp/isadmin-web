// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomerModel _$CustomerModelFromJson(Map<String, dynamic> json) =>
    CustomerModel(
      companyCd: json['company_cd'] as String,
      companyName: json['company_name'] as String,
      businessRegistrationNo: json['business_registration_no'] as String?,
      address: json['address'] as String?,
      addressDetail: json['address_detail'] as String?,
      companyPhoneNo: json['company_phone_no'] as String?,
      ceoName: json['ceo_name'] as String?,
      businessTypeCd: json['business_type_cd'] as String?,
      businessItem: json['business_item'] as String?,
      managerName: json['manager_name'] as String?,
      managerPosition: json['manager_position'] as String?,
      managerTelNo: json['manager_tel_no'] as String?,
      managerMobileNo: json['manager_mobile_no'] as String?,
      managerEmail: json['manager_email'] as String?,
      invoiceIssueDate: json['invoice_issue_date'] as String?,
      contractAmount: (json['contract_amount'] as num?)?.toInt(),
      eformsignDocId: json['eformsign_doc_id'] as String?,
      isServiceEnabled: json['is_service_enabled'] as String? ?? 'Y',
      createdAt:
          json['created_at'] == null
              ? null
              : DateTime.parse(json['created_at'] as String),
      updatedAt:
          json['updated_at'] == null
              ? null
              : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$CustomerModelToJson(CustomerModel instance) =>
    <String, dynamic>{
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'company_cd': instance.companyCd,
      'company_name': instance.companyName,
      'business_registration_no': instance.businessRegistrationNo,
      'address': instance.address,
      'address_detail': instance.addressDetail,
      'company_phone_no': instance.companyPhoneNo,
      'ceo_name': instance.ceoName,
      'business_type_cd': instance.businessTypeCd,
      'business_item': instance.businessItem,
      'manager_name': instance.managerName,
      'manager_position': instance.managerPosition,
      'manager_tel_no': instance.managerTelNo,
      'manager_mobile_no': instance.managerMobileNo,
      'manager_email': instance.managerEmail,
      'invoice_issue_date': instance.invoiceIssueDate,
      'contract_amount': instance.contractAmount,
      'eformsign_doc_id': instance.eformsignDocId,
      'is_service_enabled': instance.isServiceEnabled,
    };
