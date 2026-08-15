import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:merchant/components/account/merchant_info_card.dart';
import 'package:merchant/components/account/security_credentials_card.dart';
import 'package:web/web.dart';

/// Left-column forms section for Merchant details and Security credentials.
class MerchantProfileSecuritySection extends StatelessComponent {
  final String name;
  final String businessName;
  final String email;
  final String whatsappNumber;
  final ValueChanged<String> onNameChanged;
  final ValueChanged<String> onBusinessNameChanged;
  final ValueChanged<String> onEmailChanged;
  final ValueChanged<String> onWhatsappChanged;
  final void Function(Event) onSaveProfile;

  final String currentPassword;
  final String newPassword;
  final String confirmPassword;
  final ValueChanged<String> onCurrentPasswordChanged;
  final ValueChanged<String> onNewPasswordChanged;
  final ValueChanged<String> onConfirmPasswordChanged;
  final void Function(Event) onUpdatePassword;

  const MerchantProfileSecuritySection({
    super.key,
    required this.name,
    required this.businessName,
    required this.email,
    required this.whatsappNumber,
    required this.onNameChanged,
    required this.onBusinessNameChanged,
    required this.onEmailChanged,
    required this.onWhatsappChanged,
    required this.onSaveProfile,
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
    return div(classes: 'lg:col-span-2 space-y-4', [
      MerchantInfoCard(
        name: name,
        businessName: businessName,
        email: email,
        whatsappNumber: whatsappNumber,
        onNameChanged: onNameChanged,
        onBusinessNameChanged: onBusinessNameChanged,
        onEmailChanged: onEmailChanged,
        onWhatsappChanged: onWhatsappChanged,
        onSave: onSaveProfile,
      ),
      SecurityCredentialsCard(
        currentPassword: currentPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
        onCurrentPasswordChanged: onCurrentPasswordChanged,
        onNewPasswordChanged: onNewPasswordChanged,
        onConfirmPasswordChanged: onConfirmPasswordChanged,
        onUpdatePassword: onUpdatePassword,
      ),
    ]);
  }
}
