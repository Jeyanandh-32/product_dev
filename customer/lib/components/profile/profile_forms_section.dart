import 'package:customer/components/profile/editable_info_card.dart';
import 'package:customer/components/profile/security_pin_card.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:models/models.dart';

/// Form cards section for modifying full name, mobile phone number, and security PIN.
class ProfileFormsSection extends StatelessComponent {
  final Customer customer;
  final String name;
  final String mobileNumber;
  final bool isEditingName;
  final bool isEditingMobile;
  final bool isEditingPin;
  final bool isSavingName;
  final bool isSavingMobile;
  final bool isSavingPin;
  final String? nameError;
  final String? mobileError;
  final String? pinError;
  final VoidCallback onStartEditName;
  final VoidCallback onCancelEditName;
  final ValueChanged<String> onNameChanged;
  final VoidCallback onSaveName;
  final VoidCallback onStartEditMobile;
  final VoidCallback onCancelEditMobile;
  final ValueChanged<String> onMobileChanged;
  final ValueChanged<String> onMobilePinChanged;
  final VoidCallback onSaveMobile;
  final VoidCallback onStartEditPin;
  final VoidCallback onCancelEditPin;
  final ValueChanged<String> onCurrentPinChanged;
  final ValueChanged<String> onNewPinChanged;
  final ValueChanged<String> onConfirmPinChanged;
  final VoidCallback onSavePin;

  const ProfileFormsSection({
    super.key,
    required this.customer,
    required this.name,
    required this.mobileNumber,
    required this.isEditingName,
    required this.isEditingMobile,
    required this.isEditingPin,
    required this.isSavingName,
    required this.isSavingMobile,
    required this.isSavingPin,
    required this.nameError,
    required this.mobileError,
    required this.pinError,
    required this.onStartEditName,
    required this.onCancelEditName,
    required this.onNameChanged,
    required this.onSaveName,
    required this.onStartEditMobile,
    required this.onCancelEditMobile,
    required this.onMobileChanged,
    required this.onMobilePinChanged,
    required this.onSaveMobile,
    required this.onStartEditPin,
    required this.onCancelEditPin,
    required this.onCurrentPinChanged,
    required this.onNewPinChanged,
    required this.onConfirmPinChanged,
    required this.onSavePin,
  });

  @override
  Component build(BuildContext context) {
    return div(classes: 'flex flex-col gap-6', [
      EditableInfoCard(
        title: 'Personal Information',
        currentValue: isEditingName ? name : customer.name,
        inputLabel: 'Full Name',
        isEditing: isEditingName,
        isSaving: isSavingName,
        error: nameError,
        onStartEdit: onStartEditName,
        onCancel: onCancelEditName,
        onValueChanged: onNameChanged,
        onSave: onSaveName,
      ),
      EditableInfoCard(
        title: 'Contact Details',
        currentValue: isEditingMobile ? mobileNumber : customer.mobileNumber,
        inputLabel: 'Mobile Number',
        inputType: InputType.tel,
        isEditing: isEditingMobile,
        isSaving: isSavingMobile,
        error: mobileError,
        onStartEdit: onStartEditMobile,
        onCancel: onCancelEditMobile,
        onValueChanged: onMobileChanged,
        onPinChanged: onMobilePinChanged,
        onSave: onSaveMobile,
      ),
      SecurityPinCard(
        isEditing: isEditingPin,
        isSaving: isSavingPin,
        error: pinError,
        onStartEdit: onStartEditPin,
        onCancel: onCancelEditPin,
        onCurrentPinChanged: onCurrentPinChanged,
        onNewPinChanged: onNewPinChanged,
        onConfirmPinChanged: onConfirmPinChanged,
        onSave: onSavePin,
      ),
    ]);
  }
}
