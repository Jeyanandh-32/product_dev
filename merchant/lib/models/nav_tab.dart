/// Main sidebar navigation tabs.
enum NavTab {
  dashboard('/dashboard'),
  inventory('/inventory'),
  reports('/reports'),
  stores('/stores'),
  account('/account');

  const NavTab(this.path);
  final String path;
}

/// Secondary sub-tabs for nested inventory and reports sections.
enum SubTab {
  products('products'),
  categories('categories'),
  counters('counters'),
  orders('orders'),
  profitLoss('profit-loss'),
  stockSummary('stock-summary');

  const SubTab(this.slug);
  final String slug;
}
