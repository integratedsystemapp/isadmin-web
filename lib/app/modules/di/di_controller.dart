import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../data/model/di_model.dart';
import '../common/api_service.dart';
import '../common/show_custom_snackbar.dart';

class DiController extends GetxController {

  static DiController get to {
    if (Get.isRegistered<DiController>()) {
      return Get.find<DiController>();
    } else {
      return Get.put(DiController());
    }
  }

  final selected = <int>{}.obs;
  final diList = <DiModel>[].obs;
  final diListOrg = <DiModel>[];

  final searchCtrl = TextEditingController();
  final searchText = ''.obs;
  Timer? _debounce;

  @override
  void onInit() {
    super.onInit();
    // fetchDis();
  }

  @override
  void dispose() {
    controller.dispose();
    horizontalController.dispose();
    super.dispose();
  }

  @override
  void onClose() {
    _debounce?.cancel();
    searchCtrl.dispose();
    super.onClose();
  }

  void toggleSelection(int index) {

    if (selected.isNotEmpty && selected.first == index) {
      // 선택 토글
      selected.clear();
    } else {
      selected.clear();
      selected.add(index);
    }

    debugPrint(selected.toList().toString());
  }

  bool isSelected(int index) => selected.contains(index);
  DiModel? getSelected() => (selected.isNotEmpty) ? diList[selected.first] : null;

  final ScrollController controller = ScrollController();
  final ScrollController horizontalController = ScrollController();
  bool sortAscending = true;
  int? sortColumnIndex;
  bool initialized = false;

  Future<void> fetchDis() async {
    try {
      final response = await ApiService().get('/di/');
      final data = response.data as List<dynamic>;
      // debugPrint('[fetchDis]${jsonEncode(data)}');
      final dis = data.map((e) => DiModel.fromJson(e)).toList();
      // debugPrint('[fetchDis-length]${dis.length}');
      diList.assignAll(dis);
      diListOrg.assignAll(dis);

      // debugPrint(jsonEncode(diList.map((e) => e.toJson()).toList()));

    } catch (e) {
      showCustomSnackbar('에러', 'DI 목록 조회 실패: $e');
      debugPrint('Error fetching users: $e');
    }
  }

  Future<void> deleteDi(DiModel diModel) async {
    try {
      final response = await ApiService().delete('/di/${diModel.companyCd}/${diModel.buildingCd}/${diModel.edgeCd}/${diModel.diNo}');

      debugPrint('Delete response: ${response.statusCode} - ${response.data}');
      if (response.statusCode == 200) {
        // showCustomSnackbar('성공', 'DI 정보가 삭제되었습니다.');
      } else if (response.statusCode == 404) {
        showCustomSnackbar('오류', 'DI 정보를 찾을 수 없습니다.');
      } else {
        showCustomSnackbar('오류', '삭제 실패: ${response.statusCode}');
      }
    } on DioException catch (e) {
      // Dio 예외 명확히 처리
      showCustomSnackbar('네트워크 오류', '삭제 실패: ${e.response?.statusCode ?? ''}');
      rethrow;
    } catch (e) {
      showCustomSnackbar('에러', '알 수 없는 오류: $e');
      rethrow;
    }
  }


  // 입력 디바운스 처리
  void onSearchChanged(String v) {

    // debugPrint('onSearchChanged---[${searchText.value}]');

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      searchText.value = v.trim();
      applySearch();
    });
  }

  // 즉시 초기화
  void clearSearch() {
    searchCtrl.clear();
    onSearchChanged('');

    diList.assignAll(diListOrg);
  }

  // 실제 검색 로직 연결
  Future<void> applySearch() async {
    final q = searchText.value;

    diList.assignAll(diListOrg.where((e)=>e.buildingName!.toUpperCase().contains(q.toUpperCase()) || e.companyName!.toUpperCase().contains(q.toUpperCase())));

    // TODO: q를 이용해 리스트 필터링 또는 API 호출
    // 예시(로컬 필터):
    // diList.assignAll(_allItems.where((e) =>
    //   e.companyCd.contains(q) ||
    //   e.buildingCd.contains(q) ||
    //   e.edgeCd.contains(q) ||
    //   e.diNo.toString().contains(q),
    // ));

    // 예시(API):
    // final data = await repository.fetchDiList(query: q);
    // diList.assignAll(data);
  }


}