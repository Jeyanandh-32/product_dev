import 'package:customer/components/layouts/app_layout.dart';
import 'package:customer/components/layouts/auth_layout.dart';
import 'package:customer/components/signal_component.dart';
import 'package:customer/pages/login.dart';
import 'package:customer/pages/register.dart';
import 'package:jaspr/dom.dart';
import 'package:test/test.dart';

void main() {
  group('Customer Branding & Layouts Tests', () {
    test('AuthLayout instantiates with titles and renders form container', () {
      final layout = AuthLayout(
        title: 'Sign in to your account',
        descriptionLine1: 'Enter your 10-digit mobile number',
        descriptionLine2: 'to access your orders.',
        formContent: div([.text('Form Inputs')]),
        footerContent: div([.text('Footer Link')]),
      );

      expect(layout.title, equals('Sign in to your account'));
      expect(
        layout.descriptionLine1,
        equals('Enter your 10-digit mobile number'),
      );
      expect(layout.descriptionLine2, equals('to access your orders.'));
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

    test('AppLayout instantiates as a SignalComponent with child', () {
      final appLayout = AppLayout(
        child: div([.text('Route Content')]),
      );

      expect(appLayout, isA<SignalComponent>());
      expect(appLayout.child, isNotNull);

      final state = appLayout.createState();
      expect(state, isNotNull);
    });

    test('LoginPage and RegisterPage instantiate as SignalComponents', () {
      const loginPage = LoginPage();
      expect(loginPage, isA<SignalComponent>());
      final loginState = loginPage.createState();
      expect(loginState, isNotNull);

      const registerPage = RegisterPage();
      expect(registerPage, isA<SignalComponent>());
      final registerState = registerPage.createState();
      expect(registerState, isNotNull);
    });
  });
}
