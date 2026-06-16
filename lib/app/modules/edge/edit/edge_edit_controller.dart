import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData, MultipartFile, Response;
import '../../../data/model/customer_model.dart';
import '../../../data/model/edge_model.dart';
import '../../../data/model/picked_file_data.dart';
import '../../../data/model/user_model.dart';
import '../../../data/service/file_service.dart';
import '../../building/building_controller.dart';
import '../../common/api_service.dart';
import '../../common/show_custom_snackbar.dart';
import 'package:dio/dio.dart';

import '../../customer/customer_controller.dart';

class EdgeEditController extends GetxController {
  static EdgeEditController get to {
    if (Get.isRegistered<EdgeEditController>()) {
      return Get.find<EdgeEditController>();
    } else {
      return Get.put(EdgeEditController());
    }
  }

  final isServiceActive = true.obs;
  final isAlertReceivable = true.obs;

  final Map<String, TextEditingController> controllers = {
    'companyCd': TextEditingController(),
    'buildingCd': TextEditingController(),
    'edgeCd': TextEditingController(),
    'edgeName': TextEditingController(),
    'defaultConnectionString': TextEditingController(),
    'edgeInstallLocation': TextEditingController(),
  };

  void initFields(EdgeModel model) {
    controllers['companyCd']?.text = model.companyCd;
    controllers['buildingCd']?.text = model.buildingCd;
    controllers['edgeCd']?.text = model.edgeCd;
    controllers['edgeName']?.text = model.edgeName ?? '';
    // controllers['defaultConnectionString']?.text = model.defaultConnectionString ?? '';
    controllers['edgeInstallLocation']?.text = model.edgeInstallLocation ?? '';
  }

  EdgeModel collectModel(String mode) {
    try {
      final edgeModel =  EdgeModel(
        companyCd: (mode == '등록') ? CustomerController.to.selectedCustomerCd.value! : controllers['companyCd']?.text ?? 'error_company_cd!!!',
        buildingCd: (mode == '등록') ? BuildingController.to.selectedBuildingCd.value! : controllers['buildingCd']?.text ?? 'error_building_cd!!!',
        edgeCd: (mode == '등록') ? 'edgeCd' : controllers['edgeCd']?.text ?? 'error_edge_cd!!!',
        edgeName: controllers['edgeName']?.text ?? '',
        /*
        diNo: int.parse(controllers['di_no']!.text),
        defaultConnectionString: controllers['default_connection_string']?.text,
         */
        edgeInstallLocation: controllers['edgeInstallLocation']?.text,
      );
      return edgeModel;
    } catch (e) {
      debugPrint('********* EdgeEditController:collectModel exception:${e.toString()}');
      rethrow;
    }
  }

  @override
  void onClose() {
    for (final controller in controllers.values) {
      controller.dispose();
    }
    super.onClose();
  }

  Future<EdgeModel?> updateEdge() async {
    debugPrint('updateEdge..');
    final updateEdge = collectModel('수정'); // 폼에서 데이터 수집
    EdgeModel? _newEdgeModel ;

    debugPrint('updateEdge:${updateEdge.toJson().toString()}');

    try {

      // Map image
      MultipartFile? multipartMapImageFile;
      if (pickedMapFile.value != null)
        multipartMapImageFile = MultipartFile.fromBytes(
            pickedMapFile.value!.fileBytes,
            filename: pickedMapFile.value!.fileName
        );
      // SOP image
      MultipartFile? multipartSopImageFile;
      if (pickedSopFile.value != null)
        multipartSopImageFile = MultipartFile.fromBytes(
            pickedSopFile.value!.fileBytes,
            filename: pickedSopFile.value!.fileName
        );

      final formData = FormData.fromMap({
        'edge_data': jsonEncode(updateEdge.toJson()), // JSON → String 변환
        if (multipartMapImageFile != null) 'map_image': multipartMapImageFile,
        if (multipartSopImageFile != null) 'sop_image': multipartSopImageFile,
      });

      final response = await ApiService().put(
        '/edge/${updateEdge.companyCd}/${updateEdge.buildingCd}/${updateEdge.edgeCd}',  // URL에 companyCd 포함
        formData, // JSON 바디
      );

      if (response.statusCode == 200) {
        // showCustomSnackbar('성공', '고객 정보가 수정되었습니다.');
        _newEdgeModel = EdgeModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        // showCustomSnackbar('오류', '수정 실패: ${response.statusCode}');
      }
      return _newEdgeModel;

    } catch (e) {
      debugPrint('Error updating customer: $e');
      // showCustomSnackbar('에러', '네트워크 오류: $e');
      if (e is DioException) {
        print(e.response?.data); // 422 detail 메시지 확인
      }      // showCustomSnackbar('에러', '네트워크 오류: $e');

      rethrow;
    }
  }

  Future<EdgeModel?> createEdge() async {
    final newEdge = collectModel('등록');

    // null 값 제거 후 JSON 변환
    /*
    final edgeJson = Map.from(newEdge!.toJson())
      ..removeWhere((key, value) => value == null);

    debugPrint('newEdge.toJson2: $edgeJson');

     */


    // Map image
    MultipartFile? multipartMapImageFile;
    if (pickedMapFile.value != null)
      multipartMapImageFile = MultipartFile.fromBytes(
          pickedMapFile.value!.fileBytes,
          filename: pickedMapFile.value!.fileName
      );
    // SOP image
    MultipartFile? multipartSopImageFile;
    if (pickedSopFile.value != null)
      multipartSopImageFile = MultipartFile.fromBytes(
          pickedSopFile.value!.fileBytes,
          filename: pickedSopFile.value!.fileName
      );

    final formData = FormData.fromMap({
      'edge_data': jsonEncode(newEdge.toJson()), // JSON → String 변환
      if (multipartMapImageFile != null) 'map_image': multipartMapImageFile,
      if (multipartSopImageFile != null) 'sop_image': multipartSopImageFile,
    });

    EdgeModel? _newEdgeModel ;
    try {
      final response = await ApiService().post2(
        '/edge/',
        formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // showCustomSnackbar('성공', '고객이 등록되었습니다.');
        _newEdgeModel = EdgeModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        debugPrint('등록 실패: ${response.statusCode}');
      }
      return _newEdgeModel;
    } catch (e) {
      debugPrint('Error create edge: $e');
      if (e is DioException) {
        debugPrint('Server Response: ${e.response?.data}');
      }      // showCustomSnackbar('에러', '네트워크 오류: $e');
      rethrow;
    }
  }


/*
빌딩이미지 선택
 */
  final FileService _fileService = FileService();

  Rxn<PickedFileData> pickedMapFile = Rxn<PickedFileData>();
  Rxn<PickedFileData> pickedSopFile = Rxn<PickedFileData>();

  Future<void> selectMapFile() async {
    final file = await _fileService.pickFile();
    if (file != null) {
      pickedMapFile.value = file;
    }
  }

  Future<void> selectSopFile() async {
    final file = await _fileService.pickFile();
    if (file != null) {
      pickedSopFile.value = file;
    }
  }


}
