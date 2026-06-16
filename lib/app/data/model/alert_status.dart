class AlertStatus {
  final String code;   // 예: 'ALERT_STATUS_TYPE'
  final String value;  // 예: '1', '2', '3'
  final String label;  // 예: '정상', '동작', '해제'

  const AlertStatus({
    required this.code,
    required this.value,
    required this.label,
  });
}

const List<AlertStatus> alertStatuses = [
  AlertStatus(code: 'ALERT_STATUS_TYPE', value: '1', label: '경보'),
  AlertStatus(code: 'ALERT_STATUS_TYPE', value: '2', label: '상태(동작)'),
];

alertStatusDesc(String? value) {
  if (value == null) return '';
  final _alertStatusModel = alertStatuses.firstWhere(
        (level) => level.value == value,
    orElse: () => AlertStatus(value: '', label: '없음', code: ''),
  );
  return '${_alertStatusModel.label}(${_alertStatusModel.value})';
}