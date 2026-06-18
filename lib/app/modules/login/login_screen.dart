import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/values/colors.dart';
import '../../../core/values/consts.dart';
import '../common/app_controller.dart';
import 'login_controller.dart';

/// -------------------- View (Stateless) --------------------
class LoginView extends GetView<LoginViewController> {
  LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final cardWidth = width < 420 ? width * 0.9 : 420.0;
    final saveId = controller.box.read<String>(LOGIN_ID_KEY); // 저장된 ID 가져오기
    controller.idCtrl.text = saveId ?? '';
    return Scaffold(
      backgroundColor: hg_color2,
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints.tightFor(width: cardWidth),
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
              child: Form(
                key: controller.formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 12),
                    Text(
                      'Integrated System',
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 36),
                    TextFormField(
                      controller: controller.idCtrl,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'ID',
                        hintText: '아이디를 입력하세요',
                      ),
                      validator:
                          (v) =>
                              (v == null || v.trim().isEmpty)
                                  ? '아이디를 입력하세요'
                                  : null,
                    ),
                    const SizedBox(height: 16),
                    Obx(
                      () => TextFormField(
                        controller: controller.pwCtrl,
                        obscureText: controller.obscure.value,
                        decoration: InputDecoration(
                          labelText: 'PW',
                          hintText: '비밀번호를 입력하세요',
                          suffixIcon: IconButton(
                            icon: Icon(
                              controller.obscure.value
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed:
                                () =>
                                    controller.obscure.value =
                                        !controller.obscure.value,
                          ),
                        ),
                        onFieldSubmitted: (_) => controller.login(),
                        validator:
                            (v) =>
                                (v == null || v.isEmpty) ? '비밀번호를 입력하세요' : null,
                      ),
                    ),
                    // 👇 여기 추가: 아이디 저장 여부 체크박스
                    // ↓ 비밀번호 아래 “아이디 저장” 체크
                    Obx(
                      () => Row(
                        children: [
                          Checkbox(
                            value: controller.rememberId.value,
                            onChanged:
                                (v) => controller.rememberId.value = v ?? false,
                          ),
                          const Text('아이디 저장'),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),
                    Obx(
                      () => SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: FilledButton(
                          /*
                        테스트용
                         */
                          //   TODO 나중에 제거
                          // onPressed: () => Get.offAllNamed(AppRoutes.HOME),
                          onPressed: () {
                            debugPrint(
                              'controller.loading.value:${controller.loading.value}',
                            );
                            if (controller.loading.value) {
                              debugPrint('controller.loading.value1');
                              null;
                            } else {
                              debugPrint('controller.loading.value2');
                              controller.login();
                            }
                          },

                          style: FilledButton.styleFrom(
                            backgroundColor: hg_color1,
                            // backgroundColor: const Color(0xFFFFD54F),
                            foregroundColor: Colors.black87,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child:
                              controller.loading.value
                                  ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                  : const Text(
                                    '로그인',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                        ),
                      ),
                    ),
                    Obx(
                      () => Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'debug-info:env(${AppController.to.envInfo.value})',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
