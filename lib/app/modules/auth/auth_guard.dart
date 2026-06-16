// auth_guard.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/routes/app_routes.dart';
import 'auth_controller.dart';

/// 로그인 필요 라우트용
class AuthGuard extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final authed = AuthController.to.isLoggedIn;
    return authed ? null : const RouteSettings(name: AppRoutes.LOGIN);
  }

  @override
  int? get priority => 1; // 먼저 평가
}

/// 로그인 페이지엔 이미 로그인된 사용자가 못 들어오게
class NoAuthGuard extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final authed = AuthController.to.isLoggedIn;
    return authed ? const RouteSettings(name: AppRoutes.HOME) : null;
  }
}
