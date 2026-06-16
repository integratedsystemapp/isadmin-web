import 'dart:ui';

import 'package:flutter/cupertino.dart';

class TableColumnText extends StatelessWidget {
  final String data;
  final TextStyle? style;

  const TableColumnText(this.data, {this.style, super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      textAlign: TextAlign.center,
    );
  }
}