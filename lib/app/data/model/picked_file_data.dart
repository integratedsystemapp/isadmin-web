import 'dart:typed_data';

class PickedFileData {
  final String fileName;
  final Uint8List fileBytes;

  PickedFileData({
    required this.fileName,
    required this.fileBytes,
  });
}
