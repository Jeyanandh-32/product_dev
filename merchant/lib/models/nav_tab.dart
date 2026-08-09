enum NavTab {
  dashboard('/dashboard'),
  inventory('/inventory'),
  reports('/reports'),
  stores('/stores'),
  account('/account');

  const NavTab(this.path);
  final String path;
}

enum SubTab {
  products('products'),
  categories('categories'),
  counters('counters'),
  orders('orders'),
  payments('payments'),
  profitLoss('profit-loss'),
  stockSummary('stock-summary');

  const SubTab(this.slug);
  final String slug;
}
