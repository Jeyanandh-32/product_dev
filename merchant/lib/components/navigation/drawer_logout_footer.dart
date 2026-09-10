import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/generated_icons/log_out.dart';
import 'package:merchant/signals/auth_signal.dart';

/// Bottom logout button component for the merchant sidebar drawer.
class DrawerLogoutFooter extends StatelessComponent {
  const DrawerLogoutFooter({super.key});

  @override
  Component build(BuildContext context) {
    return div(classes: 'w-full px-4 pb-4 mt-auto shrink-0', [
      button(
        classes: 'btn flex items-center justify-center gap-2 w-full h-10 font-bold text-xs bg-red-50 text-red-600 hover:bg-red-600 hover:text-white rounded-xl border border-red-200/80 shadow-2xs transition-all duration-150 cursor-pointer',
        onClick: () => logoutMerchant(),
        [
          LogOut(classes: 'w-4 h-4'),
          .text('Log Out'),
        ],
      ),
    ]);
  }
}
