// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  userId: json['user_id'] as String,
  buildingCd: json['building_cd'] as String,
  buildingName: json['building_name'] as String?,
  userName: json['user_name'] as String?,
  mobilePhoneNo: json['mobile_phone_no'] as String?,
  companyName: json['company_name'] as String?,
  department: json['department'] as String?,
  position: json['position'] as String?,
  isLocalAdmin: json['is_local_admin'] as String,
  isReceiveAppAlert: json['is_receive_app_alert'] as String,
  isReceiveKakaoAlert: json['is_receive_kakao_alert'] as String,
  isReceiveSms: json['is_receive_sms'] as String,
  isReceiveTts: json['is_receive_tts'] as String,
  isApproved: json['is_approved'] as String,
  createdAt:
      json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
  updatedAt:
      json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'created_at': instance.createdAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
  'user_id': instance.userId,
  'building_cd': instance.buildingCd,
  'building_name': instance.buildingName,
  'user_name': instance.userName,
  'mobile_phone_no': instance.mobilePhoneNo,
  'company_name': instance.companyName,
  'department': instance.department,
  'position': instance.position,
  'is_local_admin': instance.isLocalAdmin,
  'is_receive_app_alert': instance.isReceiveAppAlert,
  'is_receive_kakao_alert': instance.isReceiveKakaoAlert,
  'is_receive_sms': instance.isReceiveSms,
  'is_receive_tts': instance.isReceiveTts,
  'is_approved': instance.isApproved,
};
