import 'package:file_picker/file_picker.dart';
import '../model/picked_file_data.dart';

class FileService {
  /// 파일 선택 공통 함수
  Future<PickedFileData?> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      withData: true, // Web에서 필수
      allowMultiple: false,
    );

    if (result != null) {
      return PickedFileData(
        fileName: result.files.single.name,
        fileBytes: result.files.single.bytes!,
      );
    }

    return null;
  }
}
