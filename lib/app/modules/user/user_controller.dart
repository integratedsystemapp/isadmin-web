import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../data/model/user_model.dart';
import '../common/api_service.dart';
import '../common/show_custom_snackbar.dart';

class UserController extends GetxController {

  static UserController get to {
    if (Get.isRegistered<UserController>()) {
      return Get.find<UserController>();
    } else {
      return Get.put(UserController());
    }
  }

  final selected = <int>{}.obs;
  final userList = <UserModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    // fetchUsers();
  }

  @override
  void dispose() {
    controller.dispose();
    horizontalController.dispose();
    super.dispose();
  }


  void toggleSelection(int index) {

    if (selected.isNotEmpty && selected.first == index) {
      // 선택 토글
      selected.clear();
    } else {
      selected.clear();
      selected.add(index);
    }

    // debugPrint(selected.toList().toString());

  }

  bool isSelected(int index) => selected.contains(index);
  UserModel? getSelected() => (selected.isNotEmpty) ? userList[selected.first] : null;

  final ScrollController controller = ScrollController();
  final ScrollController horizontalController = ScrollController();
  bool sortAscending = true;
  int? sortColumnIndex;
  bool initialized = false;

  Future<void> fetchUsers() async {
    try {
      final response = await ApiService().get('/user/');
      final data = response.data as List<dynamic>;

      // debugPrint(jsonEncode(data), wrapWidth: 1024);

      final users = data.map((e) => UserModel.fromJson(e)).toList();
      userList.assignAll(users);

      // debugPrint('userList:count${userList.length}');
      // debugPrint('userList:${userList.length}');

      // debugPrint(jsonEncode(userList.map((e) => e.toJson()).toList()));

    } catch (e) {
      showCustomSnackbar('에러', '사용자 목록 조회 실패: $e');
      debugPrint('Error fetching users: $e');
    }
  }

  Future<void> approveUser(String userId) async {
    try {
      // 1. api 개발.


      final response = await ApiService().put('/user/approve/$userId', jsonEncode({"user_id": userId}), );

      debugPrint('approveUser response: ${response.statusCode} - ${response.data}');
      if (response.statusCode == 200) {
        showCustomSnackbar('성공', '사용자가 승인 되었습니다.');

        final index = this.userList.indexWhere((e) => e.userId == userId);
        if (index >= 0) {
          /*

          final _user = this.userList[index];
          _user.isApproved = 'Y';
          this.userList[index] = _user;

           */

          this.userList[index].isApproved = (this.userList[index].isApproved == 'Y') ? 'N' : 'Y';
          this.userList.refresh();
        }

      } else if (response.statusCode == 404) {
        showCustomSnackbar('오류', '사용자 정보를 찾을 수 없습니다.');
      } else {
        showCustomSnackbar('오류', '사용자 승인 실패: ${response.statusCode}');
      }
    } on DioException catch (e) {
      // Dio 예외 명확히 처리
      showCustomSnackbar('네트워크 오류', '삭제 실패: ${e.response?.statusCode ?? ''}');
      rethrow;
    } catch (e) {
      showCustomSnackbar('에러', '알 수 없는 오류: $e');
      rethrow;
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      final response = await ApiService().delete('/user/$userId');

      debugPrint('Delete response: ${response.statusCode} - ${response.data}');
      if (response.statusCode == 200) {
        showCustomSnackbar('성공', '사용자 정보가 삭제되었습니다.');
      } else if (response.statusCode == 404) {
        showCustomSnackbar('오류', '사용자 정보를 찾을 수 없습니다.');
      } else {
        showCustomSnackbar('오류', '삭제 실패: ${response.statusCode}');
      }
    } catch (e) {
      showCustomSnackbar('에러', '알 수 없는 오류: $e');
      if (e is DioException) {
        showCustomSnackbar('네트워크 오류', '삭제 실패: ${e.response?.statusCode ?? ''}');
        print(e.response?.data); // 422 detail 메시지 확인
      }
      // showCustomSnackbar('에러', '네트워크 오류: $e');
      rethrow;
    }
  }



}