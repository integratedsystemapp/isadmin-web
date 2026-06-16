import 'package:intl/intl.dart';

class DateWebUtils {
  static String toYYYYMMDD(dynamic value) => _format(value, 'yyyy-MM-dd');

  static String toYYYYMMDDWithTime(dynamic value) =>
      _format(value, 'yyyy-MM-dd HH:mm:ss');

  // 내부 공통 포맷
  static String _format(dynamic value, String pattern) {
    final dt = _toDateTime(value);
    if (dt == null) return ''; // 항상 String 보장
    return DateFormat(pattern).format(dt);
  }

  // 다양한 입력을 DateTime?로 변환
  static DateTime? _toDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;

    if (value is String) {
      if (value.isEmpty) return null;
      // ISO 문자열일 경우
      final parsed = DateTime.tryParse(value);
      return parsed;
    }

    if (value is int) {
      // ms epoch라고 가정 (필요시 isUtc 조정)
      return DateTime.fromMillisecondsSinceEpoch(value, isUtc: true).toLocal();
    }

    if (value is num) {
      return DateTime.fromMillisecondsSinceEpoch(value.toInt(), isUtc: true)
          .toLocal();
    }

    return null;
  }
}
