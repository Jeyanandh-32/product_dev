import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:terminal/theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadApp(
      title: 'POS Terminal',
      debugShowCheckedModeBanner: false,
      theme: terminalLightTheme,
      darkTheme: terminalDarkTheme,
      themeMode: ThemeMode.light,
      home: const MyHomePage(title: 'POS Terminal Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.primaryForeground,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'You have pushed the button this many times:',
              style: theme.textTheme.muted,
            ),
            const SizedBox(height: 8),
            Text(
              '$_counter',
              style: theme.textTheme.h1.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            ShadButton(
              onPressed: _incrementCounter,
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(LucideIcons.plus, size: 16),
                  SizedBox(width: 8),
                  Text('Increment'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
