import 'package:json_annotation/json_annotation.dart';

import 'base_model.dart';

part 'building_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class BuildingModel extends BaseModel {
  final String companyCd;
  final String? companyName;
  final String buildingCd;
  final String buildingName;
  final String? address;
  final String? addressDetail; // 상세주소
  final int? edgeCount;
  final DateTime? contractDate;
  final int contractTermMonths;
  final DateTime? usageStartDate;
  final DateTime? usageEndDate;
  final String? managerName;
  final String? managerPosition;
  final String? managerPhoneNo;
  final double? monthlyFee;
  final String isReceivePaidMsg;
  final String? buildingImageFileName;
  final String? buildingImageUrl;
  final String isServiceEnabled;

  BuildingModel({

    required this.companyCd,
    this.companyName,
    required this.buildingCd,
    required this.buildingName,
    this.address,
    this.addressDetail,
    this.edgeCount,
    this.contractDate,
    required this.contractTermMonths,
    required this.usageStartDate,
    required this.usageEndDate,
    this.managerName,
    this.managerPosition,
    this.managerPhoneNo,
    this.monthlyFee,
    required this.isReceivePaidMsg,
    this.buildingImageFileName,
    this.buildingImageUrl,
    required this.isServiceEnabled,

    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super(createdAt: createdAt, updatedAt: updatedAt);

  factory BuildingModel.fromJson(Map<String, dynamic> json) => _$BuildingModelFromJson(json);

  Map<String, dynamic> toJson() => _$BuildingModelToJson(this);


  Map<String, dynamic> toJson2() => {
    'company_cd': companyCd,
    'building_cd': buildingCd,
    'building_name': buildingName,
    'address': address,
    'address_detail': addressDetail,
    'edge_count': edgeCount,
    'contract_date': contractDate?.toIso8601String().split('T')[0],
    'contract_term_months': contractTermMonths,
    'usage_start_date': usageStartDate?.toIso8601String().split('T')[0],
    'usage_end_date': usageEndDate?.toIso8601String().split('T')[0],
    'manager_name': managerName,
    'manager_position': managerPosition,
    'manager_phone_no': managerPhoneNo,
    'monthly_fee': monthlyFee,
    'is_receive_paid_msg': isReceivePaidMsg,
    'building_image_file_name': buildingImageFileName,
    'building_image_url': buildingImageUrl,
    'is_service_enabled': isServiceEnabled,
  };

  addressInfo() => ('${address??''} ${addressDetail??''}'.length < 2 ) ? '' : '${address??''} ${addressDetail??''}';

}