@TestOn('browser')
library;

import 'package:customer/components/fields/form_field.dart';
import 'package:jaspr/dom.dart';
import 'package:test/test.dart';

void main() {
  group('Customer FormField Tests', () {
    test('instantiates with text input type and required parameters', () {
      final field = FormField(
        id: 'fullname',
        labelText: 'Full Name',
        type: InputType.text,
        attributes: const {'placeholder': 'John Doe'},
        hintText: 'Enter your legal name.',
        onChange: (_) {},
      );

      expect(field.id, equals('fullname'));
      expect(field.labelText, equals('Full Name'));
      expect(field.type, equals(InputType.text));
      expect(field.hintText, equals('Enter your legal name.'));
      expect(field.enableForgotPassword, isFalse);
      expect(field.createState(), isNotNull);
    });

    test(
      'instantiates with password input type and forgot password enabled',
      () {
        final field = FormField(
          id: 'pin',
          labelText: 'Security PIN',
          type: InputType.password,
          attributes: const {'placeholder': '••••••'},
          enableForgotPassword: true,
        );

        expect(field.id, equals('pin'));
        expect(field.labelText, equals('Security PIN'));
        expect(field.type, equals(InputType.password));
        expect(field.enableForgotPassword, isTrue);
      },
    );
  });
}
