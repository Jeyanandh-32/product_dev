/// Typed exception representation for API HTTP errors.
class const ApiException(final String message) implements Exception {
  @override
  String toString() => message;
}
