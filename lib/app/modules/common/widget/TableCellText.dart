// import 'dart:ui';
//
// import 'package:flutter/cupertino.dart';

// class TableCellText extends StatelessWidget {
//   final String data;
//   final TextStyle? style;
//
//   const TableCellText(this.data, {this.style, super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       data,
//       textAlign: TextAlign.center,
//       overflow: TextOverflow.ellipsis,
//     );
//   }
// }

import 'package:flutter/material.dart';

class TableCellText extends StatelessWidget {
  final String data;

  /// 추가 옵션들
  final TextStyle? style;
  final TextAlign textAlign;
  final int? maxLines;
  final TextOverflow overflow;
  final bool softWrap;

  // 편의 파라미터(직접 스타일 지정 없이 빠르게 설정)
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;

  const TableCellText(
      this.data, {
        super.key,
        this.style,
        this.textAlign = TextAlign.center,
        this.maxLines = 1,
        this.overflow = TextOverflow.ellipsis,
        this.softWrap = false,
        this.fontSize,
        this.fontWeight,
        this.color,
      });

  @override
  Widget build(BuildContext context) {
    final base = TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );

    // 외부에서 넣어준 style 이 있으면 merge 로 우선순위 부여
    final effectiveStyle = base.merge(style);

    return Text(
      data,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
      style: effectiveStyle,
    );
  }
}
