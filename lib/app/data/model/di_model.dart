import 'package:json_annotation/json_annotation.dart';

import 'base_model.dart';

part 'di_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class DiModel extends BaseModel {

  final String companyCd;
  final String? companyName;
  final String buildingCd;
  final String? buildingName;
  final String edgeCd;
  final String? edgeName;
  final int diNo;
  final String? diName;
  final String? floorInfo;
  final String? mapImageFileName;
  final String? mapImageUrl;
  final String? sopImageFileName;
  final String? sopImageUrl;
  final String alertLevelCd;
  final String alertCategoryCd;
  final String isAlertReceivable;        // 'Y'/'N'
  final String alertStatusType;          // 상태 코드 (예: '1')
  final String? defaultConnectionString;

  DiModel({
    required this.companyCd,
    this.companyName,
    required this.buildingCd,
    this.buildingName,
    required this.edgeCd,
    this.edgeName,
    required this.diNo,
    this.diName,
    this.floorInfo,
    this.mapImageFileName,
    this.mapImageUrl,
    this.sopImageFileName,
    this.sopImageUrl,
    required this.alertLevelCd,
    required this.alertCategoryCd,
    required this.isAlertReceivable,
    required this.alertStatusType,
    this.defaultConnectionString,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super(createdAt: createdAt, updatedAt: updatedAt);

  factory DiModel.fromJson(Map<String, dynamic> json) => _$DiModelFromJson(json);

  Map<String, dynamic> toJson() => _$DiModelToJson(this);

}