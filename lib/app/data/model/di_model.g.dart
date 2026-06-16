// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'di_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DiModel _$DiModelFromJson(Map<String, dynamic> json) => DiModel(
  companyCd: json['company_cd'] as String,
  companyName: json['company_name'] as String?,
  buildingCd: json['building_cd'] as String,
  buildingName: json['building_name'] as String?,
  edgeCd: json['edge_cd'] as String,
  edgeName: json['edge_name'] as String?,
  diNo: (json['di_no'] as num).toInt(),
  diName: json['di_name'] as String?,
  floorInfo: json['floor_info'] as String?,
  mapImageFileName: json['map_image_file_name'] as String?,
  mapImageUrl: json['map_image_url'] as String?,
  sopImageFileName: json['sop_image_file_name'] as String?,
  sopImageUrl: json['sop_image_url'] as String?,
  alertLevelCd: json['alert_level_cd'] as String,
  alertCategoryCd: json['alert_category_cd'] as String,
  isAlertReceivable: json['is_alert_receivable'] as String,
  alertStatusType: json['alert_status_type'] as String,
  defaultConnectionString: json['default_connection_string'] as String?,
  createdAt:
      json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
  updatedAt:
      json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$DiModelToJson(DiModel instance) => <String, dynamic>{
  'created_at': instance.createdAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
  'company_cd': instance.companyCd,
  'company_name': instance.companyName,
  'building_cd': instance.buildingCd,
  'building_name': instance.buildingName,
  'edge_cd': instance.edgeCd,
  'edge_name': instance.edgeName,
  'di_no': instance.diNo,
  'di_name': instance.diName,
  'floor_info': instance.floorInfo,
  'map_image_file_name': instance.mapImageFileName,
  'map_image_url': instance.mapImageUrl,
  'sop_image_file_name': instance.sopImageFileName,
  'sop_image_url': instance.sopImageUrl,
  'alert_level_cd': instance.alertLevelCd,
  'alert_category_cd': instance.alertCategoryCd,
  'is_alert_receivable': instance.isAlertReceivable,
  'alert_status_type': instance.alertStatusType,
  'default_connection_string': instance.defaultConnectionString,
};
