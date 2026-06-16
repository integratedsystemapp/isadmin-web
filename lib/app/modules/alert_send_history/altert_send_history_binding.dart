import 'package:get/get.dart';
import 'altert_send_history_controller.dart';

class AlertSendHistoryBinding implements Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<AlertSendHistoryController>( () => AlertSendHistoryController() );
  }

}