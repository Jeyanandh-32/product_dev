import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_riverpod/jaspr_riverpod.dart';
import 'package:merchant/components/drawer.dart';
import 'package:merchant/components/header.dart';
import 'package:merchant/providers/ui_providers.dart';
import 'package:merchant/tabs/stores.dart';

class Home extends StatelessComponent {
  const Home({super.key});

  @override
  Component build(BuildContext context) {
    final index = context.watch(indexProvider);
    final isNavOpen = context.watch(navOpenProvider);

    return div(classes: 'h-screen w-full bg-neutral flex', [
      if (isNavOpen)
        div(
          classes: 'fixed inset-0 bg-black/40 z-40 md:hidden',
          events: {
            'click': (e) =>
                context.read(navOpenProvider.notifier).state = false,
          },
          [],
        ),

      Drawer(),

      div(
        classes: 'w-full md:pl-[15%] h-screen flex flex-col overflow-hidden',
        [
          Header(),

          switch (index) {
            // 0 => const Dashboard(),
            3 => const Stores(),
            _ => const Stores(),
          },
        ],
      ),
    ]);
  }
}
