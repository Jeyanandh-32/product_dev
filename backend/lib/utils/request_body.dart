String? readOptionalString(Map<String, Object?> body, String key) {
  final value = body[key];
  if (value == null) return null;
  final normalized = (value as String).trim();
  return normalized.isEmpty ? null : normalized;
}

bool hasNonStringValue(Map<String, Object?> body, String key) {
  final value = body[key];
  return value != null && value is! String;
}

bool hasNonBoolValue(Map<String, Object?> body, String key) {
  final value = body[key];
  return value != null && value is! bool;
}
