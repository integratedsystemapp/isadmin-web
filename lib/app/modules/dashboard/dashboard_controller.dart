import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../common/api_service.dart';
import '../common/show_custom_snackbar.dart';

class DashboardController extends GetxController {

  static DashboardController get to {
    if (Get.isRegistered<DashboardController>()) {
      return Get.find<DashboardController>();
    } else {
      return Get.put(DashboardController());
    }
  }

  final dashboardMap = <String, dynamic>{}.obs;
  final isLoading = false.obs;

  // 계산/기본값 포함 getter (UI에서 null 신경 안 쓰게)
  int get customerCount        => (dashboardMap['customer_count'] ?? 0) as int;
  int get buildingCount        => (dashboardMap['building_count'] ?? 0) as int;
  int get edgeCount            => (dashboardMap['edge_count'] ?? 0) as int;
  int get todayAlertCount      => (dashboardMap['today_alert_count'] ?? 0) as int;
  int get unconfirmedAlertCount=> (dashboardMap['alert_unconfirmed_count'] ?? 0) as int;
  
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

  }

  getInfo() async {
    try {
      isLoading.value = true;
      final response = await ApiService().get('/dashboard');
      final data = response.data as Map<String, dynamic>;
      debugPrint('data:${data.toString()}');

      dashboardMap.value = data['as_dict'];

      debugPrint('dashboardMap:${dashboardMap.value.keys}');

      isLoading.value = false;
    } catch (e) {
      showCustomSnackbar('에러', '대시보드 정보 조회 에러: $e');
      debugPrint('Error fetching dashboard info: $e');
    }

  }

}