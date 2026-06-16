
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// import 'package:app_tracking_transparency/app_tracking_transparency.dart';

class AppController extends GetxService {

  static AppController get to => (Get.isRegistered<AppController>())?Get.find():Get.put(AppController());

  RxString envInfo = ''.obs;  // azure_web_deploy.sh >> --dart-define=ENV=prod
  RxBool isProd = false.obs;  // Azure Static Web App 여부 확인. build 환경변수 정보 체크

  @override
  void onInit() async {
    const String envFlag = String.fromEnvironment('ENV', defaultValue: 'dev');
    this.envInfo.value = envFlag;
    debugPrint('env:${envFlag}');
    this.isProd.value = (envFlag == "prod") ? true:false;
    super.onInit();
  }
}