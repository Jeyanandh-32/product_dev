import 'package:signals/signals.dart';

String _getTodayString() {
  final now = DateTime.now().toLocal();
  final year = now.year;
  final month = now.month.toString().padLeft(2, '0');
  final day = now.day.toString().padLeft(2, '0');
  return '$year-$month-$day';
}

final reportsFromDateSignal = signal<String?>(_getTodayString());
final reportsToDateSignal = signal<String?>(_getTodayString());
