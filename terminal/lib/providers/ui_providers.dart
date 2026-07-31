import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:models/models.dart';
import 'package:terminal/providers/categories_provider.dart';

class SelectedCategoryNotifier extends Notifier<Category?> {
  @override
  Category? build() {
    final categories = ref.watch(categoriesProvider).value;
    if (categories == null || categories.isEmpty) return null;
    return categories.first;
  }

  void select(Category? category) {
    state = category;
  }
}

final selectedCategoryProvider =
    NotifierProvider.autoDispose<SelectedCategoryNotifier, Category?>(
      () => SelectedCategoryNotifier(),
    );

class PaymentModeNotifier extends Notifier<String> {
  @override
  String build() => 'cash';

  void setPaymentMode(String mode) {
    state = mode;
  }
}

final paymentModeProvider = NotifierProvider<PaymentModeNotifier, String>(
  () => PaymentModeNotifier(),
);

class SearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void setSearchQuery(String query) {
    state = query.trim().toLowerCase();
  }
}

final searchQueryProvider = NotifierProvider<SearchQueryNotifier, String>(
  () => SearchQueryNotifier(),
);
