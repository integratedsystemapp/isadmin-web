import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/routes/app_routes.dart';
import '../../../core/values/consts.dart';
import '../../data/model/user_model.dart';
import '../alert_history/altert_history_controller.dart';
import '../alert_send_history/altert_send_history_controller.dart';
import '../auth/auth_controller.dart';
import '../building/building_controller.dart';
import '../customer/customer_controller.dart';
import '../dashboard/dashboard_controller.dart';
import '../di/di_controller.dart';
import '../edge/edge_controller.dart';
import '../user/user_controller.dart';
import 'home_controller.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

// 프로젝트의 HomeController를 package 경로로 import 해주세요.
import 'package:HGPcWeb/app/modules/home/home_controller.dart';

// 필요 시 사용자의 AuthController/AppRoutes를 import 하세요.
// import 'package:HGPcWeb/app/modules/auth/auth_controller.dart';
// import 'package:HGPcWeb/core/routes/app_routes.dart';

// ===== 사이드바/헤더 색상 (스크린샷 톤) =====
const _kSidebarBg = Color(0xFF2F3439); // 사이드바 배경
const _kTextStrong = Color(0xFFF4F6F7); // 타이틀/강조 텍스트
const _kText = Color(0xFFD0D6DC); // 일반 텍스트/아이콘
const _kActiveBg = Color(0xFF00619D); // 선택된 pill 배경
const _kActiveFg = Color(0xFF15181B); // 선택 텍스트/아이콘
const _kHoverTint = Color(0x1FFFFFFF); // hover 틴트

