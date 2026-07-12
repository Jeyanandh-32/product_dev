import 'package:test/test.dart';
import 'package:validators/validators.dart';

void main() {
  group('TerminalValidator.create', () {
    test('returns error when name is empty', () async {
      expect(
        await TerminalValidator.create({'name': '', 'password': 'Password1'}),
        'Terminal Name is required.',
      );
      expect(
        await TerminalValidator.create({'name': null, 'password': 'Password1'}),
        'Terminal Name is required.',
      );
    });

    test('returns error when password is empty', () async {
      expect(
        await TerminalValidator.create({'name': 'Terminal 1', 'password': ''}),
        'Password is required.',
      );
      expect(
        await TerminalValidator.create({
          'name': 'Terminal 1',
          'password': null,
        }),
        'Password is required.',
      );
    });

    test('returns error when password format is invalid', () async {
      expect(
        await TerminalValidator.create({
          'name': 'Terminal 1',
          'password': '123',
        }),
        'Password must be at least 6 characters long and contain at least one number, one uppercase letter, and one lowercase letter.',
      );
    });

    test('returns null when valid input is provided', () async {
      expect(
        await TerminalValidator.create({
          'name': 'Terminal 1',
          'password': 'Password1',
        }),
        isNull,
      );
    });
  });

  group('TerminalValidator.update', () {
    test('returns error when name is empty', () async {
      expect(
        await TerminalValidator.update({'name': ''}),
        'Terminal Name cannot be empty.',
      );
    });

    test('returns error when password is empty', () async {
      expect(
        await TerminalValidator.update({'password': ''}),
        'Password must be at least 6 characters long and contain at least one number, one uppercase letter, and one lowercase letter.',
      );
    });

    test('returns error when password format is invalid', () async {
      expect(
        await TerminalValidator.update({'password': '123'}),
        'Password must be at least 6 characters long and contain at least one number, one uppercase letter, and one lowercase letter.',
      );
    });

    test('returns error when no fields are provided for update', () async {
      expect(
        await TerminalValidator.update({}),
        'At least one field (name, password, or isActive) is required to update.',
      );
    });

    test('returns null when valid updates are provided', () async {
      expect(await TerminalValidator.update({'name': 'New Name'}), isNull);
      expect(
        await TerminalValidator.update({'password': 'NewPassword1'}),
        isNull,
      );
      expect(await TerminalValidator.update({'isActive': false}), isNull);
    });
  });

  group('OrderValidator.create', () {
    final validOrder = {
      'source': 'terminal',
      'type': 'takeaway',
      'paymentMethod': 'cash',
      'products': [
        {'productId': 'prod-123', 'quantity': 2},
      ],
    };

    test('returns null when valid order is provided', () async {
      expect(await OrderValidator.create(validOrder), isNull);
    });

    test('returns error when required field is missing', () async {
      final invalidOrder = Map<String, Object?>.from(validOrder)
        ..remove('products');
      expect(
        await OrderValidator.create(invalidOrder),
        'Products list is required.',
      );
    });

    test('returns error when products list is empty', () async {
      final invalidOrder = Map<String, Object?>.from(validOrder)
        ..['products'] = <dynamic>[];
      expect(
        await OrderValidator.create(invalidOrder),
        'Products list must contain at least one item.',
      );
    });

    test('returns error when product quantity is negative or zero', () async {
      final invalidOrder = Map<String, Object?>.from(validOrder)
        ..['products'] = [
          {'productId': 'prod-123', 'quantity': 0},
        ];
      expect(
        await OrderValidator.create(invalidOrder),
        'Quantity must be a positive integer.',
      );
    });

    test('returns error when productId is empty', () async {
      final invalidOrder = Map<String, Object?>.from(validOrder)
        ..['products'] = [
          {'productId': '', 'quantity': 1},
        ];
      expect(await OrderValidator.create(invalidOrder), 'Invalid Product ID.');
    });
  });
}
