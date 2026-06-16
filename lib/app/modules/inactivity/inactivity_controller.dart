import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:html' as html;
import '../../../core/routes/app_routes.dart';
import '../auth/auth_controller.dart';

class InactivityController extends GetxController {

  // 60분 무활동 시 로그오프
  final Duration timeout = const Duration(minutes: 60);

  // 저장 키
  static const _boxName = 'inactivity_box';
  static const _lastActivityKey = 'last_activity_at';   // ISO8601(UTC) 문자열
  static const _lastLoginKey    = 'last_login_at';      // 필요 시 절대 만료에도 활용

  final _box = GetStorage(_boxName);

  DateTime lastActivity = DateTime.now().toUtc();
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();

    // 저장소 초기화 보장(이미 init돼 있으면 즉시 반환)
    if (!GetStorage().hasData(_boxName)) {
      // no-op; 상위에서 GetStorage.init() 호출되어 있다면 필요 없음
    }

    // 저장된 마지막 활동시각 로드 (없으면 지금으로 저장)
    final saved = _box.read(_lastActivityKey);
    if (saved is String) {
      lastActivity = DateTime.tryParse(saved)?.toUtc() ?? DateTime.now().toUtc();
    } else {
      _persistNow();
    }

    // 앱 시작 시 즉시 한 번 검사 (브라우저 재시작/재부팅 케이스)
    _enforceIdleNow();

    // 10초마다 검사
    _startTicker();

    // 웹 가시성 변화 감지: 탭 재진입 시 즉시 검사
    if (kIsWeb) {
      _attachVisibilityListener();
      _attachBeforeUnloadSaver();
    }
  }

  void _startTicker() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 10), (_) => _enforceIdleNow());
  }

  // 화면에서 사용자 행동이 들어오면 호출
  void touch() {
    lastActivity = DateTime.now().toUtc();
    _persistNow();
  }

  // 저장
  void _persistNow() {
    _box.write(_lastActivityKey, lastActivity.toIso8601String());
  }

  // 지금 시점에서 무활동 만료인지 검사
  void _enforceIdleNow() {
    final nowUtc = DateTime.now().toUtc();
    final savedStr = _box.read(_lastActivityKey);
    final savedUtc = (savedStr is String)
        ? (DateTime.tryParse(savedStr)?.toUtc() ?? lastActivity)
        : lastActivity;

    final diff = nowUtc.difference(savedUtc);
    if (diff >= timeout) {
      _logout(); // 조건 만족 시 즉시 로그오프
    }
  }

  // 실제 로그오프
  void _logout() {
    if (_timer?.isActive ?? false) _timer?.cancel();

    debugPrint('##### [Inactivity] 자동 로그오프 (무활동 ${timeout.inMinutes}분) #####');

    // 토큰/세션 정리
    AuthController.to.logout();

    // 라우팅: 스택 제거 후 로그인 화면
    if (Get.key.currentState?.canPop() ?? false) {
      Get.offAllNamed(AppRoutes.LOGIN);
    } else {
      Get.offAllNamed(AppRoutes.LOGIN);
    }
  }

  // 웹 전용: 탭이 다시 보여질 때 즉시 검사
  void _attachVisibilityListener() {
    if (!kIsWeb) return; // 안전 가드

    html.document.onVisibilityChange.listen((_) {
      if (html.document.visibilityState == 'visible') {
        _enforceIdleNow();
      }
    });

    html.window.onBeforeUnload.listen((_) {
      _persistNow();
    });
  }

  // 간단/안전한 대안: WidgetsBindingObserver로 포커스 복귀 시 검사
  // (웹에서도 대체로 동작함)
  @override
  void onReady() {
    super.onReady();
    // 앱 프레임 다시 그려질 때마다 가끔 검사
    WidgetsBinding.instance.addPostFrameCallback((_) => _enforceIdleNow());
  }

  // 웹 전용: 브라우저를 닫거나 새로고침 직전에 저장(마지막 활동시각 보존)
  void _attachBeforeUnloadSaver() {
    // ignore: avoid_web_libraries_in_flutter
    // ignore: undefined_prefixed_name
    // 위의 visibilityListener와 동일 이슈: 간결화를 위해 아래 방식 사용
    // 웹에서만 동작하도록 kIsWeb으로 가드했으니, 여기선 최소한 저장만 보장
    _persistNow();
  }

  @override
  void onClose() {
    _timer?.cancel();
    _persistNow();
    super.onClose();
  }
}
