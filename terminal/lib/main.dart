import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:terminal/app.dart';
import 'package:terminal/config/api_client.dart';
import 'package:terminal/signals/auth_signal.dart';

/// Application entry point configuring URL path strategy, network client, and reactive auth.
void main() {
  usePathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  initTerminalDio();
  initAuthSignal();
  runApp(const MyApp());
}
