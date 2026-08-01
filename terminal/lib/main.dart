import 'package:flutter/material.dart';
import 'package:terminal/app.dart';
import 'package:terminal/config/api_client.dart';
import 'package:terminal/signals/auth_signal.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initTerminalDio();
  initAuthSignal();
  runApp(const MyApp());
}
