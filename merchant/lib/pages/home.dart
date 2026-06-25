import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_riverpod/jaspr_riverpod.dart';
import 'package:merchant/components/drawer.dart';
import 'package:merchant/components/header.dart';
import 'package:merchant/providers/ui_providers.dart';

class Home extends StatelessComponent {
  const Home({required this.child, super.key});

  final Component child;

  @override
  Component build(BuildContext context) {
    final isNavOpen = context.watch(navOpenProvider);

    return div(classes: 'h-screen w-full bg-neutral flex', [
      if (isNavOpen)
        div(
          classes: 'fixed inset-0 bg-black/40 z-40 lg:hidden',
          events: {
            'click': (e) =>
                context.read(navOpenProvider.notifier).state = false,
          },
          [],
        ),

      Drawer(),

      div(
        classes: 'w-full lg:pl-64 h-screen flex flex-col overflow-hidden',
        [
          Header(),
          child,
        ],
      ),
    ]);
  }
}
