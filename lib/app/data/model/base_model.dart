import 'package:json_annotation/json_annotation.dart';

import '../../../core/utils/date_web_utils.dart';

part 'base_model.g.dart';

@JsonSerializable()
class BaseModel {
  final DateTime? createdAt;
  final DateTime? updatedAt;

  BaseModel({this.createdAt, this.updatedAt});

  factory BaseModel.fromJson(Map<String, dynamic> json) =>
      _$BaseModelFromJson(json);

  Map<String, dynamic> toJson() => _$BaseModelToJson(this);

  formatCreateAt() => (createdAt!=null)?DateWebUtils.toYYYYMMDDWithTime(createdAt):'-';
  formatUpdatedAt() => (updatedAt!=null)?DateWebUtils.toYYYYMMDDWithTime(updatedAt):'-';
}