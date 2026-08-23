import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/components/cart/redeem_bottle_reward_dialog.dart';
import 'package:terminal/signals/bottle_return_signal.dart';
import 'package:terminal/signals/cart_signal.dart';

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
        final totalDiscount = appliedCredit + (appliedCoupon?.amount ?? 0);

        final activeBtnStyle = BoxStyler().height(34).paddingX(12).borderRadiusAll(const Radius.circular(8)).color(const Color(0xFFF8FAFC)).borderAll(color: const Color(0xFFCBD5E1), width: 1.2).alignment(Alignment.center).onHovered(BoxStyler().color(const Color(0xFF0F172A)).borderAll(color: const Color(0xFF0F172A), width: 1.2));
        final disabledBtnStyle = BoxStyler().height(34).paddingX(12).borderRadiusAll(const Radius.circular(8)).color(const Color(0xFFF8FAFC)).borderAll(color: const Color(0xFFE2E8F0), width: 1.2).alignment(Alignment.center);
        final activeIconStyle = IconStyler().size(13).color(const Color(0xFF0F172A)).onHovered(IconStyler().color(const Color(0xFFFFFFFF)));
        final disabledIconStyle = IconStyler().size(13).color(const Color(0xFF94A3B8));
        final activeTextStyle = TextStyler().fontSize(12.5).fontWeight(.w800).color(const Color(0xFF0F172A)).onHovered(TextStyler().color(const Color(0xFFFFFFFF)));
        final disabledTextStyle = TextStyler().fontSize(12.5).fontWeight(.w800).color(const Color(0xFF94A3B8));

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Row(
              children: [
                Icon(FLucideIcons.ticket, size: 15, color: Color(0xFF16A34A)),
                Gap(6),
                Text('Bottle Voucher', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
              ],
            ),
            if (hasActiveReward)
              Container(
                height: 34,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(color: const Color(0xFFF0FDF4), borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFFBBF7D0), width: 1.2)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('-₹${totalDiscount.toStringAsFixed(2)}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF15803D))),
                    const Gap(8),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {
                          if (appliedCredit > 0) BottleReturnActions.removeAvailableCredit();
                          if (appliedCoupon != null) BottleReturnActions.removePhysicalCoupon();
                        },
                        child: Container(padding: const EdgeInsets.all(2), decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(4)), child: const Icon(FLucideIcons.x, size: 13, color: Color(0xFF15803D))),
                      ),
                    ),
                  ],
                ),
              )
            else
              MouseRegion(
                cursor: hasItems ? SystemMouseCursors.click : SystemMouseCursors.basic,
                child: PressableBox(
                  onPress: hasItems ? () => RedeemBottleRewardDialog.show(context) : null,
                  style: hasItems ? activeBtnStyle : disabledBtnStyle,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      StyledIcon(icon: FLucideIcons.plus, style: hasItems ? activeIconStyle : disabledIconStyle),
                      const Gap(5),
                      StyledText('Redeem Voucher', style: hasItems ? activeTextStyle : disabledTextStyle),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
