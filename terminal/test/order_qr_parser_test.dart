import 'package:flutter_test/flutter_test.dart';
import 'package:terminal/components/scanner/order_qr_code_parser.dart';

void main() {
  group('OrderQrCodeParser', () {
    test('returns null for null or empty strings', () {
      expect(OrderQrCodeParser.parse(null), isNull);
      expect(OrderQrCodeParser.parse(''), isNull);
      expect(OrderQrCodeParser.parse('   '), isNull);
    });

    test('extracts raw reference strings and rejects non-reference codes', () {
      expect(OrderQrCodeParser.parse('ord_abc123'), equals('ord_abc123'));
      expect(OrderQrCodeParser.parse('ORD-20260918-9901'), equals('ORD-20260918-9901'));
      // Non-reference codes (bill numbers, UUIDs, other prefixes) must be rejected
      expect(OrderQrCodeParser.parse('1042'), isNull);
      expect(OrderQrCodeParser.parse('550e8400-e29b-41d4-a716-446655440000'), isNull);
      expect(OrderQrCodeParser.parse('BTL-12345'), isNull);
      expect(OrderQrCodeParser.parse('PROD-999'), isNull);
    });

    test('extracts reference query parameters from URLs when reference is valid', () {
      expect(
        OrderQrCodeParser.parse('https://store.finch.app/order-status?ref=ORD-991'),
        equals('ORD-991'),
      );
      expect(
        OrderQrCodeParser.parse('http://localhost:3000/orders?orderReference=ORD-42'),
        equals('ORD-42'),
      );
      // Non-order reference query params must be rejected
      expect(
        OrderQrCodeParser.parse('https://example.com/?billNo=204'),
        isNull,
      );
      expect(
        OrderQrCodeParser.parse('https://example.com/?ref=REF-42'),
        isNull,
      );
    });

    test('extracts reference from orders path segment in URL only if order reference', () {
      expect(
        OrderQrCodeParser.parse('https://store.finch.app/orders/ord_xyz789'),
        equals('ord_xyz789'),
      );
      expect(
        OrderQrCodeParser.parse('https://store.finch.app/orders/1042'),
        isNull,
      );
    });
  });
}
