import 'package:test/test.dart';
import '../../tool/src/change_detector.dart';
import '../../tool/src/models/component.dart';

void main() {
  group('ChangeDetector mapping', () {
    test('maps backend source file changes to backend component only', () {
      final components = ChangeDetector.mapFilesToComponents([
        'backend/routes/v1/orders.dart',
        'backend/pubspec.yaml',
      ]);
      expect(components, equals({DeployComponent.backend}));
    });

    test('maps migrations directory to migrations component and not backend', () {
      final components = ChangeDetector.mapFilesToComponents([
        'backend/migrations/005_add_tables.sql',
      ]);
      expect(components, equals({DeployComponent.migrations}));
    });

    test('maps shared models to all consuming applications', () {
      final components = ChangeDetector.mapFilesToComponents([
        'packages/models/lib/src/order.dart',
      ]);
      expect(
        components,
        containsAll([
          DeployComponent.backend,
          DeployComponent.merchant,
          DeployComponent.customer,
          DeployComponent.terminal,
        ]),
      );
    });

    test('maps api_client changes to frontend apps but not backend', () {
      final components = ChangeDetector.mapFilesToComponents([
        'packages/api_client/lib/api_client.dart',
      ]);
      expect(
        components,
        containsAll([
          DeployComponent.merchant,
          DeployComponent.customer,
          DeployComponent.terminal,
        ]),
      );
      expect(components, isNot(contains(DeployComponent.backend)));
    });

    test('maps landing files to landing component', () {
      final components = ChangeDetector.mapFilesToComponents([
        'landing/index.html',
        'landing/styles.css',
      ]);
      expect(components, equals({DeployComponent.landing}));
    });

    test('returns empty set when unrelated files change', () {
      final components = ChangeDetector.mapFilesToComponents([
        'README.md',
        '.gitignore',
        'docs/architecture.png',
      ]);
      expect(components, isEmpty);
    });
  });
}
