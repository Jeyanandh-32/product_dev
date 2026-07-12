import 'package:schemantic/schemantic.dart';

/// Centralized utility helper to validate schemas and map errors.
Future<String?> validateSchema({
  required SchemanticType schema,
  required Map<String, dynamic> json,
  required String? Function(ValidationError error, List<String> path, ValidationErrorType type) mapError,
}) async {
  final errors = await schema.validate(json);
  if (errors.isEmpty) return null;

  final firstError = errors.first;
  final path = firstError.path;
  final type = firstError.error;

  final mapped = mapError(firstError, path, type);
  return mapped ?? firstError.details;
}
