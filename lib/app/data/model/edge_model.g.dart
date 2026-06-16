// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edge_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EdgeModel _$EdgeModelFromJson(Map<String, dynamic> json) => EdgeModel(
  companyCd: json['company_cd'] as String,
  companyName: json['company_name'] as String?,
  buildingCd: json['building_cd'] as String,
  buildingName: json['building_name'] as String?,
  edgeCd: json['edge_cd'] as String,
  edgeName: json['edge_name'] as String,
  edgeInstallLocation: json['edge_install_location'] as String?,
  createdAt:
      json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
  updatedAt:
      json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$EdgeModelToJson(EdgeModel instance) => <String, dynamic>{
  'created_at': instance.createdAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
  'company_cd': instance.companyCd,
  'building_cd': instance.buildingCd,
  'building_name': instance.buildingName,
  'edge_cd': instance.edgeCd,
  'edge_name': instance.edgeName,
  'edge_install_location': instance.edgeInstallLocation,
};
