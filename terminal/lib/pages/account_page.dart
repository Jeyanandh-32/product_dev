import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:terminal/components/components.dart';

/// Terminal device account page using the shared terminal app bar.
class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const FScaffold(
      childPad: false,
      header: TerminalAppBar(),
      child: SizedBox.shrink(),
    );
  }
}
