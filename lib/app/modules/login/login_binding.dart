import 'package:get/get.dart';
import 'login_controller.dart';

class LoginViewBinding implements Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<LoginViewController>( () => LoginViewController() );
  }

}