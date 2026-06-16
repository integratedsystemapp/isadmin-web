class AlertLevelModel {
  final String code;
  final String value;
  final String label;

  const AlertLevelModel({
    required this.code,
    required this.value,
    required this.label,
  });
}

const List<AlertLevelModel> alertLevels = [
  AlertLevelModel(code: 'ALERT_LEVEL_CD', value: '1', label: '관심'),
  AlertLevelModel(code: 'ALERT_LEVEL_CD', value: '2', label: '주의'),
  AlertLevelModel(code: 'ALERT_LEVEL_CD', value: '3', label: '경계'),
  AlertLevelModel(code: 'ALERT_LEVEL_CD', value: '4', label: '심각'),
];

alertLevelDesc(String? value) {
  if (value == null) return '';
  final _alertLevelModel = alertLevels.firstWhere(
        (level) => level.value == value,
    orElse: () => AlertLevelModel(value: '', label: '없음', code: ''),
  );
  return '${_alertLevelModel.label}(${_alertLevelModel.value})';
}