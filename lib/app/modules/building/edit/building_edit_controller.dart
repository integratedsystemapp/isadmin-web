import 'dart:convert';
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData, MultipartFile, Response;
import 'package:intl/intl.dart';
import '../../../data/model/building_model.dart';
import '../../../data/model/picked_file_data.dart';
import '../../../data/service/file_service.dart';
import '../../common/api_service.dart';
import '../../common/show_custom_snackbar.dart';
import 'dart:typed_data';

import '../../customer/customer_controller.dart';

class BuildingEditController extends GetxController {
  static BuildingEditController get to {
    if (Get.isRegistered<BuildingEditController>()) {
      return Get.find<BuildingEditController>();
    } else {
      return Get.put(BuildingEditController());
    }
  }

  final buildingImageFileName = ''.obs;
  final isReceivePaidMsg = true.obs; // 유료 메시지 수신 여부
  final isServiceEnabled = true.obs; // 서비스 사용 여부

  final Map<String, TextEditingController> controllers = {
    'companyCd': TextEditingController(),
    'buildingCd': TextEditingController(),
    'buildingName': TextEditingController(),
    'address': TextEditingController(),
    'address_detail': TextEditingController(),
    'edgeCount': TextEditingController(),
    'contractDate': TextEditingController(),
    'contractTermMonths': TextEditingController(),
    'usageStartDate': TextEditingController(text: '20251101'),
    'usageEndDate': TextEditingController(text: '20251201'),
    'managerName': TextEditingController(),
    'managerPosition': TextEditingController(),
    'managerPhoneNo': TextEditingController(),
    'monthlyFee': TextEditingController(),
  };

  /*
  등록, 수정 시 기본값 설정
   */
  void initFields(BuildingModel model) {
    controllers['companyCd']?.text = model.companyCd;
    controllers['buildingCd']?.text = model.buildingCd;
    controllers['buildingName']?.text = model.buildingName ?? '';
    controllers['address']?.text = model.address ?? '';
    controllers['addressDetail']?.text = model.addressDetail ?? '';
    (model.edgeCount != null)
        ? controllers['edgeCount']?.text = model.edgeCount!.toString()
        : null;
    controllers['contractDate']?.text =
        model.contractDate?.toIso8601String().split('T')[0] ?? '';
    controllers['contractTermMonths']?.text =
        model.contractTermMonths?.toString() ?? '';
    controllers['usageStartDate']?.text =
        model.usageStartDate?.toIso8601String().split('T')[0] ?? '';
    controllers['usageEndDate']?.text =
        model.usageEndDate?.toIso8601String().split('T')[0] ?? '';
    controllers['managerName']?.text = model.managerName ?? '';
    controllers['managerPosition']?.text = model.managerPosition ?? '';
    controllers['managerPhoneNo']?.text = model.managerPhoneNo ?? '';
    controllers['monthlyFee']?.text =
        model.monthlyFee?.toStringAsFixed(0) ?? '';
    buildingImageFileName.value = model.buildingImageFileName ?? '';
    isReceivePaidMsg.value = (model.isReceivePaidMsg == 'Y') ? true : false;
    isServiceEnabled.value = (model.isServiceEnabled == 'Y') ? true : false;
  }

  BuildingModel? collectModel(String mode) {
    try {
      final dateFormatter = DateFormat('yyyy-MM-dd');

      BuildingModel _buildingModel = BuildingModel(
        companyCd:
            (mode == '등록')
                ? CustomerController.to.selectedCustomerCd.value ?? 'companyCd'
                : controllers['companyCd']!.text,
        buildingCd: controllers['buildingCd']!.text,
        buildingName: controllers['buildingName']!.text,

        // 빈 문자열일 경우 null 처리
        /*
        buildingAddress: (controllers['buildingAddress']?.text.isEmpty ?? true)
            ? null
            : controllers['buildingAddress']!.text,

         */
        address: controllers['address']?.text,
        addressDetail: controllers['address_detail']?.text,

        // 숫자 변환, 비어있으면 0
        edgeCount: int.tryParse(controllers['edgeCount']?.text ?? '') ?? 0,

        // 날짜 변환, 포맷 맞춰서 null 허용
        contractDate:
            (controllers['contractDate']?.text.isNotEmpty ?? false)
                ? DateTime.tryParse(controllers['contractDate']!.text)
                : null,

        contractTermMonths:
            int.tryParse(controllers['contractTermMonths']?.text ?? '') ?? 0,

        usageStartDate:
            (controllers['usageStartDate']?.text.isNotEmpty ?? false)
                ? DateTime.tryParse(controllers['usageStartDate']!.text)
                : null,

        usageEndDate:
            (controllers['usageEndDate']?.text.isNotEmpty ?? false)
                ? DateTime.tryParse(controllers['usageEndDate']!.text)
                : null,

        managerName:
            (controllers['managerName']?.text.isEmpty ?? true)
                ? null
                : controllers['managerName']!.text,
        managerPosition:
            (controllers['managerPosition']?.text.isEmpty ?? true)
                ? null
                : controllers['managerPosition']!.text,
        managerPhoneNo:
            (controllers['managerPhoneNo']?.text.isEmpty ?? true)
                ? null
                : controllers['managerPhoneNo']!.text,

        monthlyFee:
            double.tryParse(controllers['monthlyFee']?.text ?? '') ?? 0.0,

        isReceivePaidMsg: isReceivePaidMsg.value ? 'Y' : 'N',

        buildingImageFileName: buildingImageFileName.value,

        // buildingImageUrl: (controllers['buildingImageUrl']?.text.isEmpty ?? true)
        //     ? null
        //     : controllers['buildingImageUrl']!.text,
        isServiceEnabled: isServiceEnabled.value ? 'Y' : 'N',
      );

      return _buildingModel;
    } catch (e) {
      debugPrint('***************collectModel exception:${e.toString()}');
      rethrow;
    }

    return null;
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    for (final controller in controllers.values) {
      controller.dispose();
    }
    super.onClose();
  }

