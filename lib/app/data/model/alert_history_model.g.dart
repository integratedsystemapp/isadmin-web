// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alert_history_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AlertHistoryModel _$AlertHistoryModelFromJson(Map<String, dynamic> json) =>
    AlertHistoryModel(
      alertId: (json['alert_id'] as num?)?.toInt(),
      alertOccurredAt:
          json['alert_occurred_at'] == null
              ? null
              : DateTime.parse(json['alert_occurred_at'] as String),
      alertConfirmedAt:
          json['alert_confirmed_at'] == null
              ? null
              : DateTime.parse(json['alert_confirmed_at'] as String),
      alertConfirmUserId: json['alert_confirm_user_id'] as String?,
      buildingCd: json['building_cd'] as String?,
      buildingName: json['building_name'] as String?,
      edgeCd: json['edge_cd'] as String?,
      diNo: (json['di_no'] as num?)?.toInt(),
      diName: json['di_name'] as String?,
      floorInfo: json['floor_info'] as String?,
      alertLevelCd: json['alert_level_cd'] as String?,
      alertCategoryCd: json['alert_category_cd'] as String?,
      alertStatus: json['alert_status'] as String?,
      isFalseAlert: json['is_false_alert'] as String?,
      alertReason: json['alert_reason'] as String?,
      companyCd: json['company_cd'] as String?,
      sysAlertName: json['sys_alert_name'] as String?,
      primarySensorName: json['primary_sensor_name'] as String?,
      mapId: json['map_id'] as String?,
      sopId: json['sop_id'] as String?,
      cctvId: json['cctv_id'] as String?,
      mapBlobUrl: json['map_blob_url'] as String?,
      sopBlobUrl: json['sop_blob_url'] as String?,
      cctvBlobUrl: json['cctv_blob_url'] as String?,
      createdAt:
          json['created_at'] == null
              ? null
              : DateTime.parse(json['created_at'] as String),
      updatedAt:
          json['updated_at'] == null
              ? null
              : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$AlertHistoryModelToJson(AlertHistoryModel instance) =>
    <String, dynamic>{
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'alert_id': instance.alertId,
      'alert_occurred_at': instance.alertOccurredAt?.toIso8601String(),
      'alert_confirmed_at': instance.alertConfirmedAt?.toIso8601String(),
      'alert_confirm_user_id': instance.alertConfirmUserId,
      'building_cd': instance.buildingCd,
      'building_name': instance.buildingName,
      'edge_cd': instance.edgeCd,
      'di_no': instance.diNo,
      'di_name': instance.diName,
      'floor_info': instance.floorInfo,
      'alert_level_cd': instance.alertLevelCd,
      'alert_category_cd': instance.alertCategoryCd,
      'alert_status': instance.alertStatus,
      'is_false_alert': instance.isFalseAlert,
      'alert_reason': instance.alertReason,
      'company_cd': instance.companyCd,
      'sys_alert_name': instance.sysAlertName,
      'primary_sensor_name': instance.primarySensorName,
      'map_id': instance.mapId,
      'sop_id': instance.sopId,
      'cctv_id': instance.cctvId,
      'map_blob_url': instance.mapBlobUrl,
      'sop_blob_url': instance.sopBlobUrl,
      'cctv_blob_url': instance.cctvBlobUrl,
    };
