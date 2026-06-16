import 'package:get/get.dart';
import 'di_controller.dart';

class DiBinding implements Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<DiController>( () => DiController() );
  }

}