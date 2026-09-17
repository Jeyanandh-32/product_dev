/// Time period range for dashboard analytics queries.
enum DashboardRange {
  /// Today (single day window).
  today('1d'),

  /// Last 7 days window.
  days7('7d'),

  /// Last 30 days window.
  days30('30d'),

  /// Past 1 year window.
  year1('1y');

  const DashboardRange(this.value);

  /// String query parameter representation passed to the backend API.
  final String value;
}
