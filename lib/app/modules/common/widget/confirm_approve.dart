import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<bool> confirmApprove(String userId) async {
  final shouldDelete = await Get.dialog<bool>(
    AlertDialog(
      title: const Text("승인 확인"),
      content: const Text("승인 하시겠습니까?"),
      actions: [
        TextButton(onPressed: () => Get.back(result: false), child: const Text("취소")),
        ElevatedButton(onPressed: () => Get.back(result: true), child: const Text("승인")),
      ],
    ),
  );

  return shouldDelete ?? false; // 사용자가 취소를 선택하면 false 반환
}