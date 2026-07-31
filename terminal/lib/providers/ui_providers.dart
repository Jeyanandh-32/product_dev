import 'package:models/models.dart';
import 'package:signals_flutter/signals_flutter.dart';

final selectedCategorySignal = signal<Category?>(null);

final paymentModeSignal = signal<String>('cash');

final searchQuerySignal = signal<String>('');
