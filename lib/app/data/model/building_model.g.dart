// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'building_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BuildingModel _$BuildingModelFromJson(Map<String, dynamic> json) =>
    BuildingModel(
      companyCd: json['company_cd'] as String,
      companyName: json['company_name'] as String?,
      buildingCd: json['building_cd'] as String,
      buildingName: json['building_name'] as String,
      address: json['address'] as String?,
      addressDetail: json['address_detail'] as String?,
      edgeCount: (json['edge_count'] as num?)?.toInt(),
      contractDate:
          json['contract_date'] == null
              ? null
              : DateTime.parse(json['contract_date'] as String),
      contractTermMonths: (json['contract_term_months'] as num).toInt(),
      usageStartDate:
          json['usage_start_date'] == null
              ? null
              : DateTime.parse(json['usage_start_date'] as String),
      usageEndDate:
          json['usage_end_date'] == null
              ? null
              : DateTime.parse(json['usage_end_date'] as String),
      managerName: json['manager_name'] as String?,
      managerPosition: json['manager_position'] as String?,
      managerPhoneNo: json['manager_phone_no'] as String?,
      monthlyFee: (json['monthly_fee'] as num?)?.toDouble(),
      isReceivePaidMsg: json['is_receive_paid_msg'] as String,
      buildingImageFileName: json['building_image_file_name'] as String?,
      buildingImageUrl: json['building_image_url'] as String?,
      isServiceEnabled: json['is_service_enabled'] as String,
      createdAt:
          json['created_at'] == null
              ? null
              : DateTime.parse(json['created_at'] as String),
      updatedAt:
          json['updated_at'] == null
              ? null
              : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$BuildingModelToJson(BuildingModel instance) =>
    <String, dynamic>{
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'company_cd': instance.companyCd,
      'company_name': instance.companyName,
      'building_cd': instance.buildingCd,
      'building_name': instance.buildingName,
      'address': instance.address,
      'address_detail': instance.addressDetail,
      'edge_count': instance.edgeCount,
      'contract_date': instance.contractDate?.toIso8601String(),
      'contract_term_months': instance.contractTermMonths,
      'usage_start_date': instance.usageStartDate?.toIso8601String(),
      'usage_end_date': instance.usageEndDate?.toIso8601String(),
      'manager_name': instance.managerName,
      'manager_position': instance.managerPosition,
      'manager_phone_no': instance.managerPhoneNo,
      'monthly_fee': instance.monthlyFee,
      'is_receive_paid_msg': instance.isReceivePaidMsg,
      'building_image_file_name': instance.buildingImageFileName,
      'building_image_url': instance.buildingImageUrl,
      'is_service_enabled': instance.isServiceEnabled,
    };