  Future<BuildingModel?> createBuilding() async {
    try {
      final newBuilding = collectModel('등록');

      debugPrint('newBuilding.toJson2:${newBuilding!.toJson2().toString()}');

      MultipartFile? multipartImageFile;
      if (pickedFile.value != null)
        multipartImageFile = MultipartFile.fromBytes(
          pickedFile.value!.fileBytes,
          filename: pickedFile.value!.fileName,
        );
      // imageFile = MultipartFile.fromBytes(
      //   fileBytes,
      //   filename: 'building.jpg',
      // );

      final formData = FormData.fromMap({
        'building_data': jsonEncode(newBuilding.toJson2()), // JSON → String 변환
        if (multipartImageFile != null) 'image': multipartImageFile,
      });

      Response<dynamic> response;
      if (formData != null)
        response = await ApiService().post2('/building/', formData);
      else
        response = await ApiService().post('/building/', formData);

      debugPrint('============>');
      debugPrint(response.toString());
      debugPrint('============>');

      BuildingModel? _newBuildingModel;
      if (response.statusCode == 200 || response.statusCode == 201) {
        // showCustomSnackbar('성공', '고객이 등록되었습니다.');
        _newBuildingModel = BuildingModel.fromJson(
          response.data as Map<String, dynamic>,
        );
      } else {
        // showCustomSnackbar('오류', '등록 실패: ${response.statusCode}');
        debugPrint('등록 실패: ${response.statusCode}');
      }
      return _newBuildingModel;
    } catch (e) {
      debugPrint('******************Error create building: $e');
      if (e is DioException) {
        print(e.response?.data); // 422 detail 메시지 확인
      } // showCustomSnackbar('에러', '네트워크 오류: $e');

      // debugPrint('네트워크 오류: $e');
      rethrow;
    }
  }

  Future<BuildingModel?> updateBuilding() async {
    try {
      final updatedBuilding = collectModel('수정'); // 폼에서 데이터 수집
      debugPrint('------------------------------------------------');
      debugPrint('updateBuilding:${updatedBuilding!.toJson2()}');
      debugPrint('------------------------------------------------');

      MultipartFile? multipartImageFile;
      if (pickedFile.value != null)
        multipartImageFile = MultipartFile.fromBytes(
          pickedFile.value!.fileBytes,
          filename: pickedFile.value!.fileName,
        );

      final formData = FormData.fromMap({
        'building_data': jsonEncode(updatedBuilding.toJson2()), // JSON 문자열
        if (multipartImageFile != null) 'image': multipartImageFile,
      });

      final response = await ApiService().put(
        '/building/${updatedBuilding.companyCd}/${updatedBuilding.buildingCd}', // URL에 companyCd 포함
        formData, // JSON 바디
      );

      // debugPrint('--->');
      // debugPrint(response.toString());
      // debugPrint('--->');

      BuildingModel? _updatedBuildingModel;
      if (response.statusCode == 200) {
        // showCustomSnackbar('성공', '고객 정보가 수정되었습니다.');
        _updatedBuildingModel = BuildingModel.fromJson(
          response.data as Map<String, dynamic>,
        );
      } else {
        // showCustomSnackbar('오류', '수정 실패: ${response.statusCode}');
      }
      return _updatedBuildingModel;
    } catch (e) {
      debugPrint('Error updating building: $e');
      if (e is DioException) {
        print(e.response?.data); // 422 detail 메시지 확인
      } // showCustomSnackbar('에러', '네트워크 오류: $e');
      rethrow;
    }
  }

  /*
빌딩이미지 선택
 */
  final FileService _fileService = FileService();

  Rxn<PickedFileData> pickedFile = Rxn<PickedFileData>();
  Uint8List uploadImageUint8List = Uint8List(0);

  Future<void> selectFile() async {
    debugPrint('selectFile---1');
    // 파일 선택
    pickedFile.value = await _fileService.pickFile();
    if (pickedFile.value == null) return null;
    // 선택 파일명 화면에 노출
    buildingImageFileName.value = pickedFile.value?.fileName ?? '';
    // 파일 경로로부터 바이트 읽기
    uploadImageUint8List = pickedFile.value!.fileBytes;
  }
}
