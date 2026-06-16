import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../data/model/edge_model.dart';
import '../common/api_service.dart';
import '../common/show_custom_snackbar.dart';

class EdgeController extends GetxController {

  static EdgeController get to {
    if (Get.isRegistered<EdgeController>()) {
      return Get.find<EdgeController>();
    } else {
      return Get.put(EdgeController());
    }
  }

  final selected = <int>{}.obs;
  final edgeList = <EdgeModel>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // fetchEdges();
  }

  @override
  void dispose() {
    controller.dispose();
    horizontalController.dispose();
    super.dispose();
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
  EdgeModel? getSelected() => (selected.isNotEmpty) ? edgeList[selected.first] : null;

  final ScrollController controller = ScrollController();
  final ScrollController horizontalController = ScrollController();
  bool sortAscending = true;
  int? sortColumnIndex;
  bool initialized = false;
  var selectedEdgeCd = RxnString();  // dropdown list
  var selectedEdgeName = RxnString();// dropdown list

  Future<void> fetchEdges() async {
    try {
      final response = await ApiService().get('/edge/');
      final data = response.data as List<dynamic>;

      // debugPrint(jsonEncode(data), wrapWidth: 1024);

      final customers = data.map((e) => EdgeModel.fromJson(e)).toList();
      edgeList.assignAll(customers);

      // debugPrint(jsonEncode(edgeList.map((e) => e.toJson()).toList()));
    } catch (e) {
      showCustomSnackbar('에러', 'edge 목록 조회 실패: $e');
      debugPrint('Error fetching users: $e');
    }
  }

  Future<void> deleteEdge(EdgeModel edgeModel) async {
    try {
      final response = await ApiService().delete('/edge/${edgeModel.companyCd}/${edgeModel.buildingCd}/${edgeModel.edgeCd}');

      debugPrint('Delete response: ${response.statusCode} - ${response.data}');
      if (response.statusCode == 200) {
        showCustomSnackbar('성공', 'edge 정보가 삭제되었습니다.');
      } else if (response.statusCode == 404) {
        showCustomSnackbar('오류', 'edge 정보를 찾을 수 없습니다.');
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

  void setSelectedEdge(String? value) {
    debugPrint('setSelectedEdge--------------------------${value}');
    final _edgeCd = value!.split('(')[0];
    final index = this.edgeList.indexWhere((e)=>e.edgeCd == _edgeCd);
    if (index < 0) {
      debugPrint('EdgeController:setSelectedEdge index oob:${index}');
      return;
    }

    selectedEdgeName.value = this.edgeList[index].edgeName;
    selectedEdgeCd.value = _edgeCd;

    // debugPrint('selectedEdgeName.value--------------------------${selectedEdgeName.value}');
    // debugPrint('index--------------------------[${index}]');
    // debugPrint('selectedEdgeCd.value--------------------------${selectedEdgeCd.value}');
  }

  Future<void> createIotHubDevice(EdgeModel edgeModel) async {

    try {
      final url = '/iot_device/register/${edgeModel.edgeCd}';
      final response = await ApiService().post3(url);

      if (response.statusCode == 201) {
        final data = response.data;
        final String deviceIdResp = data['deviceId'];
        final String connectionString = data['connectionString'];

        print('✅ 등록 완료');
        print('Device ID: $deviceIdResp');
        print('Connection String: $connectionString');

        // edgeModel.defaultConnectionString = connectionString;
        final index = edgeList.indexWhere((e)=>e.edgeCd == edgeModel.edgeCd);
        if (index >=0)
          edgeList[index] = edgeModel;

        showCustomSnackbar('성공', '디바이스 등록이 완료 되었습니다.');

      } else {
        print('❌ 실패: ${response.statusCode} - ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final statusCode = e.response?.statusCode;
        print('❌ 서버 오류: ${e.response?.statusCode} ${e.response?.data}');
        print(e.response?.data['detail']);
        final detail =e.response?.data['detail'].toString();
        if(statusCode == 500 && detail != null && detail.contains('409')) {
          showCustomSnackbar('실패', '이미 등록된 디바이스 입니다');
        }
      } else {
        print('❌ 네트워크 오류: ${e.message}');
      }
    } catch (e) {
      print('❌ 기타 오류: $e');
    }


  }
}