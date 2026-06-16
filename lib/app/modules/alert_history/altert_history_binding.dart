import 'package:get/get.dart';
import 'altert_history_controller.dart';

class AlertHistoryBinding implements Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<AlertHistoryController>( () => AlertHistoryController() );
  }

}