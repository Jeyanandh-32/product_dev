import 'package:customer/components/profile/profile_contact_fields_section.dart';
import 'package:customer/components/profile/security_pin_card.dart';
import 'package:customer/utils/customer_profile_handler.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:models/models.dart';

/// Form cards section for modifying personal name, mobile number, and security PIN.
class ProfileFormsSection extends StatefulComponent {
  final Customer customer;

  const ProfileFormsSection({super.key, required this.customer});

  @override
  State<ProfileFormsSection> createState() => _ProfileFormsSectionState();
}

class _ProfileFormsSectionState extends State<ProfileFormsSection> {
  String _currentPin = '';
  String _newPin = '';
  String _confirmPin = '';

  bool _isEditingPin = false;
  bool _isSavingPin = false;
  String? _pinError;

  Future<void> _handleSavePin() async {
    setState(() => _isSavingPin = true);
    final success = await CustomerProfileHandler.savePin(
      currentPin: _currentPin,
      newPin: _newPin,
      confirmPin: _confirmPin,
      onError: (err) => setState(() => _pinError = err),
    );
    if (mounted) {
      setState(() {
        _isSavingPin = false;
        if (success) {
          _isEditingPin = false;
          _currentPin = '';
          _newPin = '';
          _confirmPin = '';
        }
      });
    }
  }

  @override
  Component build(BuildContext context) {
    return div(classes: 'flex flex-col gap-6', [
      ProfileContactFieldsSection(customer: component.customer),
      SecurityPinCard(
        isEditing: _isEditingPin,
        isSaving: _isSavingPin,
        error: _pinError,
        onStartEdit: () => setState(() {
          _isEditingPin = true;
          _pinError = null;
          _currentPin = _newPin = _confirmPin = '';
        }),
        onCancel: () => setState(() {
          _isEditingPin = false;
          _pinError = null;
          _currentPin = _newPin = _confirmPin = '';
        }),
        onCurrentPinChanged: (val) => _currentPin = val,
        onNewPinChanged: (val) => _newPin = val,
        onConfirmPinChanged: (val) => _confirmPin = val,
        onSave: _handleSavePin,
      ),
    ]);
  }
}
