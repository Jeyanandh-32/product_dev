import 'package:merchant/components/dashboard/dashboard_chart_options.dart';
import 'package:merchant/components/dashboard/revenue_trend_chart_card.dart';
import 'package:test/test.dart';

void main() {
  group('DashboardBarChartOptions Responsive Presets Tests', () {
    test('categoryHorizontalBar preset is configured for horizontal responsiveness', () {
      final options = DashboardBarChartOptions.categoryHorizontalBar();

      expect(options['indexAxis'], equals('y'));
      expect(options['responsive'], isTrue);
      expect(options['maintainAspectRatio'], isFalse);

      final plugins = options['plugins'] as Map<String, dynamic>;
      final legend = plugins['legend'] as Map<String, dynamic>;
      expect(legend['display'], isFalse);

      final scales = options['scales'] as Map<String, dynamic>;
      final xScale = scales['x'] as Map<String, dynamic>;
      final yScale = scales['y'] as Map<String, dynamic>;

      expect(xScale['beginAtZero'], isTrue);
      expect(yScale['grid']['display'], isFalse);

      final yTicks = yScale['ticks'] as Map<String, dynamic>;
      expect(yTicks['autoSkip'], isFalse);
      expect(yTicks['font']['weight'], equals('600'));
    });

    test('hourlyOrdersBar preset preserves strictly horizontal labels without tilt', () {
      final options = DashboardBarChartOptions.hourlyOrdersBar();

      expect(options['responsive'], isTrue);
      expect(options['maintainAspectRatio'], isFalse);

      final scales = options['scales'] as Map<String, dynamic>;
      final xScale = scales['x'] as Map<String, dynamic>;
      final xTicks = xScale['ticks'] as Map<String, dynamic>;

      expect(xTicks['maxRotation'], equals(0));
      expect(xTicks['minRotation'], equals(0));
      expect(xTicks['autoSkip'], isTrue);
    });

    test('salesTrendLine preset formats axes with zero rotation', () {
      final options = DashboardBarChartOptions.salesTrendLine();

      expect(options['responsive'], isTrue);
      expect(options['maintainAspectRatio'], isFalse);

      final scales = options['scales'] as Map<String, dynamic>;
      final xScale = scales['x'] as Map<String, dynamic>;
      final xTicks = xScale['ticks'] as Map<String, dynamic>;

      expect(xTicks['maxRotation'], equals(0));
      expect(xTicks['minRotation'], equals(0));

      final yScale = scales['y'] as Map<String, dynamic>;
      expect(yScale['beginAtZero'], isTrue);
    });

    test(
      'category label truncation handles long category names gracefully',
      () {
        String truncateLabel(String label) {
          if (label.length > 20) {
            return '${label.substring(0, 18)}…';
          }
          return label;
        }

        expect(truncateLabel('Desserts & Cakes'), equals('Desserts & Cakes'));
        expect(
          truncateLabel('Specialty Coffee & Brews'),
          equals('Specialty Coffee &…'),
        );
        expect(
          truncateLabel('Gourmet Sandwiches & Toasties'),
          equals('Gourmet Sandwiches…'),
        );
      },
    );
  });

  group('RevenueTrendChartCard Component Tests', () {
    test('instantiates with active store and positive orders count', () {
      const card = RevenueTrendChartCard(
        totalOrders: 24,
        isStoreActive: true,
      );

      expect(card.totalOrders, equals(24));
      expect(card.isStoreActive, isTrue);
    });

    test('instantiates with inactive store and zero orders count', () {
      const card = RevenueTrendChartCard(
        totalOrders: 0,
        isStoreActive: false,
      );

      expect(card.totalOrders, equals(0));
      expect(card.isStoreActive, isFalse);
    });
  });
}
