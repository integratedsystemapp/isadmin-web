import 'package:web/web.dart' as web;
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/model/alert_history_model.dart';
import '../../data/model/page.dart';
import '../common/api_service.dart';
import '../common/show_custom_snackbar.dart';


class AlertHistoryController extends GetxController {
  static AlertHistoryController get to {
    if (Get.isRegistered<AlertHistoryController>()) {
      return Get.find<AlertHistoryController>();
    } else {
      return Get.put(AlertHistoryController());
    }
  }

  // 선택 상태
  final selected = <int>{}.obs;
  bool isSelected(int index) => selected.contains(index);
  AlertHistoryModel? getSelected() =>
      (selected.isNotEmpty) ? alertHistoryList[selected.first] : null;

  // 데이터 & 스크롤
  final alertHistoryList = <AlertHistoryModel>[].obs;
  final ScrollController controller = ScrollController();
  final ScrollController horizontalController = ScrollController();

  // 정렬(필요 시)
  bool sortAscending = true;
  int? sortColumnIndex;

  // 페이징 상태
  static const int _pageSize = 50;  // 백엔드 기본 size와 동일
  final _page = 0.obs;              // 0-based
  final isLoading = false.obs;
  final hasMore = true.obs;
  int? _inflightPage;


  @override
  void onInit() {
    super.onInit();
    controller.addListener(_onScroll);
  }

  @override
  void onReady() {
    super.onReady();
    refreshAll(); // 최초 로드
  }

  @override
  void onClose() {
    controller.dispose();
    horizontalController.dispose();
    super.onClose();
  }

  void _onScroll() {
    if (!hasMore.value || isLoading.value) return;
    if (controller.position.pixels >= controller.position.maxScrollExtent - 300) {
      fetchNext();
    }
  }

  void toggleSelection(int index) {
    if (selected.isNotEmpty && selected.first == index) {
      selected.clear();
    } else {
      selected
        ..clear()
        ..add(index);
    }
  }

  Future<void> refreshAll() async {
    await fetchNext(reset: true);
  }

  /// ✅ 실제 API로 다음 페이지 로드
  Future<void> fetchNext({bool reset = false}) async {
    if (isLoading.value) return;

    try {
      isLoading.value = true;

      if (reset) {
        _page.value = 0;
        hasMore.value = true;
        alertHistoryList.clear();
        selected.clear();
        _inflightPage = null;
      }

      if (!hasMore.value) return;

      final int pageToLoad = _page.value;

      // 같은 페이지 동시 호출 방지
      if (_inflightPage == pageToLoad) return;
      _inflightPage = pageToLoad;

      // ====== 실제 서버 페이징 호출 ======
      final pageObj = await fetchAlertHistoryPage(pageToLoad, _pageSize);
      final rows = pageObj.items;

      // ✅ 빈 페이지면 즉시 종료
      if (rows.isEmpty) {
        hasMore.value = false;
        return;
      }

      //debugPrint('pageObj.meta.hasMore:${pageObj.meta.hasMore}');

      // 서버가 meta.hasMore 내려주면 사용, 아니면 길이로 판정
      final bool serverHasMore =
          (pageObj.meta.hasMore) ?? (rows.length == _pageSize);

      alertHistoryList.addAll(rows);

      hasMore.value = serverHasMore;
      if (serverHasMore) {
        _page.value = pageToLoad + 1;
      }
    } catch (e) {
      hasMore.value = false;
      showCustomSnackbar('에러', '경보 이력 조회 실패: $e');
      debugPrint('Error fetchNext (alert history): $e');
    } finally {
      isLoading.value = false;
      _inflightPage = null;
    }
  }

  /// ✅ 페이징 API 호출
  Future<PageModel<AlertHistoryModel>> fetchAlertHistoryPage(
      int page,
      int size,
      ) async {
    try {
      final response = await ApiService().get(
        '/alert-history/paging',
        query: {'page': page, 'size': size},
      );

      dynamic data = response.data;

      debugPrint('data:${data.toString()}');

      if (data is String) {
        try {
          data = jsonDecode(data);


        } catch (e) {
          debugPrint('❌ JSON decode failed: $e, raw=${data.substring(0, data.length.clamp(0, 500))}');
          throw const FormatException('Server returned non-JSON string');
        }
      }

      if (data is! Map<String, dynamic>) {
        debugPrint('❌ Unexpected response type: ${data.runtimeType}');
        throw const FormatException('Invalid response root (expected object)');
      }

      return PageModel<AlertHistoryModel>.fromJson(
        data,
            (j) => AlertHistoryModel.fromJson(j),
      );
    } on DioException catch (e, stack) {
      debugPrint('❌ DioException: ${e.message}');
      debugPrint('   status: ${e.response?.statusCode}');
      debugPrint('   data  : ${e.response?.data}');
      debugPrintStack(stackTrace: stack);
      throw Exception('네트워크 오류가 발생했습니다.');
    } on FormatException catch (e, stack) {
      debugPrint('❌ FormatException: ${e.message}');
      debugPrintStack(stackTrace: stack);
      throw Exception('데이터 형식이 올바르지 않습니다.');
    } catch (e, stack) {
      debugPrint('❌ Unexpected error: $e');
      debugPrintStack(stackTrace: stack);
      throw Exception('데이터 처리 중 오류가 발생했습니다.');
    }
  }

  /// 단순히 HTTP 이미지 URL을 파일로 다운로드
  void downloadImageUrl(String imageUrl, {String fileName = 'image.png'}) {
    // <a download> 엘리먼트 생성
    final anchor = web.HTMLAnchorElement()
      ..href = imageUrl
      ..download = fileName; // 일부 브라우저/크로스 도메인에서는 무시될 수 있음

    web.document.body?.append(anchor);
    anchor.click(); // 다운로드 트리거
    anchor.remove(); // DOM 정리
  }
}
