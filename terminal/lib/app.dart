import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:terminal/providers/router_provider.dart';
import 'package:terminal/theme.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return ShadApp.router(
      title: 'POS Terminal',
      debugShowCheckedModeBanner: false,
      theme: terminalLightTheme,
      darkTheme: terminalDarkTheme,
      themeMode: ThemeMode.light,
      routerConfig: router,
    );
  }
}
