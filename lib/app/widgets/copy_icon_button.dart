import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CopyIconButton extends StatelessWidget {
  final String textToCopy;

  const CopyIconButton({Key? key, required this.textToCopy}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const  Icon(Icons.copy, size: 16,),
      constraints: const BoxConstraints(),
      padding: EdgeInsets.zero,
      tooltip: '복사',
      onPressed: () async {
        await Clipboard.setData(ClipboardData(text: textToCopy));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('복사되었습니다')),
        );
      },
    );
  }
}
