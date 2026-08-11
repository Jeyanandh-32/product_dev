/// The entrypoint for the **client** app.
library;

import 'package:customer/signals/customer_auth_signal.dart';
import 'package:jaspr/client.dart';

import 'app.dart';
import 'config/api_client.dart';

void main() {
  initCustomerDio();
  initCustomerAuthSignal();
  runApp(const App());
}
