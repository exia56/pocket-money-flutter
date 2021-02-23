int tryCastToInt(dynamic value) {
  if (value is int || value is double) {
    return value.toInt();
  }
  if (value is String) {
    return int.tryParse(value) ?? 0;
  }
  return 0;
}
