import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'inactivity_controller.dart';

class InactivityWatcher extends StatelessWidget {
  final Widget child;
  const InactivityWatcher({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // main()에서 이미 Get.put(InactivityController()) 했으므로 바로 find
    final inactivity = Get.find<InactivityController>();

    return Listener(
      behavior: HitTestBehavior.translucent,          // ✅ 빈 공간도 이벤트 감지
      onPointerDown: (_) => inactivity.touch(),
      onPointerMove: (_) => inactivity.touch(),
      onPointerHover: (_) => inactivity.touch(),
      child: Focus(
        autofocus: true,                              // ✅ 키보드 입력 감지
        onKeyEvent: (_, __) {
          inactivity.touch();
          return KeyEventResult.ignored;
        },
        child: child,
      ),
    );
  }
}
