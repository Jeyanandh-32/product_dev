import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';
import 'package:models/models.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/components/inventory/modals/bottle_reward_customer_balance_card.dart';
import 'package:terminal/components/inventory/modals/bottle_reward_mode_selection_cards.dart';
import 'package:terminal/signals/bottle_return_signal.dart';
import 'package:terminal/signals/cart_signal.dart';

/// Modal dialog prompting the cashier to select Digital vs Physical reward mode with live balance lookup.
class BottleRewardModeDialog extends StatefulWidget {
  const BottleRewardModeDialog({super.key, this.initialPhone});
  final String? initialPhone;

  static Future<({BottleRewardMode mode, String? phone})?> show(
    BuildContext context, {
    String? initialPhone,
  }) => showDialog<({BottleRewardMode mode, String? phone})>(
    context: context,
    barrierDismissible: false,
    builder: (context) => BottleRewardModeDialog(initialPhone: initialPhone),
  );

  @override
  State<BottleRewardModeDialog> createState() => _BottleRewardModeDialogState();
}

class _BottleRewardModeDialogState extends State<BottleRewardModeDialog> {
  late final TextEditingController _phoneController;
  BottleRewardMode _selectedMode = BottleRewardMode.digital;
  bool _applyCredit = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    final initial = widget.initialPhone ?? activeCustomerPhoneSignal.value ?? '';
    _phoneController = TextEditingController(text: initial);
    if (initial.length == 10) BottleReturnActions.checkCustomerBalance(initial);
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _onPhoneChanged(String val) {
    setState(() => _errorMessage = null);
    if (val.trim().length == 10) BottleReturnActions.checkCustomerBalance(val.trim());
    if (val.trim().isEmpty) BottleReturnActions.checkCustomerBalance('');
  }

  void _handleConfirm() {
    final phone = _phoneController.text.trim();
    if (_selectedMode == BottleRewardMode.digital && (phone.isEmpty || phone.length < 10)) {
      setState(() => _errorMessage = 'Please enter a valid 10-digit mobile number.');
      return;
    }
    final bal = customerPhoneBottleBalanceSignal.value;
    if (_selectedMode == BottleRewardMode.digital && _applyCredit && bal > 0) {
      final cartSubtotal = cartSignal.value.subtotal.toInt();
      appliedBottleCreditSignal.value = min(bal, cartSubtotal);
      CartController.recalculateTotals();
    }
    Navigator.of(context).pop((mode: _selectedMode, phone: _selectedMode == BottleRewardMode.digital ? phone : null));
  }

  @override
  Widget build(BuildContext context) {
    final cancelBtnStyle = BoxStyler().height(42).paddingX(18).borderRadiusAll(const Radius.circular(10)).color(const Color(0xFFF1F5F9)).alignment(Alignment.center).onHovered(BoxStyler().color(const Color(0xFFE2E8F0)));
    final continueBtnStyle = BoxStyler().height(42).paddingX(22).borderRadiusAll(const Radius.circular(10)).color(const Color(0xFF16A34A)).alignment(Alignment.center).onHovered(BoxStyler().color(const Color(0xFF15803D)));

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: 440,
        padding: const EdgeInsets.all(24),
        child: SignalBuilder(
          builder: (context) {
            final rewardAmt = bottleReturnConfigSignal.value?.rewardAmountInRupees ?? 10;
            final available = customerPhoneBottleBalanceSignal.value;
            final isChecking = isCheckingBottleCreditSignal.value;
            final cartSubtotal = cartSignal.value.subtotal.toInt();
            final toApply = min(available, cartSubtotal);
            final baseGrandTotal = cartSignal.value.grandTotal + appliedBottleCreditSignal.value;
            final updatedPayable = max(0.0, baseGrandTotal - toApply);

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(children: [
                  Icon(FLucideIcons.recycle, size: 22, color: Color(0xFF16A34A)),
                  Gap(10),
                  Text('Bottle Return Reward Mode', style: TextStyle(fontSize: 16.5, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
                ]),
                const Gap(12),
                Text('Select how customer should receive the ₹$rewardAmt bottle return reward.', style: const TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                const Gap(16),
                BottleRewardModeSelectionCards(selectedMode: _selectedMode, onSelectMode: (mode) => setState(() { _selectedMode = mode; _errorMessage = null; })),
                if (_selectedMode == BottleRewardMode.digital) ...[
                  const Gap(16),
                  Container(
                    height: 46,
                    decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(12), border: Border.all(color: _errorMessage != null ? const Color(0xFFEF4444) : const Color(0xFFCBD5E1))),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    alignment: Alignment.center,
                    child: TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      onChanged: _onPhoneChanged,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
                      decoration: const InputDecoration(isDense: true, border: InputBorder.none, hintText: 'Customer Mobile Number (10 digits)'),
                    ),
                  ),
                  if (isChecking) const Padding(padding: EdgeInsets.only(top: 8), child: Center(child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF16A34A)))))
                  else if (available > 0) ...[
                    const Gap(10),
                    BottleRewardCustomerBalanceCard(
                      available: available,
                      toApply: toApply,
                      isApplied: _applyCredit,
                      originalTotal: baseGrandTotal,
                      updatedTotal: updatedPayable,
                      onToggleApply: () => setState(() => _applyCredit = !_applyCredit),
                    ),
                  ],
                  if (_errorMessage != null) ...[const Gap(6), Text(_errorMessage!, style: const TextStyle(fontSize: 12, color: Color(0xFFEF4444)))],
                ],
                const Gap(24),
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  MouseRegion(cursor: SystemMouseCursors.click, child: PressableBox(onPress: () => Navigator.of(context).pop(), style: cancelBtnStyle, child: const Text('Cancel', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF475569))))),
                  const Gap(10),
                  MouseRegion(cursor: SystemMouseCursors.click, child: PressableBox(onPress: _handleConfirm, style: continueBtnStyle, child: const Text('Continue', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: Color(0xFFFFFFFF))))),
                ]),
              ],
            );
          },
        ),
      ),
    );
  }
}
