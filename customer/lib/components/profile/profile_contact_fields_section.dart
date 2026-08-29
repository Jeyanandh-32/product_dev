import 'package:customer/components/profile/editable_info_card.dart';
import 'package:customer/utils/customer_profile_handler.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:models/models.dart';

/// Section component for managing customer personal info and contact fields.
class ProfileContactFieldsSection extends StatefulComponent {
  final Customer customer;

  const ProfileContactFieldsSection({super.key, required this.customer});

  @override
  State<ProfileContactFieldsSection> createState() =>
      _ProfileContactFieldsSectionState();
}

class _ProfileContactFieldsSectionState
    extends State<ProfileContactFieldsSection> {
  String _name = '';
  String _mobileNumber = '';
  String _mobilePin = '';

  bool _isEditingName = false;
  bool _isEditingMobile = false;

  bool _isSavingName = false;
  bool _isSavingMobile = false;

  String? _nameError;
  String? _mobileError;

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
        currentValue: _isEditingMobile
            ? _mobileNumber
            : component.customer.mobileNumber,
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
    ]);
  }
}
