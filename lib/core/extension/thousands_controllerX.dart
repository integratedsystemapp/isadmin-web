import 'package:HGPcWeb/core/extension/thousands_separator_input_formatter.dart';
import 'package:flutter/cupertino.dart';

extension ThousandsControllerX on TextEditingController {
  void setWithThousands(String raw) {
    final f = ThousandsSeparatorInputFormatter();
    final v = f.formatEditUpdate(
      value,
      TextEditingValue(
        text: raw,
        selection: TextSelection.collapsed(offset: raw.length),
      ),
    );
    value = v;
  }
}
