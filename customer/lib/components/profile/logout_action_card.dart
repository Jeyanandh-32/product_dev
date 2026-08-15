import 'package:customer/signals/customer_auth_signal.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/jaspr_lucide.dart';

class LogoutActionCard extends StatelessComponent {
  const LogoutActionCard({super.key});

  @override
  Component build(BuildContext context) {
    return div(
      classes:
          'bg-gray-50 rounded-3xl border border-gray-200/80 p-6 flex items-center justify-between gap-4',
      [
        div(classes: 'flex flex-col gap-0.5', [
          span(classes: 'text-sm font-extrabold text-black', [
            .text('Sign out of your account'),
          ]),
          span(classes: 'text-xs text-gray-500 font-medium', [
            .text(
              'You can sign back in anytime using your mobile number & PIN.',
            ),
          ]),
        ]),
        button(
          classes:
              'px-4 py-2.5 rounded-2xl bg-red-50 hover:bg-red-600 text-red-600 hover:text-white font-bold text-xs transition-all border border-red-200/80 cursor-pointer flex items-center gap-1.5 active:scale-95 shrink-0',
          onClick: logoutCustomer,
          [
            LogOut(classes: 'w-4 h-4'),
            .text('Logout'),
          ],
        ),
      ],
    );
  }
}
