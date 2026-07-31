import 'package:flutter/material.dart';
import 'package:terminal/app.dart';
import 'package:terminal/config/api_client.dart';
import 'package:terminal/signals/auth_signal.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initTerminalDio();
  await initAuthSignal();
  runApp(const MyApp());
}
