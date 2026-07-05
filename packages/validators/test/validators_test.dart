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
}
