import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:terminal/signals/router_signal.dart';
import 'package:terminal/theme.dart';

/// Root application widget configuring router, theme, and toast overlays.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: MaterialApp.router(
        title: 'POS Terminal',
        debugShowCheckedModeBanner: false,
        theme: TerminalTheme.light(false).toApproximateMaterialTheme(),
        scrollBehavior: const MaterialScrollBehavior().copyWith(
          scrollbars: false,
        ),
        routerConfig: appRouter,
        builder: (context, child) => FTheme(
          data: TerminalTheme.light(false),
          child: FToaster(
            child: ExcludeSemantics(
              child: Material(
                type: MaterialType.transparency,
                child: child ?? const SizedBox.shrink(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
