import 'package:json_annotation/json_annotation.dart';

import 'base_model.dart';

part 'user_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class UserModel extends BaseModel {
  final String userId; // CHAR(7) PK
  final String buildingCd; // CHAR(14) NOT NULL
  final String? buildingName; // CHAR(13) NOT NULL
  final String? userName; // VARCHAR(50)
  final String? mobilePhoneNo; // VARCHAR(10)
  final String? companyName; // VARCHAR(50)
  final String? department; // VARCHAR(50)
  final String? position; // VARCHAR(50)
  final String isLocalAdmin; // CHAR(1) NOT NULL
  final String isReceiveAppAlert; // CHAR(1) NOT NULL DEFAULT 'Y'
  final String isReceiveKakaoAlert; // CHAR(1) NOT NULL DEFAULT 'Y'
  final String isReceiveSms; // CHAR(1) NOT NULL DEFAULT 'Y'
  final String isReceiveTts; // CHAR(1) NOT NULL DEFAULT 'Y'
  String isApproved; // CHAR(1) NOT NULL DEFAULT 'N'

  UserModel({
    required this.userId,
    required this.buildingCd,
    this.buildingName,
    this.userName,
    this.mobilePhoneNo,
    this.companyName,
    this.department,
    this.position,
    required this.isLocalAdmin,
    required this.isReceiveAppAlert,
    required this.isReceiveKakaoAlert,
    required this.isReceiveSms,
    required this.isReceiveTts,
    required this.isApproved,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super(createdAt: createdAt, updatedAt: updatedAt);

  /// ✅ copyWith 추가
  UserModel copyWith({
    String? userId,
    String? buildingCd,
    String? buildingName,
    String? userName,
    String? mobilePhoneNo,
    String? companyName,
    String? department,
    String? position,
    String? isLocalAdmin,
    String? isReceiveAppAlert,
    String? isReceiveKakaoAlert,
    String? isReceiveSms,
    String? isReceiveTts,
    String? isApproved,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      buildingCd: buildingCd ?? this.buildingCd,
      buildingName: buildingName ?? this.buildingName,
      userName: userName ?? this.userName,
      mobilePhoneNo: mobilePhoneNo ?? this.mobilePhoneNo,
      companyName: companyName ?? this.companyName,
      department: department ?? this.department,
      position: position ?? this.position,
      isLocalAdmin: isLocalAdmin ?? this.isLocalAdmin,
      isReceiveAppAlert: isReceiveAppAlert ?? this.isReceiveAppAlert,
      isReceiveKakaoAlert: isReceiveKakaoAlert ?? this.isReceiveKakaoAlert,
      isReceiveSms: isReceiveSms ?? this.isReceiveSms,
      isReceiveTts: isReceiveTts ?? this.isReceiveTts,
      isApproved: isApproved ?? this.isApproved,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Null 처리
  // factory UserModel.fromJson(Map<String, dynamic> json) =>
  //_$UserModelFromJson(json);
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['user_id'] ?? '',
      buildingCd: json['building_cd'] ?? '',
      buildingName: json['building_name'],
      userName: json['user_name'],
      mobilePhoneNo: json['mobile_phone_no'] ?? '', // ✅ 핵심
      companyName: json['company_name'],
      department: json['department'],
      position: json['position'],
      isLocalAdmin: json['is_local_admin'] ?? 'N',
      isReceiveAppAlert: json['is_receive_app_alert'] ?? 'Y',
      isReceiveKakaoAlert: json['is_receive_kakao_alert'] ?? 'Y',
      isReceiveSms: json['is_receive_sms'] ?? 'Y',
      isReceiveTts: json['is_receive_tts'] ?? 'Y',
      isApproved: json['is_approved'] ?? 'N',
      createdAt:
          json['created_at'] != null
              ? DateTime.parse(json['created_at'])
              : null,
      updatedAt:
          json['updated_at'] != null
              ? DateTime.parse(json['updated_at'])
              : null,
    );
  }

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
