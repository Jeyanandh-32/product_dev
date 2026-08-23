import 'package:api_client/api_client.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';
import 'package:models/models.dart';
import 'package:terminal/components/inventory/modals/accept_bottle_returns_header.dart';
import 'package:terminal/components/inventory/modals/accept_bottle_returns_input_row.dart';
import 'package:terminal/components/inventory/modals/accept_bottle_returns_summary_card.dart';
import 'package:terminal/components/inventory/modals/accept_bottle_returns_token_list.dart';
import 'package:terminal/signals/auth_signal.dart';
import 'package:terminal/signals/bottle_return_signal.dart';
import 'package:terminal/utils/terminal_toast.dart';

/// Modal dialog allowing the cashier to manually accept bottle returns when IoT hardware is offline.
class AcceptBottleReturnsDialog extends StatefulWidget {
  const AcceptBottleReturnsDialog({super.key});

  /// Shows manual bottle returns dialog.
  static Future<void> show(BuildContext context) =>
      showDialog(context: context, builder: (_) => const AcceptBottleReturnsDialog());

  @override
  State<AcceptBottleReturnsDialog> createState() => _AcceptBottleReturnsDialogState();
}

class _AcceptBottleReturnsDialogState extends State<AcceptBottleReturnsDialog> {
  final TextEditingController _tokenInputController = TextEditingController();
  final List<String> _scannedTokens = [];
  bool _isProcessing = false;

  @override
  void dispose() {
    _tokenInputController.dispose();
    super.dispose();
  }

  void _handleAddToken() {
    final t = _tokenInputController.text.trim().toUpperCase();
    if (t.isNotEmpty && !_scannedTokens.contains(t)) {
      setState(() => _scannedTokens.add(t));
      _tokenInputController.clear();
    }
  }

  Future<void> _handleProcessReturn() async {
    if (_scannedTokens.isEmpty) return;
    final merchantId = authSignal.value.value?.merchantId;
    final storeId = authSignal.value.value?.storeId;
    if (merchantId == null || storeId == null) return;

    setState(() => _isProcessing = true);
    try {
      final res = await dio.post(
        ApiEndpoints.bottleReturnsIotScan,
        data: {'tokenStrings': _scannedTokens, 'storeId': storeId, 'merchantId': merchantId},
      );
      if (!mounted) return;
      final result = BottleReturnSessionResult.fromJson(res.data['data']['result'] as Map<String, dynamic>);
      Navigator.of(context).pop();
      TerminalToast.showSuccess(context: context, title: 'Return Complete', description: result.message);
    } catch (e) {
      if (mounted) TerminalToast.showError(context: context, title: 'Return Failed', description: e.toString());
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final rewardAmt = bottleReturnConfigSignal.value?.rewardAmountInRupees ?? 10;
    final totalValue = _scannedTokens.length * rewardAmt;
    final hasTokens = _scannedTokens.isNotEmpty;

    final cancelBtnStyle = BoxStyler().height(42).paddingX(18).borderRadiusAll(const Radius.circular(10)).color(const Color(0xFFF1F5F9)).alignment(Alignment.center).onHovered(BoxStyler().color(const Color(0xFFE2E8F0)));
    final activeCompleteBtnStyle = BoxStyler().height(42).paddingX(20).borderRadiusAll(const Radius.circular(10)).color(const Color(0xFF16A34A)).alignment(Alignment.center).onHovered(BoxStyler().color(const Color(0xFF15803D)));
    final disabledCompleteBtnStyle = BoxStyler().height(42).paddingX(20).borderRadiusAll(const Radius.circular(10)).color(const Color(0xFFCBD5E1)).alignment(Alignment.center);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AcceptBottleReturnsHeader(onClose: () => Navigator.of(context).pop()),
            const Gap(16),
            if (hasTokens) ...[
              AcceptBottleReturnsSummaryCard(
                bottleCount: _scannedTokens.length,
                rewardPerBottle: rewardAmt,
                onClearAll: () => setState(_scannedTokens.clear),
              ),
              const Gap(14),
            ],
            AcceptBottleReturnsInputRow(controller: _tokenInputController, onAdd: _handleAddToken),
            const Gap(14),
            AcceptBottleReturnsTokenList(
              scannedTokens: _scannedTokens,
              rewardPerBottle: rewardAmt,
              onRemove: (tok) => setState(() => _scannedTokens.remove(tok)),
            ),
            const Gap(20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: PressableBox(onPress: () => Navigator.of(context).pop(), style: cancelBtnStyle, child: const Text('Cancel', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF475569)))),
                ),
                const Gap(10),
                MouseRegion(
                  cursor: _isProcessing || !hasTokens ? SystemMouseCursors.basic : SystemMouseCursors.click,
                  child: PressableBox(
                    onPress: _isProcessing || !hasTokens ? null : _handleProcessReturn,
                    style: hasTokens ? activeCompleteBtnStyle : disabledCompleteBtnStyle,
                    child: Text(
                      _isProcessing ? 'Processing...' : (hasTokens ? 'Complete Return (₹${totalValue.toStringAsFixed(0)})' : 'Complete Return'),
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFFFFFFFF)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
