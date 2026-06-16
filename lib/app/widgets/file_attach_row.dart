import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FileAttachRow extends StatelessWidget {
  final String label;
  final double labelWidth;
  final String? fileName;
  final VoidCallback onAttach;
  final bool isRequired;

  const FileAttachRow({
    super.key,
    required this.label,
    required this.labelWidth,
    required this.onAttach,
    this.fileName,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('*', style: TextStyle(color: (isRequired) ? Colors.red : Colors.transparent)),
          SizedBox(width: labelWidth, child: Text(label)),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text('등록이미지 파일명'),
                Text(fileName ?? 'n/a'),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: onAttach,
            child: const Text('파일첨부'),
          ),
        ],
      ),
    );
  }
}
