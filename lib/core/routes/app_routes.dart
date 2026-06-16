

import 'package:flutter/animation.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';

import '../../app/modules/alert_history/altert_history_binding.dart';
import '../../app/modules/alert_history/altert_history_screen.dart';
import '../../app/modules/alert_send_history/altert_send_history_binding.dart';
import '../../app/modules/alert_send_history/altert_send_history_screen.dart';
import '../../app/modules/auth/auth_guard.dart';
import '../../app/modules/building/building_binding.dart';
import '../../app/modules/building/building_screen.dart';
import '../../app/modules/customer/customer_binding.dart';
import '../../app/modules/customer/customer_screen.dart';
import '../../app/modules/dashboard/dashboard_binding.dart';
import '../../app/modules/dashboard/dashboard_screen.dart';
import '../../app/modules/di/di_binding.dart';
import '../../app/modules/di/di_screen.dart';
import '../../app/modules/edge/edge_binding.dart';
import '../../app/modules/edge/edge_screen.dart';
import '../../app/modules/home/home_binding.dart';
import '../../app/modules/home/home_screen.dart';
import '../../app/modules/login/login_binding.dart';
import '../../app/modules/login/login_screen.dart';
import '../../app/modules/splash/splash_screen.dart';
import '../../app/modules/user/user_binding.dart';
import '../../app/modules/user/user_screen.dart';


abstract class AppRoutes {

  static const INITIAL = '/';
  static const SPLASH = '/';
  static const LOGIN = '/login';
  static const DASHBOARD = '/dashboard';
  static const HOME = '/home';
  static const CUSTOMER = '/home/customer';
  static const ALERT_HISTORY = '/home/alert_history';
  static const ALERT_SEND_HISTORY = '/home/alert_send_history';
  static const BUILDING = '/home/building';
  static const EDGE = '/home/edge';
  static const DI = '/home/di';
  static const USER = '/home/user';

  static final pages = [
    GetPage(
        name: SPLASH,
        page: () => SplashScreen(),
        bindings: []
    ),
    GetPage(
      name: LOGIN,
      page: () => LoginView(),
      bindings: [LoginViewBinding()],
      middlewares: [NoAuthGuard()], // ***
      transition: Transition.fadeIn,           // ← 슬라이드 대신 페이드
      curve: Curves.easeOutCubic,
      transitionDuration: const Duration(milliseconds: 250),
    ),
    GetPage(
      name: DASHBOARD,
      page: () => DashboardScreen(),
      bindings: [DashboardBinding()],
      middlewares: [AuthGuard()], // ***
    ),
    GetPage(
        name: HOME,
        page: () => HomeScreen(),
        bindings: [HomeBinding()],
        middlewares: [AuthGuard()], // ***
    ),
    GetPage(
        name: CUSTOMER,
        page: () => CustomerScreen(),
        bindings: [CustomerBinding()]
    ),
    GetPage(
        name: ALERT_HISTORY,
        page: () => AlertHistoryScreen(),
        bindings: [AlertHistoryBinding()]
    ),
    GetPage(
        name: ALERT_SEND_HISTORY,
        page: () => AlertSendHistoryScreen(),
        bindings: [AlertSendHistoryBinding()]
    ),
    GetPage(
        name: BUILDING,
        page: () => BuildingScreen(),
        bindings: [BuildingBinding()]
    ),
    GetPage(
        name: EDGE,
        page: () => EdgeScreen(),
        bindings: [EdgeBinding()]
    ),
    GetPage(
        name: DI,
        page: () => DiScreen(),
        bindings: [DiBinding()]
    ),
    GetPage(
        name: USER,
        page: () => UserScreen(),
        bindings: [UserBinding()]
    ),


  ];
}