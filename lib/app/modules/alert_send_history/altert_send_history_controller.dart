import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/model/alert_send_history_model.dart';
import '../../data/model/page.dart';
import '../common/api_service.dart';
import '../common/show_custom_snackbar.dart';

class AlertSendHistoryController extends GetxController {
  static AlertSendHistoryController get to {
    if (Get.isRegistered<AlertSendHistoryController>()) {
      return Get.find<AlertSendHistoryController>();
    } else {
      return Get.put(AlertSendHistoryController());
    }
  }

  // 선택 상태
  final selected = <int>{}.obs;
  bool isSelected(int index) => selected.contains(index);
  AlertSendHistoryModel? getSelected() =>
      (selected.isNotEmpty) ? alertSendHistoryList[selected.first] : null;

  // 데이터 & 스크롤
  final alertSendHistoryList = <AlertSendHistoryModel>[].obs;
  final ScrollController controller = ScrollController();
  final ScrollController horizontalController = ScrollController();

  // 정렬(필요 시)
  bool sortAscending = true;
  int? sortColumnIndex;

  // 페이징 상태
  static const int _pageSize = 50;  // 백엔드 기본 size와 동일
  final _page = 0.obs;              // 0-based page
  final isLoading = false.obs;      // 네트워크 중복 호출 방지
  final hasMore = true.obs;         // 더 불러올 것 있는지
  int? _inflightPage;               // 같은 페이지 중복 요청 방지 토큰

  @override
  void onInit() {
    super.onInit();
    controller.addListener(_onScroll);
  }

  @override
  void onReady() {
    super.onReady();
    // 최초 로드
    refreshAll();
  }

  @override
  void onClose() {
    controller.dispose();
    horizontalController.dispose();
    super.onClose();
  }

  void _onScroll() {
    if (!hasMore.value || isLoading.value) return;
    // 바닥 300px 근처에서 다음 페이지 로드
    if (controller.position.pixels >=
        controller.position.maxScrollExtent - 300) {
      fetchNext();
    }
  }

  /// 선택 토글
  void toggleSelection(int index) {
    if (selected.isNotEmpty && selected.first == index) {
      selected.clear();
    } else {
      selected
        ..clear()
        ..add(index);
    }
  }

  /// 전체 새로고침(리셋 후 0페이지부터)
  Future<void> refreshAll() async {
    await fetchNext(reset: true);
  }

  /// 다음 페이지 로드 (실제 API 사용)
  Future<void> fetchNext({bool reset = false}) async {
    if (isLoading.value) return;

    try {
      isLoading.value = true;

      if (reset) {
        _page.value = 0;
        hasMore.value = true;
        alertSendHistoryList.clear();
        selected.clear();
        _inflightPage = null;
      }

      if (!hasMore.value) return;

      final int pageToLoad = _page.value;

      // 같은 페이지 동시 호출 방지
      if (_inflightPage == pageToLoad) return;
      _inflightPage = pageToLoad;

      // ====== 실제 서버 페이징 호출 ======
      final pageObj = await fetchAlertSendHistoryPage(pageToLoad, _pageSize);
      final List<AlertSendHistoryModel> rows = pageObj.items;

      // 서버 meta.hasMore 우선 사용, 없으면 rows 길이로 판단
      final bool serverHasMore =
          (pageObj.meta.hasMore) ?? (rows.length == _pageSize);

      // 누적
      alertSendHistoryList.addAll(rows);

      // 다음 페이지 상태 갱신
      hasMore.value = serverHasMore;
      if (serverHasMore) {
        _page.value = pageToLoad + 1;
      }
    } catch (e) {
      hasMore.value = false;
      showCustomSnackbar('오류', '발송 이력 조회 실패: $e');
      debugPrint('Error fetchNext (send history): $e');
    } finally {
      isLoading.value = false;
      _inflightPage = null;
    }
  }

  /// 페이징 API 호출
  /// 백엔드: GET /alert-send-history/paging?page=0&size=50
  /// 응답: { items:[...], meta:{ page, size, total, hasMore } }
  Future<PageModel<AlertSendHistoryModel>> fetchAlertSendHistoryPage(
      int page,
      int size,
      ) async {
    try {
      final response = await ApiService().get(
        '/alert-send-history/paging',
        query: {'page': page, 'size': size},
      );

      dynamic data = response.data;

      // 간헐적으로 String으로 오는 경우 방어
      if (data is String) {
        try {
          data = jsonDecode(data);
        } catch (e) {
          debugPrint(
              '❌ JSON decode failed: $e, raw=${data.substring(0, data.length.clamp(0, 500))}');
          throw const FormatException('Server returned non-JSON string');
        }
      }

      if (data is! Map<String, dynamic>) {
        debugPrint('❌ Unexpected response type: ${data.runtimeType}');
        throw const FormatException('Invalid response root (expected object)');
      }

      // 페이지 파싱
      final pageObj = PageModel<AlertSendHistoryModel>.fromJson(
        data,
            (j) => AlertSendHistoryModel.fromJson(j),
      );
      return pageObj;
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
}
