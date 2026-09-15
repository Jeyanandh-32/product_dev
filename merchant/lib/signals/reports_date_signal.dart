import 'package:models/models.dart';
import 'package:signals/signals.dart';

String _getTodayString() => AppDateFormatter.formatDateIso(DateTime.now());

final reportsFromDateSignal = signal<String?>(_getTodayString());
final reportsToDateSignal = signal<String?>(_getTodayString());

final reportsPaymentMethodSignal = signal<String?>(null);
final reportsOrderStatusSignal = signal<String?>(null);
final reportsPaymentStatusSignal = signal<String?>(null);

void resetReportsDateSignal() {
  reportsFromDateSignal.value = _getTodayString();
  reportsToDateSignal.value = _getTodayString();
  reportsPaymentMethodSignal.value = null;
  reportsOrderStatusSignal.value = null;
  reportsPaymentStatusSignal.value = null;
}
