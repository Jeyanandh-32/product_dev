import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadApp(
      title: 'POS Terminal',
      debugShowCheckedModeBanner: false,
      theme: ShadThemeData(
        brightness: Brightness.light,
        colorScheme: const ShadZincColorScheme.light(
          background: Color(0xFFFFFFFF),
          foreground: Color(0xFF0F172A),
          card: Color(0xFFFFFFFF),
          cardForeground: Color(0xFF0F172A),
          popover: Color(0xFFFFFFFF),
          popoverForeground: Color(0xFF0F172A),
          primary: Color(0xFF191645),
          primaryForeground: Color(0xFFFFFFFF),
          secondary: Color(0xFFF1F5F9),
          secondaryForeground: Color(0xFF0F172A),
          muted: Color(0xFFF8FAFC),
          mutedForeground: Color(0xFF64748B),
          accent: Color(0xFF43C6AC),
          accentForeground: Color(0xFF191645),
          destructive: Color(0xFFDC2626),
          destructiveForeground: Color(0xFFFFFFFF),
          border: Color(0xFFCBD5E1),
          input: Color(0xFFCBD5E1),
          ring: Color(0xFF43C6AC),
        ),
      ),
      darkTheme: ShadThemeData(
        brightness: Brightness.dark,
        colorScheme: const ShadZincColorScheme.dark(),
      ),
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
