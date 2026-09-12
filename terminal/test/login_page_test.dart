import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forui/forui.dart';
import 'package:terminal/components/auth/terminal_login_form_card.dart';
import 'package:terminal/theme.dart';

Widget _wrapTestWidget(Widget child) {
  return MaterialApp(
    home: FTheme(
      data: TerminalTheme.light(),
      child: Material(type: MaterialType.transparency, child: child),
    ),
  );
}

void main() {
  testWidgets(
    'TerminalLoginFormCard calls onSignIn when Enter is pressed in password field',
    (tester) async {
      final formKey = GlobalKey<FormState>();
      final codeController = TextEditingController(text: 'TRM123456789');
      final passwordController = TextEditingController(text: 'secret123');
      bool submitted = false;

      await tester.pumpWidget(
        _wrapTestWidget(
          TerminalLoginFormCard(
            formKey: formKey,
            codeController: codeController,
            passwordController: passwordController,
            isLoading: false,
            onSignIn: () => submitted = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      final passwordField = find.byType(TextField).last;
      await tester.showKeyboard(passwordField);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      expect(submitted, isTrue);
    },
  );

  testWidgets(
    'TerminalLoginFormCard calls onSignIn when Enter is pressed in code field if password filled',
    (tester) async {
      final formKey = GlobalKey<FormState>();
      final codeController = TextEditingController(text: 'TRM123456789');
      final passwordController = TextEditingController(text: 'secret123');
      bool submitted = false;

      await tester.pumpWidget(
        _wrapTestWidget(
          TerminalLoginFormCard(
            formKey: formKey,
            codeController: codeController,
            passwordController: passwordController,
            isLoading: false,
            onSignIn: () => submitted = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      final codeField = find.byType(TextField).first;
      await tester.showKeyboard(codeField);
      await tester.testTextInput.receiveAction(TextInputAction.next);
      await tester.pumpAndSettle();

      expect(submitted, isTrue);
    },
  );

  testWidgets(
    'TerminalLoginFormCard moves focus to password field when Enter is pressed in code field if password is empty',
    (tester) async {
      final formKey = GlobalKey<FormState>();
      final codeController = TextEditingController(text: 'TRM123456789');
      final passwordController = TextEditingController();
      bool submitted = false;

      await tester.pumpWidget(
        _wrapTestWidget(
          TerminalLoginFormCard(
            formKey: formKey,
            codeController: codeController,
            passwordController: passwordController,
            isLoading: false,
            onSignIn: () => submitted = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      final codeField = find.byType(TextField).first;
      await tester.showKeyboard(codeField);
      await tester.testTextInput.receiveAction(TextInputAction.next);
      await tester.pumpAndSettle();

      expect(submitted, isFalse);
      final passwordField = tester.widget<TextField>(
        find.byType(TextField).last,
      );
      expect(passwordField.focusNode?.hasFocus, isTrue);
    },
  );
}
