/// Direct mapping for PostgreSQL DateTime columns which are already returned
/// as [DateTime] objects by the database driver.
DateTime dateTimeFromJson(DateTime value) => value;

/// Safe double parser that handles [int], [double], and [String] (useful
/// for numeric postgres columns like numeric/decimal).
double doubleFromJson(Object? value) {
  if (value == null) return 0;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0;
  return 0;
}
