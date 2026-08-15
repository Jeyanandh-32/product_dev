import 'package:client_repositories/client_repositories.dart';
import 'package:customer/signals/cart_signal.dart';
import 'package:customer/signals/customer_auth_signal.dart';
import 'package:customer/signals/recent_stores_signal.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';

/// Navigates back to the most recent store's menu if available,
/// otherwise navigates to the all stores discovery page.
Future<void> navigateToRecentStoreOrAll(BuildContext context) async {
  // 1. Check current active cart store
  final currentStore = currentCartStoreSignal.value;
  if (currentStore?.slug != null && currentStore!.slug!.isNotEmpty) {
    Router.of(context).push('/store/${currentStore.slug!}');
    return;
  }

  // 2. Check recent stores signal
  final recentStores = recentStoresSignal.value.value;
  if (recentStores != null && recentStores.isNotEmpty) {
    final firstRecent = recentStores.first;
    if (firstRecent.slug != null && firstRecent.slug!.isNotEmpty) {
      Router.of(context).push('/store/${firstRecent.slug!}');
      return;
    }
  }

  // 3. Fallback: Fetch recent stores if signal wasn't populated yet and customer is logged in
  final customer = customerAuthSignal.value.value;
  if (customer != null) {
    try {
      final fetched = await CustomerAuthRepository.getRecentStores();
      if (fetched.isNotEmpty) {
        final firstRecent = fetched.first;
        if (firstRecent.slug != null && firstRecent.slug!.isNotEmpty) {
          Router.of(context).push('/store/${firstRecent.slug!}');
          return;
        }
      }
    } catch (_) {}
  }

  // 4. Default: All stores discovery page
  Router.of(context).push('/?all=true');
}
