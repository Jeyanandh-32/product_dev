class CounterValidator {
  const CounterValidator._();

  static String? create({String? name, String? description, String? imageUrl}) {
    if (name == null || name.trim().isEmpty) return 'Name is required.';
    if (description != null && description.length > 255) {
      return 'Description must be 255 characters or fewer.';
    }
    if (imageUrl != null && imageUrl.length > 255) {
      return 'Image URL must be 255 characters or fewer.';
    }
    return null;
  }

  static String? update({
    String? name,
    bool? isActive,
    String? description,
    String? imageUrl,
    bool namePresent = false,
    bool isActivePresent = false,
    bool descriptionPresent = false,
    bool imageUrlPresent = false,
  }) {
    if (namePresent && name != null && name.trim().isEmpty) {
      return 'Name cannot be empty.';
    }

    if (descriptionPresent && description != null && description.length > 255) {
      return 'Description must be 255 characters or fewer.';
    }

    if (imageUrlPresent && imageUrl != null && imageUrl.length > 255) {
      return 'Image URL must be 255 characters or fewer.';
    }

    if (!namePresent &&
        !isActivePresent &&
        !descriptionPresent &&
        !imageUrlPresent) {
      return 'At least one field is required to update.';
    }

    return null;
  }
}
