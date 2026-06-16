import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

import '../../../core/routes/app_routes.dart';
import '../../../core/values/consts.dart';
import '../../data/model/user_model.dart';
import '../auth/auth_controller.dart';
import '../common/api_service.dart';
import '../common/show_custom_snackbar.dart';

/// 서버 엔드포인트 (환경에 맞게 변경)
// const String kBaseUrl  = "http://127.0.0.1:8000";
// const String kLoginPath = "/user/login";


/// -------------------- Controller --------------------
class LoginViewController extends GetxController {
  // TextEditingController는 컨트롤러에서 생성/정리
  final idCtrl = TextEditingController();
  final pwCtrl = TextEditingController();

  final formKey = GlobalKey<FormState>();

  final loading = false.obs;
  final obscure = true.obs;
  // UI 상태
  final rememberId = false.obs;
  final box = GetStorage(); // main()에서 await GetStorage.init();

  @override
  void onClose() {
    idCtrl.dispose();
    pwCtrl.dispose();
    super.onClose();
  }

  Future<void> login() async {

    debugPrint('login()1');
    if (!(formKey.currentState?.validate() ?? false)) return;
    debugPrint('login()2');

    loading.value = true;
    try {

      final url = '/user/login';
      final Map<String, dynamic> requestBody = {
        "login_id": idCtrl.text.trim(),
        "passwd": pwCtrl.text,
      };
      final response = await ApiService().post(url,requestBody);

      if (response.statusCode == 200) {
        final responseDataMap = response.data as Map<String, dynamic>;
        final ok = responseDataMap['ok'] == true;
        if (ok) {
          //debugPrint('ok===================>');
          //debugPrint('userModel;${responseDataMap['user']}');

          if(rememberId.value) {
            await box.write(LOGIN_ID_KEY, idCtrl.text.trim());
          } else {
            await box.remove(LOGIN_ID_KEY);
          }


          final userModel = UserModel.fromJson(responseDataMap['user']);
          debugPrint('@@@@userModel;${userModel.toJson().toString()}');
          // TODO: 서버 인증 요청 → 액세스 토큰 획득
          await AuthController.to.login(accessToken: 'dummy-token');  // home url 직접입력 접속 제어
          Get.offAllNamed(AppRoutes.HOME, arguments: userModel);

          // final arg = {'userName':userModel.userName, 'companyName':userModel.companyName, 'buildingName':userModel.buildingName};
          // Get.offAllNamed(AppRoutes.HOME, arguments: arg);

          return;
        }
      } else if (response.statusCode == 401) {
        debugPrint('[debug] statusCode:${response.statusCode}');
        showCustomSnackbar('로그인', '등록되지 않은 아이디입니다.');
      } else {
        // 실패 처리 공통
        Get.snackbar(
          '로그인 실패', '아이디 또는 패스워드가 일치하지 않습니다.',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
          margin: const EdgeInsets.all(12),
        );
      }

    } catch (e) {
      Get.snackbar(
        '네트워크 오류', '잠시 후 다시 시도해주세요.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(12),
      );
    } finally {
      loading.value = false;
    }
  }
}

