import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/components/account/account_hero_banner.dart';
import 'package:terminal/components/account/merchant_info_card.dart';
import 'package:terminal/components/account/store_info_card.dart';
import 'package:terminal/components/account/subscription_info_card.dart';
import 'package:terminal/components/account/terminal_info_card.dart';
import 'package:terminal/signals/account_signal.dart';
import 'package:terminal/signals/auth_signal.dart';
import 'package:terminal/theme/terminal_colors.dart';
import 'package:terminal/utils/responsive_extensions.dart';

/// Terminal device and merchant account view with premium layout and cards.
class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SignalBuilder(
      builder: (context) {
        final terminal = authSignal.value.value;
        final accountData = terminalAccountSignal.value.value;

        if (terminal == null) {
          return const Center(child: Text('Terminal not authenticated.'));
        }

        final store = accountData?.store;
        final merchant = accountData?.merchant;
        final subscription = accountData?.subscription;
        final isMobile = context.isMobile;

        return Container(
          color: TerminalColors.pageBackground,
          child: ListView(
            padding: EdgeInsets.all(isMobile ? 10 : 16),
            children: [
              AccountHeroBanner(
                terminal: terminal,
                store: store,
                merchant: merchant,
              ),
              Gap(isMobile ? 12 : 16),
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth >= 768;
                  if (isWide) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              TerminalInfoCard(terminal: terminal),
                              const Gap(16),
                              StoreInfoCard(store: store),
                            ],
                          ),
                        ),
                        const Gap(16),
                        Expanded(
                          child: Column(
                            children: [
                              SubscriptionInfoCard(
                                store: store,
                                subscription: subscription,
                              ),
                              const Gap(16),
                              MerchantInfoCard(merchant: merchant),
                            ],
                          ),
                        ),
                      ],
                    );
                  }

                  return Column(
                    children: [
                      TerminalInfoCard(terminal: terminal),
                      Gap(isMobile ? 12 : 16),
                      StoreInfoCard(store: store),
                      Gap(isMobile ? 12 : 16),
                      SubscriptionInfoCard(
                        store: store,
                        subscription: subscription,
                      ),
                      Gap(isMobile ? 12 : 16),
                      MerchantInfoCard(merchant: merchant),
                    ],
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
