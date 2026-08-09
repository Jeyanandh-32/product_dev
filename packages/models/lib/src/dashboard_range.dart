enum DashboardRange {
  today('1d'),
  days7('7d'),
  days30('30d'),
  year1('1y');

  const DashboardRange(this.value);
  final String value;
}
