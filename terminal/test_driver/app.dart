import 'package:flutter_driver/driver_extension.dart';
import 'package:terminal/main.dart' as app;

/// Test driver entrypoint enabling Flutter Driver RPCs on Linux desktop.
void main() {
  enableFlutterDriverExtension();
  app.main();
}
