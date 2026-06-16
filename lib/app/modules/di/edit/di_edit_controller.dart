import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData, MultipartFile, Response;
import '../../../data/model/customer_model.dart';
import '../../../data/model/di_model.dart';
import '../../../data/model/edge_model.dart';
import '../../../data/model/picked_file_data.dart';
import '../../../data/model/user_model.dart';
import '../../../data/service/file_service.dart';
import '../../building/building_controller.dart';
import '../../common/api_service.dart';
import '../../common/show_custom_snackbar.dart';
import 'package:dio/dio.dart';

import '../../customer/customer_controller.dart';
import '../../edge/edge_controller.dart';

class DiEditController extends GetxController {
  static DiEditController get to {
    if (Get.isRegistered<DiEditController>()) {
      return Get.find<DiEditController>();
    } else {
      return Get.put(DiEditController());
    }
  }

  // final isServiceActive = true.obs;
  final isAlertReceivable = true.obs;
  var selectedDiNo = RxnInt();  // dropdown list

  final Map<String, TextEditingController> controllers = {
    'companyCd': TextEditingController(),
    'buildingCd': TextEditingController(),
    'edgeCd': TextEditingController(),
    'diNo': TextEditingController(),
    'diName': TextEditingController(),
    'floorInfo': TextEditingController(),
    'mapImageFileName': TextEditingController(),
    'mapImageUrl': TextEditingController(),
    'sopImageFileName': TextEditingController(),
    'sopImageUrl': TextEditingController(),
    'alertLevelCd': TextEditingController(),
    'alertCategoryCd': TextEditingController(),
    'isAlertReceivable': TextEditingController(),
    'alertStatusType': TextEditingController(),
  };

  void initFields(DiModel model) {

    controllers['companyCd']?.text = model.companyCd;
    controllers['buildingCd']?.text = model.buildingCd;
    controllers['edgeCd']?.text = model.edgeCd;
    controllers['diNo']?.text = model.diNo.toString();
    controllers['diName']?.text = model.diName ?? '';
    controllers['floorInfo']?.text = model.floorInfo ?? '';
    controllers['mapImageFileName']?.text = model.mapImageFileName ?? '';
    controllers['mapImageUrl']?.text = model.mapImageUrl ?? '';
    controllers['sopImageFileName']?.text = model.sopImageFileName ?? '';
    controllers['sopImageUrl']?.text = model.sopImageUrl ?? '';
    controllers['alertLevelCd']?.text = model.alertLevelCd ?? '';
    controllers['alertCategoryCd']?.text = model.alertCategoryCd ?? '';
    controllers['isAlertReceivable']?.text = model.isAlertReceivable ?? '';
    controllers['alertStatusType']?.text = model.alertStatusType ?? '';
  }

  DiModel collectModel(String mode) {
    try {

      final _diModel = DiModel(
        companyCd: (mode == '등록') ? CustomerController.to.selectedCustomerCd.value ?? '-' : controllers['companyCd']?.text ?? '/',
        buildingCd: (mode == '등록') ? BuildingController.to.selectedBuildingCd.value ?? '-' : controllers['buildingCd']?.text ?? '/',
        edgeCd: (mode == '등록') ? EdgeController.to.selectedEdgeCd.value ?? '-' : controllers['edgeCd']?.text ?? '/',
        diNo: (mode == '등록') ? selectedDiNo.value ?? 0 : int.parse(controllers['diNo']!.text),
        diName: controllers['diName']?.text,
        floorInfo: controllers['floorInfo']?.text,
        mapImageFileName: controllers['mapImageFileName']?.text,
        mapImageUrl: controllers['mapImageUrl']?.text,
        sopImageFileName: controllers['sopImageFileName']?.text,
        sopImageUrl: controllers['sopImageUrl']?.text,
        alertLevelCd: controllers['alertLevelCd']!.text,
        alertCategoryCd: controllers['alertCategoryCd']!.text,
        isAlertReceivable: (isAlertReceivable.value) ? 'Y':'N',
        alertStatusType: controllers['alertStatusType']!.text,
      );
      debugPrint('mode;${mode}');
      debugPrint('collectModel:${_diModel.toJson().toString()}');
      return _diModel;
    } catch (e) {
      debugPrint('***************collectModel exception:${e.toString()}');
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

  Future<DiModel?> updateDi() async {
    final updatedDi = collectModel('수정'); // 폼에서 데이터 수집
    DiModel? _newDiModel ;

    debugPrint('updateDi:${updatedDi.toJson().toString()}');

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
        'di_data': jsonEncode(updatedDi.toJson()), // JSON → String 변환
        if (multipartMapImageFile != null) 'map_image': multipartMapImageFile,
        if (multipartSopImageFile != null) 'sop_image': multipartSopImageFile,
      });

      final response = await ApiService().put(
        '/di/${updatedDi.companyCd}/${updatedDi.buildingCd}/${updatedDi.edgeCd}/${updatedDi.diNo}',  // URL에 companyCd 포함
        formData, // JSON 바디
      );

      // debugPrint('--->');
      // debugPrint(response.toString());
      // debugPrint('--->');

      if (response.statusCode == 200) {
        // showCustomSnackbar('성공', '고객 정보가 수정되었습니다.');
        _newDiModel = DiModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        // showCustomSnackbar('오류', '수정 실패: ${response.statusCode}');
      }
      return _newDiModel;

    } catch (e) {
      debugPrint('Error updating customer: $e');
      // showCustomSnackbar('에러', '네트워크 오류: $e');
      if (e is DioException) {
        print(e.response?.data); // 422 detail 메시지 확인
      }      // showCustomSnackbar('에러', '네트워크 오류: $e');

      rethrow;
    }
  }

  Future<DiModel?> createDi() async {
    final newDi = collectModel('등록');

    debugPrint('newDi.toJson:${newDi!.toJson().toString()}');
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
      'di_data': jsonEncode(newDi.toJson()), // JSON → String 변환
      if (multipartMapImageFile != null) 'map_image': multipartMapImageFile,
      if (multipartSopImageFile != null) 'sop_image': multipartSopImageFile,
    });

    DiModel? _newDiModel ;
    try {
      final response = await ApiService().post2(
        '/di/',
        formData,
      );

      // debugPrint('============>');
      // debugPrint(response.toString());
      // debugPrint('============>');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // showCustomSnackbar('성공', '고객이 등록되었습니다.');
        _newDiModel = DiModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        // showCustomSnackbar('오류', '등록 실패: ${response.statusCode}');
      }
      return _newDiModel;
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        print('중복 에러: ${e.response?.data['detail']}');
      } else {
        print('에러: ${e.response?.data['message'] ?? e.message}');
      }
      rethrow;
    } catch (e) {
      debugPrint('Error create di: $e');
      // debugPrint('네트워크 오류: $e');
      rethrow;
    }
  }



/*
DI 이미지 선택
 */
  final FileService _fileService = FileService();

  Rxn<PickedFileData> pickedMapFile = Rxn<PickedFileData>();
  Rxn<PickedFileData> pickedSopFile = Rxn<PickedFileData>();

  Future<void> selectMapFile() async {
    final file = await _fileService.pickFile();
    if (file != null) {
      pickedMapFile.value = file;
      controllers['mapImageFileName']?.text = file.fileName;
    }
  }

  Future<void> selectSopFile() async {
    final file = await _fileService.pickFile();
    if (file != null) {
      pickedSopFile.value = file;
      controllers['sopImageFileName']?.text = file.fileName;
    }
  }

}
