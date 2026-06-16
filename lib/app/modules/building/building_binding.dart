import 'package:get/get.dart';
import 'building_controller.dart';

class BuildingBinding implements Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<BuildingController>( () => BuildingController() );
  }

}