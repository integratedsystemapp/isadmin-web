// dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dashboard_controller.dart';

class DashboardScreen extends GetView<DashboardController> {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return FocusTraversalGroup(
            // 포커스 탐색 안정화
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: constraints.maxWidth, // ✅ 가로 제약 추가
                  //minHeight: constraints.maxHeight, // 기존 유지
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // AspectRatio(
                      //   aspectRatio: 16 / 6,
                      //   child: ClipRRect(
                      //     borderRadius: BorderRadius.circular(8),
                      //     child: Image.asset(
                      //       'assets/images/dashboard_banner.png',
                      //       fit: BoxFit.cover,
                      //       alignment: Alignment(0, -0.6),
                      //       //alignment: Alignment.topCenter,
                      //     ),
                      //   ),
                      // ),
                      SizedBox(
                        height: 700, // ✅ 높이 직접 제어
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            'assets/images/dashboard_banner.png',
                            fit: BoxFit.cover,
                            alignment: Alignment.topCenter,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // 카드 그리드
                      LayoutBuilder(
                        builder: (context, inner) {
                          final maxW = inner.maxWidth;
                          const gap = 16.0;

                          int columns;
                          if (maxW >= 1400)
                            columns = 5;
                          else if (maxW >= 1100)
                            columns = 4;
                          else if (maxW >= 820)
                            columns = 3;
                          else if (maxW >= 560)
                            columns = 2;
                          else
                            columns = 1;

                          final cardWidth =
                              (maxW - gap * (columns - 1)) / columns;
                          final scale = (cardWidth / 220).clamp(0.9, 1.4);

                          return Wrap(
                            spacing: gap,
                            runSpacing: gap,
                            children: [
                              _StatCardReactive(
                                width: cardWidth,
                                scale: scale,
                                title: 'Customer',
                                valueBuilder:
                                    () => '${controller.customerCount}개사',
                              ),
                              _StatCardReactive(
                                width: cardWidth,
                                scale: scale,
                                title: 'Building',
                                valueBuilder:
                                    () => '${controller.buildingCount}개',
                              ),
                              _StatCardReactive(
                                width: cardWidth,
                                scale: scale,
                                title: 'EdgeAgent Count',
                                valueBuilder: () => '${controller.edgeCount}개',
                              ),
                              _StatCardReactive(
                                width: cardWidth,
                                scale: scale,
                                title: 'Today Alert Count',
                                valueBuilder:
                                    () => '${controller.todayAlertCount}개',
                              ),
                              _StatCardReactive(
                                width: cardWidth,
                                scale: scale,
                                title: 'Open Alert Count',
                                valueBuilder:
                                    () =>
                                        '${controller.unconfirmedAlertCount}개',
                              ),
                            ],
                          );
                        },
                      ),

                      const SizedBox(height: 16),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// 값만 Obx로 감싸서 재빌드 최소화
class _StatCardReactive extends StatelessWidget {
  final String title;
  final String Function() valueBuilder;
  final double width;
  final double scale;
  const _StatCardReactive({
    required this.title,
    required this.valueBuilder,
    required this.width,
    required this.scale,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Obx(
        () => _StatCard(title: title, value: valueBuilder(), scale: scale),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final double scale;
  const _StatCard({
    required this.title,
    required this.value,
    this.scale = 1.0,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final pad = 18 * scale.clamp(0.9, 1.4);
    final iconSize = 28 * scale;
    final titleSize = 18 * scale;
    final valueSize = 22 * scale;

    return Semantics(
      // 시맨틱 컨테이너 지정(선택)
      container: true,
      child: Container(
        padding: EdgeInsets.all(pad),
        decoration: BoxDecoration(
          color: const Color(0xFF00619D),
          borderRadius: BorderRadius.circular(12 * scale),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.apartment_rounded, size: iconSize, color: Colors.white),
            SizedBox(height: 12 * scale),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: titleSize,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 18 * scale),
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: valueSize,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
