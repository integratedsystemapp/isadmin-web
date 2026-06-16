import 'package:get/get.dart';
import '../dashboard/dashboard_controller.dart';
import 'home_controller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<HomeController>( () => HomeController() );
    Get.lazyPut<DashboardController>(() => DashboardController(), fenix: true);
  }

}