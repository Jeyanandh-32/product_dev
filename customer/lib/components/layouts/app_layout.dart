import 'package:customer/components/signal_component.dart';
import 'package:customer/signals/customer_auth_signal.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/jaspr_lucide.dart' hide List, Map, Router;
import 'package:jaspr_router/jaspr_router.dart';

class AppLayout extends SignalComponent {
  const AppLayout({super.key, required this.child});

  final Component child;

  @override
  SignalState<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends SignalState<AppLayout> {
  @override
  Component buildSignal(BuildContext context) {
    final customer = customerAuthSignal.value.value;

    return div(
      classes: 'min-h-screen bg-white text-gray-900 flex flex-col font-sans selection:bg-gray-900 selection:text-white',
      [
        // Sleek Ultra-Minimalist Top Header Navigation Bar
        header(
          classes: 'bg-white/80 backdrop-blur-md border-b border-gray-200 sticky top-0 z-40 px-6 py-4 transition-all',
          [
            div(
              classes: 'max-w-6xl mx-auto flex items-center justify-between',
              [
                // Brand Logo: Finch Icon Badge + Dancing Script Finch
                button(
                  classes: 'cursor-pointer border-0 bg-transparent p-0 flex items-center gap-2.5 text-left group select-none',
                  onClick: () => Router.of(context).push('/'),
                  [
                    div(
                      classes: 'w-8 h-8 rounded-xl overflow-hidden shadow-2xs border border-gray-200 group-hover:scale-105 transition-transform duration-200 shrink-0',
                      [
                        img(
                          src: 'images/finch_app_icon_square.png',
                          width: 32,
                          height: 32,
                          classes: 'w-full h-full object-cover',
                        ),
                      ],
                    ),
                    span(
                      classes: 'font-script text-[26px] font-bold text-slate-900 leading-none group-hover:opacity-85 transition-opacity',
                      [.text('Finch')],
                    ),
                  ],
                ),

                // Right Actions: My Orders, Customer Avatar & Logout Button
                div(classes: 'flex items-center gap-2.5', [
                  button(
                    classes: 'flex items-center gap-2 px-3 py-1.5 rounded-full bg-gray-100 hover:bg-gray-200 text-gray-800 font-semibold text-xs transition-all cursor-pointer border border-gray-200/80 active:scale-95',
                    onClick: () => Router.of(context).push('/orders'),
                    [
                      Package(classes: 'w-3.5 h-3.5 text-gray-600'),
                      .text('My Orders'),
                    ],
                  ),

                  // Customer Initials Pill (Clickable -> Account Profile) OR Sign In Button
                  if (customer != null)
                    button(
                      classes: 'w-8 h-8 rounded-full bg-gray-100 hover:bg-gray-900 hover:text-white text-black font-bold text-xs flex items-center justify-center border border-gray-200/80 transition-all cursor-pointer active:scale-95 select-none p-0',
                      attributes: {'title': 'Profile'},
                      onClick: () => Router.of(context).push('/profile'),
                      [
                        .text(
                          customer.name.isNotEmpty
                              ? customer.name[0].toUpperCase()
                              : 'C',
                        ),
                      ],
                    )
                  else
                    button(
                      classes: 'flex items-center gap-1.5 px-3.5 py-1.5 rounded-full bg-[#0B132B] hover:bg-[#1C2541] text-white font-semibold text-xs transition-all cursor-pointer border-0 active:scale-95 shadow-2xs',
                      onClick: () => Router.of(context).push('/login'),
                      [
                        User(classes: 'w-3.5 h-3.5 text-white'),
                        .text('Sign In'),
                      ],
                    ),
                ]),
              ],
            ),
          ],
        ),

        // Main Route Content Container
        main_(
          classes:
              'flex-1 max-w-6xl w-full mx-auto p-4 md:p-6 flex flex-col gap-6',
          [
            component.child,
          ],
        ),
      ],
    );
  }
}
