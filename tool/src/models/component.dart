/// Deployable component definitions across the Finch POS workspace.
library;

/// Represents an independently deployable component or artifact target.
enum DeployComponent {
  /// Dart Frog backend API server.
  backend('backend', 'dist/server.exe', isBinary: true),

  /// Merchant dashboard Jaspr web application.
  merchant('merchant', 'dist/merchant', isWeb: true),

  /// Customer storefront Jaspr web application.
  customer('customer', 'dist/store', isWeb: true),

  /// Point of sale terminal Flutter web application.
  terminal('terminal', 'dist/terminal', isWeb: true),

  /// Static landing page assets and html.
  landing('landing', 'landing', isStatic: true),

  /// PostgreSQL database migrations.
  migrations('migrations', 'backend/migrations', isDatabase: true);

  const DeployComponent(
    this.identifier,
    this.artifactPath, {
    this.isBinary = false,
    this.isWeb = false,
    this.isStatic = false,
    this.isDatabase = false,
  });

  /// Unique string identifier used for CLI flags and filtering.
  final String identifier;

  /// Relative path to built artifact or source directory.
  final String artifactPath;

  /// Whether this component produces an executable native server binary.
  final bool isBinary;

  /// Whether this component is deployed to the nginx web root directory.
  final bool isWeb;

  /// Whether this component contains static pre-rendered web assets.
  final bool isStatic;

  /// Whether this component contains SQL database migrations.
  final bool isDatabase;

  /// Resolves a component from a string identifier, or returns null if unknown.
  static DeployComponent? fromIdentifier(String value) {
    for (final component in DeployComponent.values) {
      if (component.identifier.toLowerCase() == value.toLowerCase()) {
        return component;
      }
    }
    return null;
  }

  /// Returns true if changes in the given file path should trigger this component.
  bool matchesPath(String filePath) {
    final normalized = filePath.replaceAll('\\', '/');

    switch (this) {
      case DeployComponent.backend:
        if (normalized.startsWith('backend/migrations/')) return false;
        return normalized.startsWith('backend/') ||
            normalized.startsWith('packages/models/') ||
            normalized.startsWith('packages/validators/');

      case DeployComponent.merchant:
        return normalized.startsWith('merchant/') ||
            normalized.startsWith('packages/models/') ||
            normalized.startsWith('packages/validators/') ||
            normalized.startsWith('packages/api_client/') ||
            normalized.startsWith('packages/client_repositories/');

      case DeployComponent.customer:
        return normalized.startsWith('customer/') ||
            normalized.startsWith('packages/models/') ||
            normalized.startsWith('packages/validators/') ||
            normalized.startsWith('packages/api_client/') ||
            normalized.startsWith('packages/client_repositories/');

      case DeployComponent.terminal:
        return normalized.startsWith('terminal/') ||
            normalized.startsWith('packages/models/') ||
            normalized.startsWith('packages/validators/') ||
            normalized.startsWith('packages/api_client/') ||
            normalized.startsWith('packages/client_repositories/');

      case DeployComponent.landing:
        return normalized.startsWith('landing/');

      case DeployComponent.migrations:
        return normalized.startsWith('backend/migrations/');
    }
  }
}
