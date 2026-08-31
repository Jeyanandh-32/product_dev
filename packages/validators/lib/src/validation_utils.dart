import 'package:schemantic/schemantic.dart';

/// Function signature for a custom validation rule predicate.
typedef ValidationPredicate = bool Function(
  ValidationError error,
  List<String> path,
  ValidationErrorType type,
);

/// A declarative error-mapping rule for schema validations.
class ValidationRule {
  /// The user-facing error message returned when this rule matches.
  final String message;

  final ValidationPredicate _predicate;

  const ValidationRule._(this.message, this._predicate);

  /// Matches when a required field is missing or empty.
  factory ValidationRule.required(String field, String message) {
    return ValidationRule._(message, (error, path, type) {
      if (type == ValidationErrorType.requiredPropertyMissing) {
        return error.details?.contains('"$field"') == true;
      }
      if (path.contains(field)) {
        if (type == ValidationErrorType.typeMismatch) return true;
        if (type == ValidationErrorType.minLengthNotMet) {
          final details = error.details ?? '';
          return details.contains('String length 0');
        }
      }
      return false;
    });
  }

  /// Matches when a field does not meet minimum value or minimum length.
  factory ValidationRule.min(String field, String message) {
    return ValidationRule._(message, (error, path, type) {
      if (!path.contains(field)) return false;
      return type == ValidationErrorType.minimumNotMet ||
          type == ValidationErrorType.minLengthNotMet;
    });
  }

  /// Matches when a field exceeds maximum value or maximum length.
  factory ValidationRule.max(String field, String message) {
    return ValidationRule._(message, (error, path, type) {
      if (!path.contains(field)) return false;
      return type == ValidationErrorType.maximumExceeded ||
          type == ValidationErrorType.maxLengthExceeded;
    });
  }

  /// Matches when a field value fails a regex pattern check.
  factory ValidationRule.pattern(String field, String message) {
    return ValidationRule._(message, (error, path, type) {
      if (!path.contains(field)) return false;
      return type == ValidationErrorType.patternMismatch;
    });
  }

  /// Matches when a field has an invalid data type.
  factory ValidationRule.type(String field, String message) {
    return ValidationRule._(message, (error, path, type) {
      if (!path.contains(field)) return false;
      return type == ValidationErrorType.typeMismatch;
    });
  }

  /// Matches using an arbitrary custom predicate function.
  factory ValidationRule.custom(
    ValidationPredicate predicate,
    String message,
  ) {
    return ValidationRule._(message, predicate);
  }

  /// Returns true if this rule matches the validation error.
  bool matches(
    ValidationError error,
    List<String> path,
    ValidationErrorType type,
  ) => _predicate(error, path, type);
}

/// Convenient alias for [ValidationRule].
typedef Rule = ValidationRule;

/// Centralized utility helper to validate schemas and map errors.
Future<String?> validateSchema({
  required SchemanticType schema,
  required Map<String, dynamic> json,
  List<ValidationRule> rules = const [],
  String? Function(
    ValidationError error,
    List<String> path,
    ValidationErrorType type,
  )?
  mapError,
}) async {
  final errors = await schema.validate(json);
  if (errors.isEmpty) return null;

  final firstError = errors.first;
  final path = firstError.path;
  final type = firstError.error;

  for (final rule in rules) {
    if (rule.matches(firstError, path, type)) {
      return rule.message;
    }
  }

  if (mapError != null) {
    final mapped = mapError(firstError, path, type);
    if (mapped != null) return mapped;
  }

  return firstError.details;
}
