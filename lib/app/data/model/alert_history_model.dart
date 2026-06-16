import 'package:json_annotation/json_annotation.dart';

import 'base_model.dart';

part 'alert_history_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AlertHistoryModel extends BaseModel {

  final int? alertId;
  final DateTime? alertOccurredAt;
  final DateTime? alertConfirmedAt;
  final String? alertConfirmUserId;
  final String? buildingCd;
  final String? buildingName;
  final String? edgeCd;
  // diNo, diName 사용안함.
  final int? diNo;
  final String? diName;

  final String? floorInfo;
  final String? alertLevelCd;
  final String? alertCategoryCd;
  final String? alertStatus;
  final String? isFalseAlert;
  final String? alertReason;

  final String? companyCd;
  final String? sysAlertName;
  final String? primarySensorName;
  final String? mapId;
  final String? sopId;
  final String? cctvId;
  final String? mapBlobUrl;
  final String? sopBlobUrl;
  final String? cctvBlobUrl;


  AlertHistoryModel({
    this.alertId,
    this.alertOccurredAt,
    this.alertConfirmedAt,
    this.alertConfirmUserId,
    this.buildingCd,
    this.buildingName,
    this.edgeCd,
    this.diNo,
    this.diName,
    this.floorInfo,
    this.alertLevelCd,
    this.alertCategoryCd,
    this.alertStatus,
    this.isFalseAlert,
    this.alertReason,

    this.companyCd,
    this.sysAlertName,
    this.primarySensorName,
    this.mapId,
    this.sopId,
    this.cctvId,
    this.mapBlobUrl,
    this.sopBlobUrl,
    this.cctvBlobUrl,

    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super(createdAt: createdAt, updatedAt: updatedAt);

  factory AlertHistoryModel.fromJson(Map<String, dynamic> json) => _$AlertHistoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$AlertHistoryModelToJson(this);

  isValidMapId() => (mapId!='noimage' && mapId!.isNotEmpty);
  isValidSopId() => (sopId!='noimage' && sopId!.isNotEmpty);
  isValidCctvId() => (cctvId!='noimage' && cctvId!.isNotEmpty);

}