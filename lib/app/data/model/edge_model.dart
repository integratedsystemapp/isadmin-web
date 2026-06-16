import 'package:json_annotation/json_annotation.dart';

import 'base_model.dart';

part 'edge_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class EdgeModel extends BaseModel {

  final String companyCd;
  @JsonKey(includeToJson: false) // <-- toJson에서 제외
  final String? companyName;
  final String buildingCd;
  final String? buildingName;
  final String edgeCd;
  final String edgeName;

  // final int? diNo;
  // final String? diName;
  // final String? floorInfo;
  // final String? mapImageFileName;
  // final String? mapImageUrl;
  // final String? sopImageFileName;
  // final String? sopImageUrl;
  // final String? alertLevelCd;
  // final String? alertCategoryCd;
  // final String? isAlertReceivable;
  // final String? alertStatusType;

  // String? defaultConnectionString;

  final String? edgeInstallLocation;

  EdgeModel({
    required this.companyCd,
    this.companyName,
    required this.buildingCd,
    this.buildingName,
    required this.edgeCd,
    required this.edgeName,

    // this.diNo,
    // this.diName,
    // this.floorInfo,
    // this.mapImageFileName,
    // this.mapImageUrl,
    // this.sopImageFileName,
    // this.sopImageUrl,
    // this.alertLevelCd,
    // this.alertCategoryCd,
    // this.isAlertReceivable,
    // this.alertStatusType,
    //
    // this.defaultConnectionString,

    this.edgeInstallLocation,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super(createdAt: createdAt, updatedAt: updatedAt);

  factory EdgeModel.fromJson(Map<String, dynamic> json) => _$EdgeModelFromJson(json);

  Map<String, dynamic> toJson() => _$EdgeModelToJson(this);

}