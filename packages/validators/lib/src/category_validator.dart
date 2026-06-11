class CategoryValidator {
  const CategoryValidator._();

  static String? create({String? name}) {
    if (name == null || name.trim().isEmpty) return 'Name is required.';
    return null;
  }

  static String? update({
    String? name,
    bool? isActive,
    bool namePresent = false,
    bool isActivePresent = false,
  }) {
    if (namePresent && name != null && name.trim().isEmpty) {
      return 'Name cannot be empty.';
    }

    if (!namePresent && !isActivePresent) {
      return 'At least one field is required to update.';
    }

    return null;
  }
}
