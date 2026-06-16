import 'package:get/get.dart';
import 'customer_controller.dart';

class CustomerBinding implements Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<CustomerController>( () => CustomerController() );
  }

}