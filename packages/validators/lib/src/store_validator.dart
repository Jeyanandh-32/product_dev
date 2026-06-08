class StoreValidator {
  const StoreValidator._();

  static String? create({String? name, String? storeType}) {
    if (name == null || name.trim().isEmpty) return 'Name is required.';
    return null;
  }

  static String? update({String? name, String? storeType, bool? isActive}) {
    if (name != null && name.trim().isEmpty) {
      return 'Name cannot be empty.';
    }

    if (name == null && storeType == null && isActive == null) {
      return 'At least one field (name or storeType) is required to update.';
    }

    return null;
  }
}
