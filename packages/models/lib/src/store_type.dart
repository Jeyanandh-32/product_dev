/// Category or business type of a merchant store.
enum StoreType {
  /// General retail goods store.
  retail,

  /// Full-service or quick-service restaurant.
  restaurant,

  /// Coffee shop or cafe.
  cafe,

  /// Supermarket or grocery shop.
  grocery,

  /// Other retail establishment.
  other;

  /// Safe parser from string or wire value.
  static StoreType? tryParse(String? value) =>
      StoreType.values.asNameMap()[value?.toLowerCase().trim()];

  /// Deserializes JSON string value.
  static StoreType? fromJson(dynamic json) => tryParse(json?.toString());
}
