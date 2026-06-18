import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/model/customer_model.dart';
import '../../../data/model/user_model.dart';
import '../../common/api_service.dart';
import '../../common/show_custom_snackbar.dart';

class UserEditController extends GetxController {
  final isLocalAdmin = true.obs;
  final isReceiveAppAlert = true.obs;
  final isReceiveKakaoAlert = true.obs;
  final isReceiveSms = true.obs;
  final isReceiveTts = true.obs;
  final isApproved = true.obs;

  final Map<String, TextEditingController> controllers = {
    'userId': TextEditingController(),
    'buildingCd': TextEditingController(),
    'userName': TextEditingController(),
    'mobilePhoneNo': TextEditingController(),
    'companyName': TextEditingController(),
    'department': TextEditingController(),
    'position': TextEditingController(),
  };

  void initFields(UserModel model) {
    controllers['userId']?.text = model.userId;
    controllers['buildingCd']?.text = model.buildingCd;
    controllers['userName']?.text = model.userName ?? '';
    controllers['mobilePhoneNo']?.text = model.mobilePhoneNo ?? '';
    controllers['companyName']?.text = model.companyName ?? '';
    controllers['department']?.text = model.department ?? '';
    controllers['position']?.text = model.position ?? '';
    isLocalAdmin.value = model.isLocalAdmin == 'Y';
    isReceiveAppAlert.value = model.isReceiveAppAlert == 'Y';
    isReceiveKakaoAlert.value = model.isReceiveKakaoAlert == 'Y';
    isReceiveSms.value = model.isReceiveSms == 'Y';
    isReceiveTts.value = model.isReceiveTts == 'Y';
    isApproved.value = model.isApproved == 'Y';
  }

  UserModel collectModel() {
    return UserModel(
      userId: controllers['userId']!.text,
      buildingCd: controllers['buildingCd']!.text,
      userName: controllers['userName']?.text,
      mobilePhoneNo: controllers['mobilePhoneNo']?.text,
      companyName: controllers['companyName']?.text,
      department: controllers['department']?.text,
      position: controllers['position']?.text,
      isLocalAdmin: (this.isLocalAdmin.value) ? 'Y' : 'N',
      isReceiveAppAlert: (this.isReceiveAppAlert.value) ? 'Y' : 'N',
      isReceiveKakaoAlert: (this.isReceiveKakaoAlert.value) ? 'Y' : 'N',
      isReceiveSms: (this.isReceiveSms.value) ? 'Y' : 'N',
      isReceiveTts: (this.isReceiveTts.value) ? 'Y' : 'N',
      isApproved: (this.isApproved.value) ? 'Y' : 'N',
    );
  }

  @override
  void onClose() {
    for (final controller in controllers.values) {
      controller.dispose();
    }
    super.onClose();
  }

  Future<UserModel?> updateUser() async {
    final updatedUser = collectModel(); // 폼에서 데이터 수집
    UserModel? _newUserModel;

    debugPrint('updateCustomer:${updatedUser.toJson().toString()}');
    try {
      final response = await ApiService().put(
        '/user/${updatedUser.userId}', // URL에 companyCd 포함
        updatedUser.toJson(), // JSON 바디
      );

      debugPrint('--->');
      debugPrint(response.toString());
      debugPrint('--->');

      if (response.statusCode == 200) {
        // showCustomSnackbar('성공', '고객 정보가 수정되었습니다.');
        _newUserModel = UserModel.fromJson(
          response.data as Map<String, dynamic>,
        );
      } else {
        // showCustomSnackbar('오류', '수정 실패: ${response.statusCode}');
      }
      return _newUserModel;
    } catch (e) {
      debugPrint('Error updating user: $e');
      // showCustomSnackbar('에러', '네트워크 오류: $e');
      rethrow;
    }
  }
}
