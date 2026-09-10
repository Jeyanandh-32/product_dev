import 'package:customer/components/layouts/app_layout.dart';
import 'package:customer/components/layouts/auth_layout.dart';
import 'package:customer/components/orders/customer_order_status_tabs.dart';
import 'package:customer/components/orders/customer_order_tab.dart';
import 'package:customer/components/signal_component.dart';
import 'package:customer/components/store/floating_cart_bar.dart';
import 'package:customer/components/store/store_category_filters.dart';
import 'package:customer/pages/login.dart';
import 'package:customer/pages/register.dart';
import 'package:jaspr/dom.dart';
import 'package:test/test.dart';

void main() {
  group('Customer Branding & Layouts Tests', () {
    test('AuthLayout instantiates with titles and renders form container', () {
      final layout = AuthLayout(
        title: 'Sign in to your account',
        descriptionLine1: 'Enter your 10-digit mobile number',
        descriptionLine2: 'to access your orders.',
        formContent: div([.text('Form Inputs')]),
        footerContent: div([.text('Footer Link')]),
      );

      expect(layout.title, equals('Sign in to your account'));
      expect(
        layout.descriptionLine1,
        equals('Enter your 10-digit mobile number'),
      );
      expect(layout.descriptionLine2, equals('to access your orders.'));
      expect(layout.formContent, isNotNull);
      expect(layout.footerContent, isNotNull);
    });

    test(
      'AuthLayout instantiates without titles matching clean Finch standard',
      () {
        final layout = AuthLayout(
          formContent: div([.text('Form Inputs')]),
          footerContent: div([.text('Footer Link')]),
        );

        expect(layout.title, isNull);
        expect(layout.descriptionLine1, isNull);
        expect(layout.descriptionLine2, isNull);
        expect(layout.formContent, isNotNull);
        expect(layout.footerContent, isNotNull);
      },
    );

    test('AppLayout instantiates as a SignalComponent with child', () {
      final appLayout = AppLayout(
        child: div([.text('Route Content')]),
      );

      expect(appLayout, isA<SignalComponent>());
      expect(appLayout.child, isNotNull);

      final state = appLayout.createState();
      expect(state, isNotNull);
    });

    test('LoginPage and RegisterPage instantiate as SignalComponents', () {
      const loginPage = LoginPage();
      expect(loginPage, isA<SignalComponent>());
      final loginState = loginPage.createState();
      expect(loginState, isNotNull);

      const registerPage = RegisterPage();
      expect(registerPage, isA<SignalComponent>());
      final registerState = registerPage.createState();
      expect(registerState, isNotNull);
    });

    test('FloatingCartBar instantiates with cart totals', () {
      const cartBar = FloatingCartBar(
        totalCartCount: 3,
        totalCartPrice: 450.0,
      );
      expect(cartBar.totalCartCount, equals(3));
      expect(cartBar.totalCartPrice, equals(450.0));
    });

    test('CustomerOrderStatusTabs instantiates with active tab', () {
      final tabs = CustomerOrderStatusTabs(
        selectedTab: CustomerOrderTab.pending,
        onTabSelected: (_) {},
      );
      expect(tabs.selectedTab, equals(CustomerOrderTab.pending));
    });

    test('StoreCategoryFilters instantiates with empty list', () {
      final filters = StoreCategoryFilters(
        categories: const [],
        selectedCategoryId: null,
        onSelectCategory: (_) {},
      );
      expect(filters.categories, isEmpty);
      expect(filters.selectedCategoryId, isNull);
    });
  });
}
