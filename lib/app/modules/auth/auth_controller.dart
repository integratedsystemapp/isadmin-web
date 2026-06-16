// auth_controller.dart
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
// (선택) import 'package:jwt_decoder/jwt_decoder.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find<AuthController>();

  final _box = GetStorage();
  final token = RxnString(); // null = 미인증

  bool get isLoggedIn {
    final t = token.value;
    if (t == null || t.isEmpty) return false;
    // (선택) JWT 만료 체크
    // return !JwtDecoder.isExpired(t);
    return true;
  }

  @override
  void onInit() {
    super.onInit();
    token.value = _box.read<String>('auth_token');
  }

  Future<void> login({required String accessToken}) async {
    // TODO: 서버에서 받은 토큰(or 세션 쿠키 확인) 설정
    token.value = accessToken;
    await _box.write('auth_token', accessToken);
  }

  Future<void> logout() async {
    token.value = null;
    await _box.remove('auth_token');
  }
}