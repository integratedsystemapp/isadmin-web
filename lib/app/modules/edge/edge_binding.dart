import 'package:get/get.dart';
import 'edge_controller.dart';

class EdgeBinding implements Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<EdgeController>( () => EdgeController() );
  }

}