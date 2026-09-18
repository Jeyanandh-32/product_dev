import 'package:models/models.dart';
import 'package:test/test.dart';

void main() {
  group('PhonePeGatewayState JSON & Parsing Tests', () {
    test('deserializes standard states via fromJson and tryParse', () {
      expect(PhonePeGatewayState.fromJson('COMPLETED'), equals(PhonePeGatewayState.completed));
      expect(PhonePeGatewayState.fromJson('completed'), equals(PhonePeGatewayState.completed));
      expect(PhonePeGatewayState.fromJson('SUCCESS'), equals(PhonePeGatewayState.success));
      expect(PhonePeGatewayState.fromJson('FAILED'), equals(PhonePeGatewayState.failed));
      expect(PhonePeGatewayState.fromJson('CANCELLED'), equals(PhonePeGatewayState.cancelled));
      expect(PhonePeGatewayState.fromJson('PENDING'), equals(PhonePeGatewayState.pending));
      expect(PhonePeGatewayState.fromJson('CONCLUDED'), equals(PhonePeGatewayState.concluded));
      expect(PhonePeGatewayState.fromJson('UNKNOWN'), isNull);
      expect(PhonePeGatewayState.fromJson(null), isNull);
    });

    test('toJson serializes to @JsonValue uppercase string', () {
      expect(PhonePeGatewayState.completed.toJson(), equals('COMPLETED'));
      expect(PhonePeGatewayState.success.toJson(), equals('SUCCESS'));
      expect(PhonePeGatewayState.failed.toJson(), equals('FAILED'));
    });

    test('convenience getters work accurately', () {
      expect(PhonePeGatewayState.completed.isSuccess, isTrue);
      expect(PhonePeGatewayState.success.isSuccess, isTrue);
      expect(PhonePeGatewayState.failed.isSuccess, isFalse);
      expect(PhonePeGatewayState.failed.isFailed, isTrue);
      expect(PhonePeGatewayState.cancelled.isFailed, isTrue);
      expect(PhonePeGatewayState.concluded.isConcluded, isTrue);
    });
  });

  group('Status Enums fromJson and tryParse Tests', () {
    test('OrderStatus parses correctly with convenience getters', () {
      expect(OrderStatus.fromJson('completed'), equals(OrderStatus.completed));
      expect(OrderStatus.fromJson('pending'), equals(OrderStatus.pending));
      expect(OrderStatus.completed.isCompleted, isTrue);
      expect(OrderStatus.cancelled.isCancelled, isTrue);
      expect(OrderStatus.fromJson('invalid'), isNull);
    });

    test('PaymentStatus parses correctly including legacy paid/success aliases', () {
      expect(PaymentStatus.fromJson('completed'), equals(PaymentStatus.completed));
      expect(PaymentStatus.fromJson('paid'), equals(PaymentStatus.completed));
      expect(PaymentStatus.fromJson('success'), equals(PaymentStatus.completed));
      expect(PaymentStatus.fromJson('pending'), equals(PaymentStatus.pending));
      expect(PaymentStatus.fromJson('failed'), equals(PaymentStatus.failed));
      expect(PaymentStatus.completed.isPaid, isTrue);
    });

    test('PaymentMethod parses correctly', () {
      expect(PaymentMethod.fromJson('cash'), equals(PaymentMethod.cash));
      expect(PaymentMethod.fromJson('upi'), equals(PaymentMethod.upi));
      expect(PaymentMethod.fromJson('complimentary'), equals(PaymentMethod.complimentary));
      expect(PaymentMethod.cash.isCash, isTrue);
      expect(PaymentMethod.upi.isUpi, isTrue);
    });

    test('SubscriptionStatus parses correctly', () {
      expect(SubscriptionStatus.fromJson('active'), equals(SubscriptionStatus.active));
      expect(SubscriptionStatus.fromJson('grace_period'), equals(SubscriptionStatus.gracePeriod));
      expect(SubscriptionStatus.active.isOperational, isTrue);
    });

    test('StoreType parses correctly', () {
      expect(StoreType.fromJson('retail'), equals(StoreType.retail));
      expect(StoreType.fromJson('restaurant'), equals(StoreType.restaurant));
    });

    test('SettlementStatus parses correctly with convenience getters', () {
      expect(SettlementStatus.fromJson('pending'), equals(SettlementStatus.pending));
      expect(SettlementStatus.fromJson('completed'), equals(SettlementStatus.completed));
      expect(SettlementStatus.fromJson('failed'), equals(SettlementStatus.failed));
      expect(SettlementStatus.pending.isPending, isTrue);
      expect(SettlementStatus.completed.isCompleted, isTrue);
      expect(SettlementStatus.failed.isFailed, isTrue);
      expect(SettlementStatus.fromJson('unknown'), isNull);
      expect(SettlementStatus.fromJson(null), isNull);
    });
  });
}
