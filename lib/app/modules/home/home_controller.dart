import 'package:get/get.dart';
import 'package:flutter/material.dart';  // ✅ 이게 있어야 IconData, Icons, Widget 사용 가능

import '../alert_history/altert_history_screen.dart';
import '../alert_send_history/altert_send_history_screen.dart';
import '../building/building_screen.dart';
import '../customer/customer_screen.dart';
import '../dashboard/dashboard_controller.dart';
import '../dashboard/dashboard_screen.dart';
import '../di/di_screen.dart';
import '../edge/edge_screen.dart';
import '../user/user_screen.dart';

class HomeController extends GetxController {

  static HomeController get to {
    if (Get.isRegistered<HomeController>()) {
      return Get.find<HomeController>();
    } else {
      return Get.put(HomeController());
    }
  }
  // 로그아웃 애니메이션
  final scale = 1.0.obs;
  void down() => scale.value = 0.9;
  void up() => scale.value = 1.0;

  // 선택된 메뉴 index
  RxInt selectedIndex = 0.obs;

  // 고정 메뉴 목록 (observable 아님)
  final List<Map<String, String>> menuItems = [
    {'icon': 'home', 'title': '대시보드'},
    {'icon': 'customer', 'title': '고객사 관리'},
    {'icon': 'building_mgmt', 'title': '빌딩 관리'},
    {'icon': 'edge_mgmt', 'title': 'Edge 관리'},
    // {'icon': 'di_mgmt', 'title': 'Digital Input 관리'},
    {'icon': 'user_mgmt', 'title': '사용자 관리'},
    {'icon': 'alarm_history', 'title': '경보 히스토리'},
    {'icon': 'alarm_send_history', 'title': '경보 발송 히스토리'},
  ];

  // 왼쪽 메뉴 선택 시 마다 변화하는 위젯 표현
  IconData getIcon(String name) {
    switch (name) {
      case 'home':
        return Icons.dashboard;
      case 'customer':
        return Icons.business;
      case 'building_mgmt':
        return Icons.location_city;
      case 'edge_mgmt':
        return Icons.router;
      // case 'di_mgmt':
      //   return Icons.input;
      case 'user_mgmt':
        return Icons.people;
      case 'alarm_history':
        return Icons.warning_amber;
      case 'alarm_send_history':
        return Icons.send;
      default:
        return Icons.help_outline;
    }
  }

  /*
  왼쪽 메뉴 선택에 따라서 bodu에 보여지는 위젯
   */
  final List<Widget> screens = [
    // Center(child: Center(child:Text('요건 필요!!', style: TextStyle(fontSize: 20),))),
    DashboardScreen(),
    // Center(child: Text('고객 관리')),
    CustomerScreen(),
    // Center(child: Text('빌딩 관리')),
    BuildingScreen(),
    // Center(child: Text('Edge 관리')),
    EdgeScreen(),
    // Center(child: Text('Digital Input 관리')),
    // DiScreen(),
    // Center(child: Text('사용자 관리')),
    UserScreen(),
    // Center(child: Text('경보 히스토리')),
    AlertHistoryScreen(),
    // Center(child: Text('경보 발송 히스토리')),
    AlertSendHistoryScreen()
  ];


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    DashboardController.to.getInfo();
  }
}

