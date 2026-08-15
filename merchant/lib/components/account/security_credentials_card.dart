import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/jaspr_lucide.dart';
import 'package:merchant/components/fields/form_field.dart';
import 'package:web/web.dart' as web;

class SecurityCredentialsCard extends StatelessComponent {
  final String currentPassword;
  final String newPassword;
  final String confirmPassword;
  final ValueChanged<String> onCurrentPasswordChanged;
  final ValueChanged<String> onNewPasswordChanged;
  final ValueChanged<String> onConfirmPasswordChanged;
  final void Function(web.Event) onUpdatePassword;

  const SecurityCredentialsCard({
    super.key,
    required this.currentPassword,
    required this.newPassword,
    required this.confirmPassword,
    required this.onCurrentPasswordChanged,
    required this.onNewPasswordChanged,
    required this.onConfirmPasswordChanged,
    required this.onUpdatePassword,
  });

  @override
  Component build(BuildContext context) {
    return div(
      classes:
          'bg-white rounded-xl border border-border-medium p-5 shadow-2xs space-y-4',
      [
        div(
          classes:
              'flex items-center justify-between border-b border-border-light pb-3',
          [
            div(classes: 'flex items-center gap-2.5', [
              div(
                classes:
                    'p-2 bg-neutral text-primary rounded-lg border border-border-medium',
                [
                  ShieldCheck(classes: 'w-4 h-4'),
                ],
              ),
              div([
                h3(
                  classes: 'text-sm sm:text-base font-bold text-gray-900',
                  [.text('Security & Credentials')],
                ),
                p(
                  classes: 'text-xs text-gray-500 font-medium',
                  [.text('Manage password & account security')],
                ),
              ]),
            ]),
          ],
        ),

        form(
          events: {'submit': (e) => onUpdatePassword(e)},
          classes: 'space-y-3.5',
          [
            FormField(
              id: 'account_currentPassword',
              labelText: 'Current Password',
              type: .password,
              icon: Lock(classes: 'w-4.5 h-4.5'),
              onChange: (val) => onCurrentPasswordChanged(val as String),
              attributes: {
                'placeholder': '••••••••',
                'value': currentPassword,
              },
            ),

            div(
              classes: 'grid grid-cols-1 sm:grid-cols-2 gap-3.5',
              [
                FormField(
                  id: 'account_newPassword',
                  labelText: 'New Password',
                  type: .password,
                  icon: KeyRound(classes: 'w-4.5 h-4.5'),
                  onChange: (val) => onNewPasswordChanged(val as String),
                  attributes: {
                    'placeholder': '*********',
                    'value': newPassword,
                  },
                  hintText:
                      'Must be 6+ characters with a number, lowercase, and uppercase.',
                ),
                FormField(
                  id: 'account_confirmPassword',
                  labelText: 'Confirm New Password',
                  type: .password,
                  icon: KeyRound(classes: 'w-4.5 h-4.5'),
                  onChange: (val) => onConfirmPasswordChanged(val as String),
                  attributes: {
                    'placeholder': '*********',
                    'value': confirmPassword,
                  },
                  hintText: 'Re-enter same password.',
                ),
              ],
            ),

            div(classes: 'flex justify-end pt-1', [
              button(
                type: .submit,
                classes:
                    'px-4 py-2.5 bg-primary text-primary-content hover:bg-opacity-90 active:scale-95 font-bold text-xs sm:text-sm rounded-lg shadow-2xs transition-all flex items-center gap-1.5 hover:cursor-pointer',
                [
                  KeyRound(classes: 'w-4 h-4'),
                  .text('Update Password'),
                ],
              ),
            ]),
          ],
        ),
      ],
    );
  }
}
