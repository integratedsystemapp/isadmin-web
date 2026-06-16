import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/get.dart';

import '../../data/model/building_model.dart';
import '../common/api_service.dart';
import '../common/show_custom_snackbar.dart';

class BuildingController extends GetxController {

  static BuildingController get to {
    if (Get.isRegistered<BuildingController>()) {
      return Get.find<BuildingController>();
    } else {
      return Get.put(BuildingController());
    }
  }

  final selected = <int>{}.obs;
  final buildingList = <BuildingModel>[].obs;
  final selectedBuilding = BuildingModel(
    companyCd: '',
    buildingCd: '',
    buildingName: '',
    address: '',
    addressDetail: '',
    edgeCount: 0,
    contractDate: null,
    contractTermMonths: 0,
    usageStartDate: null,
    usageEndDate: null,
    managerName: null,
    managerPosition: null,
    managerPhoneNo: null,
    monthlyFee: null,
    isReceivePaidMsg: 'Y',
    buildingImageFileName: null,
    buildingImageUrl: null,
    isServiceEnabled: 'Y',
  ).obs;

  void toggleSelection(int index) {

    if (selected.isNotEmpty && selected.first == index) {
      // 선택 토글
      selected.clear();
    } else {
      selected.clear();
      selected.add(index);
    }

    debugPrint(selected.toList().toString());

    // if (selected.contains(index)) {
    //   selected.remove(index);
    // } else {
    //   selected.add(index);
    // }
  }

  bool isSelected(int index) => selected.contains(index);

  final ScrollController controller = ScrollController();
  final ScrollController horizontalController = ScrollController();
  bool sortAscending = true;
  int? sortColumnIndex;
  RxBool isLoading = false.obs;
  bool initialized = false;
  var selectedBuildingCd = RxnString();  // dropdown list
  var selectedBuildingName = RxnString();// dropdown list

  // 선택된 빌딩 정보
  BuildingModel? getSelected() => (selected.isNotEmpty) ? buildingList[selected.first] : null;

  Future<void> fetchBuildings() async {
    try {
      isLoading.value = true;
      final response = await ApiService().get('/building/');
      final data = response.data as List<dynamic>;

      // debugPrint(jsonEncode(data), wrapWidth: 1024);

      final customers = data.map((e) => BuildingModel.fromJson(e)).toList();
      buildingList.assignAll(customers);

      // debugPrint(jsonEncode(buildingList.map((e) => e.toJson()).toList()));

      isLoading.value = false;
    } catch (e) {
      showCustomSnackbar('에러', '고객 목록 조회 실패: $e');
      debugPrint('Error fetching customers: $e');
    }
  }


  @override
  void onInit() {
    super.onInit();
    // fetchBuildings();
  }

  @override
  void dispose() {
    controller.dispose();
    horizontalController.dispose();
    super.dispose();
  }

  Future<void> deleteBuilding(BuildingModel buildingModel) async {
    try {
      final response = await ApiService().delete('/building/${buildingModel.companyCd}/${buildingModel.buildingCd}');

      debugPrint('Delete response: ${response.statusCode} - ${response.data}');
      if (response.statusCode == 200) {
        // showCustomSnackbar('성공', '빌딩 정보가 삭제되었습니다.');
      } else if (response.statusCode == 404) {
        showCustomSnackbar('오류', '빌딩 정보를 찾을 수 없습니다.');
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

  void setSelectedBuilding(String? value) {
    debugPrint('setSelectedBuilding--------------------------${value}');
    final _buildingCd = value!.split('(')[0];
    debugPrint('_buildingCd--------------------------${_buildingCd}');
    final index = this.buildingList.indexWhere((e)=>e.buildingCd == _buildingCd);
    if (index < 0) {
      debugPrint('BuildingController:setSelectedBuilding index oob:${index}');
      return;
    }

    selectedBuildingName.value = this.buildingList[index].buildingName;
    selectedBuildingCd.value = _buildingCd;

    debugPrint('selectedBuildingName.value--------------------------${selectedBuildingName.value}');
    debugPrint('index--------------------------[${index}]');
    debugPrint('setSelectedBuilding.value--------------------------${selectedBuildingCd.value}');

  }
}
