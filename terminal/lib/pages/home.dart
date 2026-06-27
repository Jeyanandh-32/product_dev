import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:terminal/providers/auth_provider.dart';

class Home extends ConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final terminal = ref.watch(authProvider).value;
    final theme = ShadTheme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('POS Terminal', style: theme.textTheme.h4),
        actions: [
          IconButton(icon: const Icon(LucideIcons.logOut), onPressed: () {}),
          const Gap(8),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(LucideIcons.monitor, size: 64, color: Colors.grey),
              const Gap(16),
              Text(
                terminal?.name ?? 'Loading Terminal...',
                style: theme.textTheme.h2,
              ),
              const Gap(8),
              Text(
                'Code: ${terminal?.code ?? ''}',
                style: theme.textTheme.large.copyWith(color: Colors.grey),
              ),
              const Gap(24),
              ShadButton.outline(
                onPressed: () {
                  ref.read(authProvider.notifier).logout();
                },
                child: const Text('Log Out'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
