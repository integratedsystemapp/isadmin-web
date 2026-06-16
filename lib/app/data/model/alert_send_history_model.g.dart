// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alert_send_history_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AlertSendHistoryModel _$AlertSendHistoryModelFromJson(
  Map<String, dynamic> json,
) => AlertSendHistoryModel(
  id: (json['id'] as num?)?.toInt(),
  alertId: (json['alert_id'] as num?)?.toInt(),
  recipientPhoneNo: json['recipient_phone_no'] as String?,
  recipientName: json['recipient_name'] as String?,
  pushSentAt:
      json['push_sent_at'] == null
          ? null
          : DateTime.parse(json['push_sent_at'] as String),
  pushTitle: json['push_title'] as String?,
  pushMessage: json['push_message'] as String?,
  paidMsgSentAt:
      json['paid_msg_sent_at'] == null
          ? null
          : DateTime.parse(json['paid_msg_sent_at'] as String),
  paidMsgTypeCd: json['paid_msg_type_cd'] as String?,
  paidMsgContent: json['paid_msg_content'] as String?,
  buildingCd: json['building_cd'] as String?,
  buildingName: json['building_name'] as String?,
  edgeCd: json['edge_cd'] as String?,
  diNo: (json['di_no'] as num?)?.toInt(),
  diName: json['di_name'] as String?,
  floorInfo: json['floor_info'] as String?,
  alertLevelCd: json['alert_level_cd'] as String?,
  alertCategoryCd: json['alert_category_cd'] as String?,
  createdAt:
      json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
  updatedAt:
      json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$AlertSendHistoryModelToJson(
  AlertSendHistoryModel instance,
) => <String, dynamic>{
  'created_at': instance.createdAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
  'id': instance.id,
  'alert_id': instance.alertId,
  'recipient_phone_no': instance.recipientPhoneNo,
  'recipient_name': instance.recipientName,
  'push_sent_at': instance.pushSentAt?.toIso8601String(),
  'push_title': instance.pushTitle,
  'push_message': instance.pushMessage,
  'paid_msg_sent_at': instance.paidMsgSentAt?.toIso8601String(),
  'paid_msg_type_cd': instance.paidMsgTypeCd,
  'paid_msg_content': instance.paidMsgContent,
  'building_cd': instance.buildingCd,
  'building_name': instance.buildingName,
  'edge_cd': instance.edgeCd,
  'di_no': instance.diNo,
  'di_name': instance.diName,
  'floor_info': instance.floorInfo,
  'alert_level_cd': instance.alertLevelCd,
  'alert_category_cd': instance.alertCategoryCd,
};
