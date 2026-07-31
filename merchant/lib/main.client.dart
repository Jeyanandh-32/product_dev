/// The entrypoint for the **client** app.
///
/// This file is compiled to javascript and executed on the client when loading the page.
library;

// Client-specific Jaspr import.
import 'package:jaspr/client.dart';

// Imports the [App] component.
import 'app.dart';
import 'config/api_client.dart';
import 'providers/auth_provider.dart';

void main() async {
  initMerchantDio();
  await initAuthSignal();
  // Attaches the [App] component to the <body> of the page.
  runApp(const App());
}
