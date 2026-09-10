import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/jaspr_lucide.dart' hide Map;
import 'package:merchant/components/fields/form_field.dart';
import 'package:validators/validators.dart';

/// Input fields collection for merchant registration.
class RegisterFormInputs extends StatelessComponent {
  final String fullName;
  final String businessName;
  final String whatsappNumber;
  final String email;
  final String password;
  final ValueChanged<String> onFullNameChanged;
  final ValueChanged<String> onBusinessNameChanged;
  final ValueChanged<String> onWhatsappNumberChanged;
  final ValueChanged<String> onEmailChanged;
  final ValueChanged<String> onPasswordChanged;

  const RegisterFormInputs({
    super.key,
    required this.fullName,
    required this.businessName,
    required this.whatsappNumber,
    required this.email,
    required this.password,
    required this.onFullNameChanged,
    required this.onBusinessNameChanged,
    required this.onWhatsappNumberChanged,
    required this.onEmailChanged,
    required this.onPasswordChanged,
  });

  @override
  Component build(BuildContext context) {
    return Component.fragment([
      FormField(
        onChange: (v) => onFullNameChanged(v as String),
        id: 'fullname',
        labelText: 'Full Name',
        icon: User(classes: 'w-4.5 h-4.5'),
        type: .text,
        attributes: {
          'placeholder': 'Jack Dev',
          'required': '',
          'value': fullName,
        },
        hintText: 'Name is required.',
      ),
      FormField(
        id: 'businessName',
        labelText: 'Business Name',
        icon: Building(classes: 'w-4.5 h-4.5'),
        type: .text,
        onChange: (v) => onBusinessNameChanged(v as String),
        attributes: {
          'placeholder': 'Acme Retail Solutions',
          'required': '',
          'value': businessName,
        },
        hintText: 'Business Name is required.',
      ),
      FormField(
        id: 'whatsappNumber',
        labelText: 'Whatsapp Number',
        icon: Phone(classes: 'w-4.5 h-4.5'),
        type: .tel,
        onChange: (v) => onWhatsappNumberChanged(v as String),
        attributes: {
          'placeholder': '7449261057',
          'required': '',
          'pattern': ValidationPatterns.whatsappHtml,
          'minlength': '10',
          'maxlength': '10',
          'title': 'Must be 10 digits',
          'value': whatsappNumber,
        },
        hintText: 'Must be 10 digits.',
      ),
      FormField(
        id: 'email',
        labelText: 'Email',
        icon: Mail(classes: 'w-4.5 h-4.5'),
        type: .email,
        onChange: (v) => onEmailChanged(v as String),
        attributes: {
          'placeholder': 'jacksparrow@example.com',
          'required': '',
          'value': email,
        },
        hintText: 'Email is required.',
      ),
      FormField(
        id: 'password',
        labelText: 'Password',
        icon: Lock(classes: 'w-4.5 h-4.5'),
        type: .password,
        onChange: (v) => onPasswordChanged(v as String),
        attributes: {
          'placeholder': '*********',
          'required': '',
          'pattern': ValidationPatterns.password,
          'minlength': '6',
          'value': password,
        },
        hintText:
            'Must be 6+ characters with a number, lowercase, and uppercase.',
      ),
    ]);
  }
}
