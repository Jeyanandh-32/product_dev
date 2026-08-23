import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';
import 'package:terminal/signals/bottle_return_signal.dart';
import 'package:terminal/utils/terminal_toast.dart';

/// Clean, focused modal dialog for redeeming paper bottle return vouchers in cart.
class RedeemBottleRewardDialog extends StatefulWidget {
  const RedeemBottleRewardDialog({super.key});

  static Future<void> show(BuildContext context) => showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (_) => const RedeemBottleRewardDialog(),
      );

  @override
  State<RedeemBottleRewardDialog> createState() => _RedeemBottleRewardDialogState();
}

class _RedeemBottleRewardDialogState extends State<RedeemBottleRewardDialog> {
  final TextEditingController _couponController = TextEditingController();
  String? _errorMessage;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  Future<void> _handleApply() async {
    final code = _couponController.text.trim().toUpperCase();
    if (code.isEmpty) {
      setState(() => _errorMessage = 'Please enter a voucher code.');
      return;
    }
    setState(() => _isSubmitting = true);
    try {
      final ok = await BottleReturnActions.applyPhysicalCoupon(code);
      if (!mounted) return;
      if (ok) {
        Navigator.of(context).pop();
        TerminalToast.showSuccess(
          context: context,
          title: 'Voucher Applied',
          description: 'Code $code applied successfully.',
        );
      } else {
        setState(() => _errorMessage = 'Code $code is invalid, expired, or already redeemed.');
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cancelBtnStyle = BoxStyler()
        .height(42)
        .paddingX(18)
        .borderRadiusAll(const Radius.circular(10))
        .color(const Color(0xFFF1F5F9))
        .alignment(Alignment.center)
        .onHovered(BoxStyler().color(const Color(0xFFE2E8F0)));

    final applyBtnStyle = BoxStyler()
        .height(42)
        .paddingX(22)
        .borderRadiusAll(const Radius.circular(10))
        .color(const Color(0xFF16A34A))
        .alignment(Alignment.center)
        .onHovered(BoxStyler().color(const Color(0xFF15803D)));

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: 440,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(children: [
              Icon(FLucideIcons.ticket, size: 22, color: Color(0xFF16A34A)),
              Gap(10),
              Text('Redeem Paper Voucher', style: TextStyle(fontSize: 16.5, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
            ]),
            const Gap(8),
            const Text('Enter the voucher code to apply discount directly to this cart.', style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
            const Gap(16),
            Container(
              height: 46,
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _errorMessage != null ? const Color(0xFFEF4444) : const Color(0xFFCBD5E1)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              alignment: Alignment.center,
              child: TextField(
                controller: _couponController,
                textCapitalization: TextCapitalization.characters,
                onChanged: (_) => setState(() => _errorMessage = null),
                onSubmitted: (_) => _handleApply(),
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
                decoration: const InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  hintText: 'Enter Voucher Code (e.g. BTL123456)',
                  hintStyle: TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                ),
              ),
            ),
            if (_errorMessage != null) ...[const Gap(6), Text(_errorMessage!, style: const TextStyle(fontSize: 12, color: Color(0xFFEF4444)))],
            const Gap(24),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: PressableBox(
                  onPress: () => Navigator.of(context).pop(),
                  style: cancelBtnStyle,
                  child: const Text('Cancel', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF475569))),
                ),
              ),
              const Gap(10),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: PressableBox(
                  onPress: _isSubmitting ? null : _handleApply,
                  style: applyBtnStyle,
                  child: Text(_isSubmitting ? 'Checking...' : 'Apply Voucher', style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: Color(0xFFFFFFFF))),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
