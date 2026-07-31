import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:terminal/app.dart';
import 'package:terminal/config/api_client.dart';

void main() {
  initTerminalDio();
  runApp(const ProviderScope(child: MyApp()));
}
