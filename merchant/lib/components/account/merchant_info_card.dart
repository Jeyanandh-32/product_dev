import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/jaspr_lucide.dart';
import 'package:merchant/components/fields/form_field.dart';
import 'package:validators/validators.dart';
import 'package:web/web.dart' as web;

class MerchantInfoCard extends StatelessComponent {
  final String name;
  final String businessName;
  final String email;
  final String whatsappNumber;
  final ValueChanged<String> onNameChanged;
  final ValueChanged<String> onBusinessNameChanged;
  final ValueChanged<String> onEmailChanged;
  final ValueChanged<String> onWhatsappChanged;
  final void Function(web.Event) onSave;

  const MerchantInfoCard({
    super.key,
    required this.name,
    required this.businessName,
    required this.email,
    required this.whatsappNumber,
    required this.onNameChanged,
    required this.onBusinessNameChanged,
    required this.onEmailChanged,
    required this.onWhatsappChanged,
    required this.onSave,
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
                  User(classes: 'w-4 h-4'),
                ],
              ),
              div([
                h3(
                  classes: 'text-sm sm:text-base font-bold text-gray-900',
                  [.text('Merchant Information')],
                ),
                p(
                  classes: 'text-xs text-gray-500 font-medium',
                  [.text('Update account owner & business details')],
                ),
              ]),
            ]),
          ],
        ),

        form(
          events: {'submit': (e) => onSave(e)},
          classes: 'space-y-3.5',
          [
            div(
              classes: 'grid grid-cols-1 sm:grid-cols-2 gap-3.5',
              [
                FormField(
                  id: 'account_name',
                  labelText: 'Full Name',
                  type: .text,
                  icon: User(classes: 'w-4.5 h-4.5'),
                  onChange: (val) => onNameChanged(val as String),
                  attributes: {
                    'placeholder': 'Merchant Owner',
                    'required': '',
                    'value': name,
                  },
                ),
                FormField(
                  id: 'account_businessName',
                  labelText: 'Business / Trading Name',
                  type: .text,
                  icon: Building2(classes: 'w-4.5 h-4.5'),
                  onChange: (val) => onBusinessNameChanged(val as String),
                  attributes: {
                    'placeholder': 'Retail & POS Enterprise',
                    'required': '',
                    'value': businessName,
                  },
                ),
              ],
            ),

            div(
              classes: 'grid grid-cols-1 sm:grid-cols-2 gap-3.5',
              [
                FormField(
                  id: 'account_email',
                  labelText: 'Email Address',
                  type: .email,
                  icon: Mail(classes: 'w-4.5 h-4.5'),
                  onChange: (val) => onEmailChanged(val as String),
                  attributes: {
                    'placeholder': 'merchant@store.com',
                    'required': '',
                    'value': email,
                  },
                ),
                FormField(
                  id: 'account_whatsapp',
                  labelText: 'WhatsApp Number',
                  type: .tel,
                  icon: Phone(classes: 'w-4.5 h-4.5'),
                  onChange: (val) => onWhatsappChanged(val as String),
                  attributes: {
                    'placeholder': '9876543210',
                    'required': '',
                    'pattern': ValidationPatterns.whatsapp,
                    'value': whatsappNumber,
                  },
                  hintText: '10 digit mobile number.',
                ),
              ],
            ),

            div(classes: 'flex justify-end pt-1', [
              button(
                type: .submit,
                classes:
                    'px-4 py-2.5 bg-primary text-primary-content hover:bg-opacity-90 active:scale-95 font-bold text-xs sm:text-sm rounded-lg shadow-2xs transition-all flex items-center gap-1.5 hover:cursor-pointer',
                [
                  Save(classes: 'w-4 h-4'),
                  .text('Save Profile Changes'),
                ],
              ),
            ]),
          ],
        ),
      ],
    );
  }
}
