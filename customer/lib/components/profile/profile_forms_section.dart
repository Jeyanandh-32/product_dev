import 'package:customer/components/profile/editable_info_card.dart';
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
  late String _name;
  late String _mobileNumber;
  String _mobilePin = '';
  String _currentPin = '';
  String _newPin = '';
  String _confirmPin = '';

  bool _isEditingName = false;
  bool _isEditingMobile = false;
  bool _isEditingPin = false;

  bool _isSavingName = false;
  bool _isSavingMobile = false;
  bool _isSavingPin = false;

  String? _nameError;
  String? _mobileError;
  String? _pinError;

  @override
  void initState() {
    super.initState();
    _name = component.customer.name;
    _mobileNumber = component.customer.mobileNumber;
  }

  Future<void> _handleSaveName() async {
    setState(() => _isSavingName = true);
    final success = await CustomerProfileHandler.saveName(
      name: _name,
      onError: (err) => setState(() => _nameError = err),
    );
    if (mounted) {
      setState(() {
        _isSavingName = false;
        if (success) _isEditingName = false;
      });
    }
  }

  Future<void> _handleSaveMobile() async {
    setState(() => _isSavingMobile = true);
    final success = await CustomerProfileHandler.saveMobile(
      mobileNumber: _mobileNumber,
      mobilePin: _mobilePin,
      onError: (err) => setState(() => _mobileError = err),
    );
    if (mounted) {
      setState(() {
        _isSavingMobile = false;
        if (success) {
          _isEditingMobile = false;
          _mobilePin = '';
        }
      });
    }
  }

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
      EditableInfoCard(
        title: 'Personal Information',
        currentValue: _isEditingName ? _name : component.customer.name,
        inputLabel: 'Full Name',
        isEditing: _isEditingName,
        isSaving: _isSavingName,
        error: _nameError,
        onStartEdit: () => setState(() {
          _isEditingName = true;
          _nameError = null;
        }),
        onCancel: () => setState(() {
          _isEditingName = false;
          _name = component.customer.name;
          _nameError = null;
        }),
        onValueChanged: (val) => _name = val,
        onSave: _handleSaveName,
      ),
      EditableInfoCard(
        title: 'Contact Details',
        currentValue:
            _isEditingMobile ? _mobileNumber : component.customer.mobileNumber,
        inputLabel: 'Mobile Number',
        inputType: InputType.tel,
        isEditing: _isEditingMobile,
        isSaving: _isSavingMobile,
        error: _mobileError,
        onStartEdit: () => setState(() {
          _isEditingMobile = true;
          _mobileError = null;
          _mobilePin = '';
        }),
        onCancel: () => setState(() {
          _isEditingMobile = false;
          _mobileNumber = component.customer.mobileNumber;
          _mobilePin = '';
          _mobileError = null;
        }),
        onValueChanged: (val) => _mobileNumber = val,
        onPinChanged: (val) => _mobilePin = val,
        onSave: _handleSaveMobile,
      ),
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
