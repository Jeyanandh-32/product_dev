class StoreValidator {
  const StoreValidator._();

  static String? create({String? name, String? storeType}) {
    if (name == null || name.trim().isEmpty) return 'Name is required.';
    return null;
  }

  static String? update({
    String? name,
    String? storeType,
    bool? isActive,
    bool namePresent = false,
    bool storeTypePresent = false,
    bool isActivePresent = false,
  }) {
    if (namePresent && name != null && name.trim().isEmpty) {
      return 'Name cannot be empty.';
    }

    if (!namePresent && !storeTypePresent && !isActivePresent) {
      return 'At least one field is required to update.';
    }

    return null;
  }
}
