import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/modules/auth/auth_controller.dart';
import 'app/modules/common/app_controller.dart';
import 'app/modules/inactivity/inactivity_controller.dart';
import 'app/modules/inactivity/inactivity_watcher.dart';
import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  Get.put(AppController(), permanent: true);
  Get.put(AuthController(), permanent: true);
  // ✅ 이걸 runApp 전에
  Get.put(InactivityController(), permanent: true);

  // await GetStorage.init();

  // debugPrint 를 덮어써서 특정 로그를 무시: DataTable2
  debugPrint = (String? message, {int? wrapWidth}) {
    if (message != null && message.startsWith('DataTable2 built:')) {
      return; // 무시
    }
    debugPrintSynchronously(message, wrapWidth: wrapWidth);
  };

  runApp(
    InactivityWatcher(child:
      GetMaterialApp(
        debugShowCheckedModeBanner: false,
        smartManagement: SmartManagement.keepFactory,
        navigatorKey: Get.key,  // global build context
        title: 'IS IoT Platform',
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.light,
        // home: ScrollableDataTableExample(),

        // initialRoute: Routes.CUSTOMER,
        initialRoute: AppRoutes.SPLASH,
        // initialRoute: AppRoutes.LOGIN,
        // initialRoute: AppRoutes.HOME,

        // home: Scaffold(
        //   backgroundColor: const Color(0xFF1B533F),
        //   body: SafeArea(child: WordSwiperBody()),
        // ),

        // initialRoute: Routes.PUBLISHER_SELECT,
        // initialRoute: Routes.QUIZ,
        getPages: AppRoutes.pages,

      )
    )
  );
}

