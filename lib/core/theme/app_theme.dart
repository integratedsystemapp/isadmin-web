import 'package:HGPcWeb/core/theme/typo.dart';
import 'package:flutter/material.dart';

import '../values/colors.dart';
import '../values/consts.dart';

sealed class AppTheme {
  // The defined light theme.
  static ThemeData light = ThemeData(
    useMaterial3: true,

    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.green,
      surface: Colors.white,
      error: Colors.red,
      onTertiary: Colors.orange,
      brightness: Brightness.light, //다크/라이트 모드 선택
    ),

    appBarTheme: AppBarTheme(
      color: BUTTONAREA_COLOR,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent, // M3 틴트 제거
      elevation: 0,
      scrolledUnderElevation: 0,
      foregroundColor: Colors.white,
      centerTitle: true,
      titleTextStyle: appbarTextStyle,
    ),

    fontFamily: 'NotoSansKR',

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        padding: WidgetStateProperty.resolveWith<EdgeInsetsGeometry>((
          Set<WidgetState> states,
        ) {
          return EdgeInsets.symmetric(horizontal: 10);
        }),
        backgroundColor: MaterialStateProperty.resolveWith<Color>((
          Set<MaterialState> states,
        ) {
          if (states.contains(MaterialState.hovered)) {
            return BUTTON_HOVER_COLOR; // 마우스 hover 시 색상
          }
          if (states.contains(MaterialState.pressed)) {
            return Colors.red; // 클릭(pressed) 시 색상
          }
          return BUTTON_COLOR; // 기본 색상
        }),

        // WidgetStateProperty.all<Color>(
        //   // Color(0xfff50A374),
        //   BUTTON_COLOR,
        // ),
        //button color
        foregroundColor: WidgetStateProperty.all<Color>(
          Colors.white,
          // Color(0xffffffff),
        ),
        // 이게 아래 텍스트 스타일 컬러에 앞서서 적용
        // fixedSize: WidgetStateProperty.all<Size>(Size(double.infinity, 40)),
        // 버튼 높이 지정 굿
        textStyle: MaterialStatePropertyAll(
          const TextStyle(color: Colors.black, fontSize: 14),
          // const TextStyle(color: Colors.black,fontSize: 14, fontFamily: 'NotoSansKR', fontWeight: FontWeight.normal),
        ),

        // textStyle: WidgetStateProperty.all(TextStyle(color: Colors.black, fontSize: 12, fontFamily: 'NotoSansKR', fontWeight: FontWeight.normal)),
        // 폰트, 글자 크기, 컬러는 foreground 컬러가 우선 적용됨.
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // <-- Radius
          ),
        ),
      ),
    ),

    dataTableTheme: DataTableThemeData(
      headingRowColor: WidgetStateProperty.all(SIDEBAR_COLOR),
      // headingRowColor:  WidgetStateProperty.all(Colors.grey.shade200),
      // horizontalMargin: 15,
      headingTextStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: Colors.black,
        // fontFamily: 'NotoSansKR'
      ),
      dataTextStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: Colors.black,
        // fontFamily: 'NotoSansKR'
      ),
      dataRowColor: WidgetStateProperty.resolveWith<Color?>((
        Set<WidgetState> states,
      ) {
        if (states.contains(WidgetState.hovered)) {
          return Colors.blue.withOpacity(0.1); // Hover 시 연한 파랑
        }
        if (states.contains(WidgetState.selected)) {
          return Colors.green.withOpacity(0.2); // 선택 시 연한 초록
        }
        return null; // 기본 색상 (투명)
      }),
    ),

    scrollbarTheme: ScrollbarThemeData(
      thumbVisibility: WidgetStateProperty.all(true),
      thumbColor: WidgetStateProperty.all<Color>(Colors.black),
    ),
    snackBarTheme: SnackBarThemeData(
      actionTextColor: Colors.red,
      backgroundColor: Colors.green,
      contentTextStyle: noteSearchLabelTextStyle,
      elevation: 2,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        // side: BorderSide(color: Colors.red, width: 1),
        borderRadius: BorderRadius.circular(5),
      ),
    ),

    // 입력창 공통 데코레이션
    inputDecorationTheme: InputDecorationTheme(
      // isDense: true,
      // filled: true,
      // fillColor: const Color(0xFFF7F9FC),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),

      // 라벨/힌트/에러 스타일
      labelStyle: const TextStyle(fontSize: 12, color: Color(0xFF334155)),
      hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
      errorStyle: const TextStyle(fontSize: 10, color: Color(0xFFDC2626)),

      // 공통 테두리 모양
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(width: 1, color: Color(0xFFD0D7E2)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(width: 1, color: Colors.black54),
        // borderSide: const BorderSide(width: 1, color: Color(0xFFD0D7E2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(width: 1.5, color: Colors.green),
        // borderSide: BorderSide(width: 1.5, color: const Color(0xFF1A73E8)),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(width: 1, color: Color(0xFFDC2626)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(width: 1.5, color: Color(0xFFDC2626)),
      ),
    ),
    // 입력 텍스트/라벨의 기본 폰트
    textTheme: const TextTheme(
      bodyLarge: TextStyle(fontSize: 14, fontFamily: 'NotoSansKR'),
      bodyMedium: TextStyle(fontSize: 12, fontFamily: 'NotoSansKR'),
      labelLarge: TextStyle(fontSize: 10, fontFamily: 'NotoSansKR'),
    ).apply(
      bodyColor: Colors.black, // 기본 텍스트 컬러
      displayColor: Colors.red,
    ),

    // 커서/선택 색상
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: Color(0xFF1A73E8),
      selectionColor: Color(0x331A73E8),
      selectionHandleColor: Color(0xFF1A73E8),
    ),

    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) return hg_color1;
        return Colors.grey.shade300;
      }),
      trackColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected))
          return Colors.indigo.shade200;
        // return hg_color1;
        return Colors.grey.shade400;
      }),
    ),
  );

  // The defined dark theme.

  static ThemeData dark = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.black,
      brightness: Brightness.dark, //다크/라이트 모드 선택
    ),
  );
}
