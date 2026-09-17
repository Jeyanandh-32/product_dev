/// The client origin or channel where an order was created.
enum OrderSource {
  /// Created at a physical POS terminal.
  terminal,

  /// Created via the customer web ordering portal.
  web,

  /// Created via the mobile application.
  mobileApp,
}
