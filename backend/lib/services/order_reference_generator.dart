import 'dart:math';

/// Utility generator for unique order reference strings.
class OrderReferenceGenerator {
  const OrderReferenceGenerator._();

  static final _random = Random();
  static const _chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';

  /// Generates a human-readable order reference like `ORD-1718000000000-AB12CD`.
  static String generate() {
    final suffix = List.generate(
      6,
      (_) => _chars[_random.nextInt(_chars.length)],
    ).join();
    return 'ORD-${DateTime.now().millisecondsSinceEpoch}-$suffix';
  }
}