const HEADER_COLOR = Color(0xFF2B3036); // 상단 헤더 배경
const SIDEBAR_COLOR = _kSidebarBg; // 사이드바 배경

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // arguments에 유저 정보가 올 수 있는 경우 처리 (없으면 디폴트)
    final args = Get.arguments;
    final userModel = (args is UserModel) ? args : null as UserModel?;
    final String userName = userModel?.userName ?? '';
    final String company = userModel?.companyName ?? '';
    final String building = userModel?.buildingName ?? '';

    return Scaffold(
      backgroundColor: const Color(0xFF1E2226),
      body: Column(
        children: [
          // 상단 헤더
          Container(
            color: HEADER_COLOR,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "$userName / $company / $building",
                  style: const TextStyle(color: Colors.white),
                ),
                GestureDetector(
                  onTapDown: (_) => controller.down(),
                  onTapUp: (_) => controller.up(),
                  onTapCancel: controller.up,
                  onTap: () {
                    // 실제 로그아웃 로직 연결
                    AuthController.to.logout();
                    Get.offAllNamed(AppRoutes.LOGIN);
                  },
                  child: Obx(
                    () => AnimatedScale(
                      scale: controller.scale.value,
                      duration: const Duration(milliseconds: 140),
                      curve: Curves.easeOut,
                      child: const Row(
                        children: [
                          Text("Logout", style: TextStyle(color: Colors.white)),
                          SizedBox(width: 6),
                          Icon(Icons.logout, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 본문: 좌측 사이드바 + 우측 컨텐츠
          Expanded(
            child: Row(
              children: [
                // ===== 사이드바 =====
                Container(
                  width: 240,
                  color: SIDEBAR_COLOR,
                  child: SafeArea(
                    bottom: false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Integrated System',
                                style: TextStyle(
                                  color: _kTextStrong,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              SizedBox(height: 4),
                              // Text(
                              //   '대시보드',
                              //   style: TextStyle(
                              //     color: _kText,
                              //     fontSize: 14,
                              //     fontWeight: FontWeight.w600,
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                        const Divider(height: 1, color: Colors.white12),

                        // 메뉴 리스트 (항목 단위만 Obx 사용)
                        // ===== 사이드바 리스트 교체 블록 시작 =====
                        Expanded(
                          child: ListView.separated(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            itemCount: controller.menuItems.length,
                            separatorBuilder:
                                (_, __) => const SizedBox(height: 6),
                            itemBuilder: (context, index) {
                              final item = controller.menuItems[index];

                              // 항목 단위로만 Obx 사용
                              return Obx(() {
                                final isSelected =
                                    controller.selectedIndex.value == index;

                                return _SidebarItem(
                                  iconData: controller.getIcon(item['icon']!),
                                  title: item['title']!,
                                  isSelected: isSelected,
                                  onTap: () async {
                                    // 이미 선택된 메뉴면 리턴 (중복 호출 방지)
                                    if (controller.selectedIndex.value == index)
                                      return;

                                    controller.selectedIndex.value = index;
                                    // debugPrint('selectedIndex: $index');

                                    switch (index) {
                                      case 0:
                                        debugPrint('홈 ---------------->');
                                        final dasgboardController =
                                            DashboardController.to;
                                        dasgboardController.getInfo();
                                        break;

                                      case 1:
                                        debugPrint('고객사관리 ---------------->');
                                        final customerController =
                                            CustomerController.to;
                                        customerController.fetchCustomers();
                                        break;

                                      case 2:
                                        debugPrint('빌딩관리 ---------------->');
                                        final buildingController =
                                            BuildingController.to;
                                        buildingController.fetchBuildings();
                                        break;

                                      case 3:
                                        debugPrint('Edge 관리 ---------------->');
                                        final edgeController =
                                            EdgeController.to;
                                        edgeController.fetchEdges();
                                        break;

                                      // case 4:
                                      //   debugPrint('DigitalInput 관리 ---------------->');
                                      //   final diController = DiController.to;
                                      //   diController.fetchDis();
                                      //   break;

                                      case 4:
                                        debugPrint('사용자 관리 ---------------->');
                                        final userController =
                                            UserController.to;
                                        userController.fetchUsers();
                                        break;

                                      case 5:
                                        debugPrint('경보 히스토리 ---------------->');
                                        final alertHistoryController =
                                            AlertHistoryController.to;
                                        // alertHistoryController.fetchAlertHistory(); // 필요 시
                                        alertHistoryController.fetchNext(
                                          reset: true,
                                        );
                                        break;

                                      case 6:
                                        debugPrint(
                                          '발송 발송 이력 ---------------->',
                                        );
                                        final alertSendHistoryController =
                                            AlertSendHistoryController.to;
                                        // alertSendHistoryController.fetchAlertSendHistory(); // 필요 시
                                        alertSendHistoryController.fetchNext(
                                          reset: true,
                                        );
                                        break;

                                      default:
                                        debugPrint('oob'); // out of bound
                                        break;
                                    }
                                  },
                                );
                              });
                            },
                          ),
                        ),

                        const Divider(height: 1, color: Colors.white12),

                        // // 하단 설정 (옵션)
                        // Padding(
                        //   padding: const EdgeInsets.fromLTRB(12, 10, 12, 14),
                        //   child: _SidebarItem(
                        //     iconData: Icons.settings,
                        //     title: '설정',
                        //     isSelected: false,
                        //     compact: true,
                        //     onTap: () {
                        //       Get.snackbar('설정', '설정 화면 예시',
                        //           snackPosition: SnackPosition.BOTTOM);
                        //     },
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
                // ===== 사이드바 끝 =====

                // ===== 오른쪽 컨텐츠 =====
                Expanded(
                  child: Container(
                    color: Colors.white,
                    // color: const Color(0xFF22272B),
                    child: Obx(
                      () => IndexedStack(
                        index: controller.selectedIndex.value,
                        children: controller.screens,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 사이드바 항목 (노란 pill 선택 스타일)
// ///
// class _SidebarItem extends StatefulWidget {
//   final IconData iconData;
//   final String title;
//   final bool isSelected;
//   final VoidCallback onTap;
//   final bool compact;
//
//   const _SidebarItem({
//     required this.iconData,
//     required this.title,
//     required this.isSelected,
//     required this.onTap,
//     this.compact = false,
//   });
//
//   @override
//   State<_SidebarItem> createState() => _SidebarItemState();
// }
//
// class _SidebarItemState extends State<_SidebarItem> {
//   bool _hover = false;
//
//   @override
//   Widget build(BuildContext context) {
//     final bg = widget.isSelected
//         ? _kActiveBg
//         : (_hover ? _kHoverTint : Colors.transparent);
//     final fg = widget.isSelected ? _kActiveFg : _kText;
//
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 12),
//       child: Material( // InkWell 잉크 효과를 위한 Material
//         color: Colors.transparent,
//         child: MouseRegion(
//           cursor: SystemMouseCursors.click,
//           onEnter: (_) => setState(() => _hover = true),
//           onExit:  (_) => setState(() => _hover = false),
//           child: InkWell(
//             onTap: widget.onTap,
//             borderRadius: BorderRadius.circular(12),
//             // onHover로 MouseRegion 없이도 가능 (원하면 아래 사용)
//             // onHover: (v) => setState(() => _hover = v),
//             child: AnimatedContainer(
//               duration: const Duration(milliseconds: 160),
//               width: double.infinity, // pill 전체를 클릭영역으로
//               padding: EdgeInsets.symmetric(
//                 horizontal: 12,
//                 vertical: widget.compact ? 8 : 12,
//               ),
//               decoration: BoxDecoration(
//                 color: bg,
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Row(
//                 children: [
//                   Icon(widget.iconData, size: 20, color: fg),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: Text(
//                       widget.title,
//                       style: TextStyle(
//                         color: fg,
//                         fontSize: 15,
//                         fontWeight: widget.isSelected
//                             ? FontWeight.w800
//                             : FontWeight.w600,
//                       ),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                   if (widget.isSelected) ...[
//                     const SizedBox(width: 6),
//                     const Icon(Icons.chevron_right_rounded,
//                         size: 20, color: _kActiveFg),
//                   ],
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

/// 색상 상수 (원하는 값으로 조절하세요)
/// 사이드바 항목 (노란 pill 선택 스타일)
class _SidebarItem extends StatefulWidget {
  final IconData iconData;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;
  final bool compact;

  const _SidebarItem({
    required this.iconData,
    required this.title,
    required this.isSelected,
    required this.onTap,
    this.compact = false,
  });

  @override
  State<_SidebarItem> createState() => _SidebarItemState();
}

class _SidebarItemState extends State<_SidebarItem> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final Color bg =
        widget.isSelected
            ? _kActiveBg
            : (_hover ? _kHoverTint : Colors.transparent);
    final Color fg = widget.isSelected ? _kActiveFg : _kText;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Material(
        color: Colors.transparent, // InkWell 리플 표시용
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(12),
          onHover: (v) => setState(() => _hover = v),
          child: Ink(
            // Ink에 배경을 그리면 리플이 자연스럽게 보임
            width: double.infinity, // pill 전체를 탭 가능 영역으로
            padding: EdgeInsets.symmetric(
              horizontal: 12,
              vertical: widget.compact ? 8 : 12,
            ),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(widget.iconData, size: 20, color: fg),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      color: fg,
                      fontSize: 15,
                      fontWeight:
                          widget.isSelected ? FontWeight.w800 : FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (widget.isSelected) ...[
                  const SizedBox(width: 6),
                  const Icon(
                    Icons.chevron_right_rounded,
                    size: 20,
                    color: _kActiveFg,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
