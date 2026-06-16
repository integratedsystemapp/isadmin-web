class AlertCategoryModel {
  final String code;
  final String value;
  final String label;

  const AlertCategoryModel({
    required this.code,
    required this.value,
    required this.label,
  });
}

const List<AlertCategoryModel> alertCategories = [
  AlertCategoryModel(code: 'ALERT_CATEGORY_CD', value: '01', label: '소방설비'),
  AlertCategoryModel(code: 'ALERT_CATEGORY_CD', value: '02', label: '냉난방설비'),
  AlertCategoryModel(code: 'ALERT_CATEGORY_CD', value: '03', label: '냉동냉장설비'),
  AlertCategoryModel(code: 'ALERT_CATEGORY_CD', value: '04', label: '환경설비'),
  AlertCategoryModel(code: 'ALERT_CATEGORY_CD', value: '05', label: '급수설비'),
  AlertCategoryModel(code: 'ALERT_CATEGORY_CD', value: '06', label: '환기설비'),
  AlertCategoryModel(code: 'ALERT_CATEGORY_CD', value: '07', label: '가스설비'),
  AlertCategoryModel(code: 'ALERT_CATEGORY_CD', value: '08', label: '펌프설비'),
  AlertCategoryModel(code: 'ALERT_CATEGORY_CD', value: '09', label: '수배전설비'),
  AlertCategoryModel(code: 'ALERT_CATEGORY_CD', value: '10', label: '승강설비'),
  AlertCategoryModel(code: 'ALERT_CATEGORY_CD', value: '11', label: '주차설비'),
  AlertCategoryModel(code: 'ALERT_CATEGORY_CD', value: '12', label: '기타설비'),
];


alertCategoryDesc(String? value) {
  if (value == null) return '';
  final _alertCategoryModel = alertCategories.firstWhere(
        (level) => level.value == value,
    orElse: () => AlertCategoryModel(value: '', label: '없음', code: ''),
  );
  return '${_alertCategoryModel.label}(${_alertCategoryModel.value})';
}