import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:terminal/app.dart';
import 'package:terminal/providers/auth_provider.dart';
import 'package:terminal/router.dart';

void main() {
  final container = ProviderContainer();

  container.listen(
    authProvider,
    (previous, next) {
      routerListenable.refresh();
    },
    fireImmediately: true,
  );

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const MyApp(),
    ),
  );
}
