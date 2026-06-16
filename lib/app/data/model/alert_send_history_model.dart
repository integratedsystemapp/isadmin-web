import 'package:json_annotation/json_annotation.dart';

import 'base_model.dart';

part 'alert_send_history_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AlertSendHistoryModel extends BaseModel {

  final int? id;
  final int? alertId;
  final String? recipientPhoneNo;
  final String? recipientName;
  final DateTime? pushSentAt;
  final String? pushTitle;
  final String? pushMessage;
  final DateTime? paidMsgSentAt;
  final String? paidMsgTypeCd;
  final String? paidMsgContent;
  final String? buildingCd;
  final String? buildingName;
  final String? edgeCd;
  final int? diNo;
  final String? diName;
  final String? floorInfo;
  final String? alertLevelCd;
  final String? alertCategoryCd;

  AlertSendHistoryModel({
    this.id,
    this.alertId,
    this.recipientPhoneNo,
    this.recipientName,
    this.pushSentAt,
    this.pushTitle,
    this.pushMessage,
    this.paidMsgSentAt,
    this.paidMsgTypeCd,
    this.paidMsgContent,
    this.buildingCd,
    this.buildingName,
    this.edgeCd,
    this.diNo,
    this.diName,
    this.floorInfo,
    this.alertLevelCd,
    this.alertCategoryCd,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super(createdAt: createdAt, updatedAt: updatedAt);

  factory AlertSendHistoryModel.fromJson(Map<String, dynamic> json) => _$AlertSendHistoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$AlertSendHistoryModelToJson(this);

  pushTitleString() => ('${pushTitle??''}}'.length < 2 ) ? '' : pushTitle;
  pushMessageString() => ('${pushMessage??''}}'.length < 2 ) ? '' : pushMessage;


}