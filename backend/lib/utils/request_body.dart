String? readOptionalString(Map<String, Object?> body, String key) {
  final value = body[key];
  if (value == null) return null;
  final normalized = (value as String).trim();
  return normalized.isEmpty ? null : normalized;
}
