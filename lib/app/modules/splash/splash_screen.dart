// lib/app/modules/splash/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/routes/app_routes.dart';
import '../auth/auth_controller.dart';

/// 가볍고 안전한 스플래시:
/// - 첫 프레임이 그려진 뒤에 분기(addPostFrameCallback)
/// - 중복 네비게이션 가드(_navigated)
/// - 위젯 dispose 이후 네비게이션 방지(mounted 체크)
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _navigated = false;

  @override
  void initState() {
    super.initState();

    // 첫 프레임 이후에 라우팅을 수행하여 레이아웃/포커스 충돌 방지
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted || _navigated) return;

      // 스토리지/컨트롤러 초기화 타이밍 보정(너무 빠른 접근 방지)
      await Future<void>.delayed(const Duration(milliseconds: 50));

      if (!mounted || _navigated) return;

      final bool isLoggedIn = AuthController.to.isLoggedIn;

      _navigated = true; // 중복 차단
      if (!mounted) return;


      if (isLoggedIn) {
        // 이미 로그인 → 홈으로
        Get.offAllNamed(AppRoutes.HOME);
      } else {
        // 비로그인 → 로그인으로
        Get.offAllNamed(AppRoutes.LOGIN);
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    // 뒤로가기 방지(웹/모바일 공통) — 스플래시 중 뒤로가기로 빠지는 걸 회피
    return WillPopScope(
      onWillPop: () async => false,
      child: const Scaffold(
        body: Center(
          child: SizedBox(
            width: 36,
            height: 36,
            child: CircularProgressIndicator(strokeWidth: 3),
          ),
        ),
      ),
    );
  }
}
