/// Utility for strictly extracting and validating order references from QR code scan payloads.
abstract final class OrderQrCodeParser {
  /// Extracts a validated order reference from a raw [rawValue] string.
  ///
  /// Strictly supports order references (starting with `ORD`, case-insensitive),
  /// either as raw codes (e.g. `ORD-1718000000000-AB12CD`) or embedded in URLs
  /// via query parameters (`?ref=...`, `?orderReference=...`) or path segments.
  ///
  /// Returns `null` if [rawValue] does not contain a valid order reference.
  static String? parse(String? rawValue) {
    if (rawValue == null) return null;
    final trimmed = rawValue.trim();
    if (trimmed.isEmpty) return null;

    final uri = Uri.tryParse(trimmed);
    if (uri != null && uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https')) {
      final params = uri.queryParameters;
      final refParam = params['ref'] ??
          params['reference'] ??
          params['orderReference'] ??
          params['order_reference'] ??
          params['orderId'] ??
          params['order_id'];

      if (refParam != null && _isOrderReference(refParam)) {
        return refParam.trim();
      }

      final segments = uri.pathSegments.where((s) => s.isNotEmpty).toList();
      if (segments.length >= 2 && segments[segments.length - 2].toLowerCase() == 'orders') {
        final last = segments.last.trim();
        if (_isOrderReference(last)) return last;
      }

      return null;
    }

    return _isOrderReference(trimmed) ? trimmed : null;
  }

  static bool _isOrderReference(String value) =>
      value.trim().toUpperCase().startsWith('ORD');
}
