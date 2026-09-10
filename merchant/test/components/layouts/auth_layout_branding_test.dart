import 'package:jaspr/dom.dart';
import 'package:merchant/components/layouts/auth_layout.dart';
import 'package:test/test.dart';

void main() {
  group('Merchant AuthLayout Branding & Layouts Tests', () {
    test('AuthLayout instantiates with titles and renders form container', () {
      final layout = AuthLayout(
        title: 'Sign in to your account',
        descriptionLine1: 'Enter your credentials',
        descriptionLine2: 'to access the merchant dashboard.',
        formContent: div([.text('Form Inputs')]),
        footerContent: div([.text('Footer Link')]),
      );

      expect(layout.title, equals('Sign in to your account'));
      expect(layout.descriptionLine1, equals('Enter your credentials'));
      expect(
        layout.descriptionLine2,
        equals('to access the merchant dashboard.'),
      );
      expect(layout.formContent, isNotNull);
      expect(layout.footerContent, isNotNull);
    });

    test(
      'AuthLayout instantiates without titles matching clean Finch standard',
      () {
        final layout = AuthLayout(
          formContent: div([.text('Form Inputs')]),
          footerContent: div([.text('Footer Link')]),
        );

        expect(layout.title, isNull);
        expect(layout.descriptionLine1, isNull);
        expect(layout.descriptionLine2, isNull);
        expect(layout.formContent, isNotNull);
        expect(layout.footerContent, isNotNull);
      },
    );
  });
}
