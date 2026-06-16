import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/scheduler.dart';

enum SnackType { info, success, warning, error }

void showCustomSnackbar(
    String title,
    String message, {
      SnackPosition position = SnackPosition.BOTTOM,
      SnackType type = SnackType.info,
      Duration duration = const Duration(seconds: 1),
      VoidCallback? onAction,
      String? actionText, // e.g. '확인', '복사'
      bool closeCurrent = true, // 기존 스낵바 닫고 새로 표시
      bool isHome = false,
    }) {
  final ctx = Get.context;
  if (ctx == null) return;

  // 타입별 색상 프리셋
  final Color bg;
  switch (type) {
    case SnackType.success:
      bg = const Color(0xFF2E7D32); // green700
      break;
    case SnackType.warning:
      bg = const Color(0xFFF57F17); // amber900
      break;
    case SnackType.error:
      bg = const Color(0xFFB71C1C); // red900
      break;
    case SnackType.info:
    default:
      bg = const Color(0xFF263238); // blueGrey900
  }

  // 안전영역 고려 margin 계산 (Get.snackbar의 margin과 유사)
  EdgeInsets safeMargin = const EdgeInsets.all(16);

  if (position == SnackPosition.TOP) {
    final topInset = MediaQuery.of(ctx).viewPadding.top;
    if (topInset > 0) {
      safeMargin = safeMargin.copyWith(top: safeMargin.top + topInset);
    }
  }

  if (isHome) {
    double safeBottom = 16;
    if (position == SnackPosition.BOTTOM) {
      safeBottom += MediaQuery.of(ctx).viewPadding.bottom;
    }
    const bottomOffset = 80;
    safeMargin = EdgeInsets.fromLTRB(16, 16, 16, safeBottom + bottomOffset);
  }

  final messenger = ScaffoldMessenger.of(ctx);

  // ✅ 기존 스낵바가 있으면 닫고 새로 표시
  if (closeCurrent) {
    messenger.hideCurrentSnackBar();    // 애니메이션으로 숨김
    messenger.removeCurrentSnackBar();  // 즉시 제거(겹침 방지)
    messenger.clearSnackBars();         // 큐에 쌓인 것도 제거(원치 않으면 빼도 됨)
  }

  // TOP은 SnackBar 특성상 정확히 상단 고정이 어려워 margin 트릭 사용
  EdgeInsets finalMargin = safeMargin;
  if (position == SnackPosition.TOP) {
    final size = MediaQuery.of(ctx).size;
    finalMargin = EdgeInsets.fromLTRB(
      safeMargin.left,
      safeMargin.top,
      safeMargin.right,
      size.height - 140,
    );
  }

  // ✅ 닫기/제거 직후 바로 show 하면 타이밍 충돌이 나는 경우가 있어 다음 프레임에 show
  SchedulerBinding.instance.addPostFrameCallback((_) {
    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        margin: finalMargin,
        padding: EdgeInsets.zero,
        duration: duration,
        dismissDirection: DismissDirection.horizontal,
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4)),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.info_outline, color: Colors.white),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      message,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              if (onAction != null && actionText != null) ...[
                const SizedBox(width: 8),
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    minimumSize: const Size(0, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () {
                    messenger.hideCurrentSnackBar(); // 현재 스낵바 닫기
                    onAction();
                  },
                  child: Text(actionText),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  });
}
