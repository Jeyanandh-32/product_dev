import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/components/cart/cart_active_reward_badge.dart';
import 'package:terminal/components/cart/redeem_bottle_reward_dialog.dart';
import 'package:terminal/signals/bottle_return_signal.dart';
import 'package:terminal/signals/cart_signal.dart';
import 'package:terminal/theme/terminal_colors.dart';

/// Premium row for Bottle Return voucher redemption in Cart.
class CartBottleCreditSection extends StatelessWidget {
  const CartBottleCreditSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SignalBuilder(
      builder: (context) {
        final cfg = bottleReturnConfigSignal.value;
        if (cfg == null || !cfg.isEnabled) return const SizedBox.shrink();

        final hasItems = cartSignal.value.items.isNotEmpty;
        final appliedCredit = appliedBottleCreditSignal.value;
        final appliedCoupon = appliedPhysicalCouponSignal.value;
        final hasActiveReward = appliedCredit > 0 || appliedCoupon != null;
        final totalDiscount =
            (appliedCredit > 0 ? appliedCredit : 0.0) +
            (appliedCoupon?.amount ?? 0.0);

        final activeBtnStyle = BoxStyler()
            .height(34)
            .paddingX(12)
            .borderRadiusAll(const Radius.circular(8))
            .color(const Color(0xFFF8FAFC))
            .borderAll(color: const Color(0xFFCBD5E1), width: 1.2)
            .alignment(Alignment.center)
            .onHovered(
              BoxStyler()
                  .color(TerminalColors.primary)
                  .borderAll(color: TerminalColors.primary, width: 1.2),
            );
        final disabledBtnStyle = BoxStyler()
            .height(34)
            .paddingX(12)
            .borderRadiusAll(const Radius.circular(8))
            .color(const Color(0xFFF8FAFC))
            .borderAll(color: const Color(0xFFE2E8F0), width: 1.2)
            .alignment(Alignment.center);
        final activeIconStyle = IconStyler()
            .size(13)
            .color(const Color(0xFF0F172A))
            .onHovered(IconStyler().color(const Color(0xFFFFFFFF)));
        final disabledIconStyle = IconStyler()
            .size(13)
            .color(const Color(0xFF94A3B8));
        final activeTextStyle = TextStyler()
            .fontSize(12.5)
            .fontWeight(.w800)
            .color(const Color(0xFF0F172A))
            .onHovered(TextStyler().color(const Color(0xFFFFFFFF)));
        final disabledTextStyle = TextStyler()
            .fontSize(12.5)
            .fontWeight(.w800)
            .color(const Color(0xFF94A3B8));

        return LayoutBuilder(
          builder: (context, constraints) {
            final isCompact = constraints.maxWidth < 265;

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      FLucideIcons.ticket,
                      size: 15,
                      color: Color(0xFF16A34A),
                    ),
                    const Gap(6),
                    Text(
                      isCompact ? 'Voucher' : 'Bottle Voucher',
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
                if (hasActiveReward)
                  CartActiveRewardBadge(
                    totalDiscount: totalDiscount,
                    appliedCredit: appliedCredit,
                    appliedCoupon: appliedCoupon,
                  )
                else
                  MouseRegion(
                    cursor: hasItems
                        ? SystemMouseCursors.click
                        : SystemMouseCursors.basic,
                    child: PressableBox(
                      onPress: hasItems
                          ? () => RedeemBottleRewardDialog.show(context)
                          : null,
                      style: hasItems ? activeBtnStyle : disabledBtnStyle,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          StyledIcon(
                            icon: FLucideIcons.plus,
                            style: hasItems
                                ? activeIconStyle
                                : disabledIconStyle,
                          ),
                          const Gap(5),
                          StyledText(
                            isCompact ? 'Redeem' : 'Redeem Voucher',
                            style: hasItems
                                ? activeTextStyle
                                : disabledTextStyle,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }
}
