// import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

import 'base_model.dart';

part 'customer_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class CustomerModel extends BaseModel {

  final String companyCd;
  final String companyName;
  final String? businessRegistrationNo;
  final String? address;
  final String? addressDetail; // 상세주소
  final String? companyPhoneNo;
  final String? ceoName;
  final String? businessTypeCd;
  final String? businessItem;
  final String? managerName;
  final String? managerPosition;
  final String? managerTelNo;
  final String? managerMobileNo;
  final String? managerEmail;
  final String? invoiceIssueDate;
  final int? contractAmount;
  String? eformsignDocId;
  final String isServiceEnabled;

  CustomerModel({
    required this.companyCd,
    required this.companyName,
    this.businessRegistrationNo,
    this.address,
    this.addressDetail,
    this.companyPhoneNo,
    this.ceoName,
    this.businessTypeCd,
    this.businessItem,
    this.managerName,
    this.managerPosition,
    this.managerTelNo,
    this.managerMobileNo,
    this.managerEmail,
    this.invoiceIssueDate,
    this.contractAmount,
    this.eformsignDocId,
    this.isServiceEnabled = 'Y',
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super(createdAt: createdAt, updatedAt: updatedAt);

  factory CustomerModel.fromJson(Map<String, dynamic> json) => _$CustomerModelFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerModelToJson(this);

  formatContractAmount() {
    final f = NumberFormat.decimalPattern('ko_KR');


    if(contractAmount != null) {
      // debugPrint('[debug]contractAmount:${contractAmount}');
      return f.format(contractAmount);
    } else
      return contractAmount ?? '0';
  }

  isValidEformDocId() => (eformsignDocId!=null && eformsignDocId!.isNotEmpty);

  addressInfo() => ('${address??''} ${addressDetail??''}'.length < 2 ) ? '' : '${address??''} ${addressDetail??''}';

}