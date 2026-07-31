import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:styled_divider/styled_divider.dart';
import 'package:terminal/exceptions/api_exception.dart';
import 'package:terminal/providers/auth_provider.dart';
import 'package:terminal/providers/cart_provider.dart';
import 'package:terminal/providers/ui_providers.dart';

class CartSummary extends ConsumerStatefulWidget {
  const CartSummary({super.key});

  @override
  ConsumerState<CartSummary> createState() => _CartSummaryState();
}

class _CartSummaryState extends ConsumerState<CartSummary> {
  bool _isCheckingOut = false;

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider);
    final paymentMode = ref.watch(paymentModeProvider);
    final authState = ref.watch(authProvider);
    final terminal = authState.value;

    return ColumnBox(
      style: FlexBoxStyler().paddingTop(16),
      children: [
        StyledText(
          'Summary',
          style: TextStyler().fontSize(16).fontWeight(.w600),
        ),
        const Gap(16),
        _summaryTile(title: 'Total No of Items', value: '${cart.noOfItems}'),
        const Gap(4),
        _summaryTile(
          title: 'Total Order Quantity',
          value: '${cart.orderQuantity}',
        ),
        const Gap(4),
        _summaryTile(
          title: 'Order Summary',
          value: '₹${cart.subtotal.toStringAsFixed(2)}',
        ),
        const Gap(4),
        _summaryTile(
          title: 'Total Tax',
          value: '₹${cart.taxTotal.toStringAsFixed(2)}',
        ),
        const Gap(4),
        const StyledDivider(lineStyle: DividerLineStyle.dashed),
        const Gap(4),
        RowBox(
          style: FlexBoxStyler().mainAxisAlignment(.spaceBetween),
          children: [
            StyledText(
              'Total Amount',
              style: TextStyler().fontSize(16).fontWeight(.bold),
            ),
            StyledText(
              '₹${cart.grandTotal.toStringAsFixed(2)}',
              style: TextStyler().fontSize(16).fontWeight(.bold),
            ),
          ],
        ),
        const Gap(4),
        const StyledDivider(lineStyle: DividerLineStyle.dashed),
        const Gap(16),
        RowBox(
          style: FlexBoxStyler()
              .mainAxisAlignment(MainAxisAlignment.spaceBetween)
              .crossAxisAlignment(CrossAxisAlignment.center),
          children: [
            StyledText(
              'Payment Mode',
              style: TextStyler()
                  .fontSize(14)
                  .fontWeight(.w500)
                  .color(Colors.grey.shade700),
            ),
            ShadRadioGroup<String>(
              initialValue: paymentMode,
              onChanged: _isCheckingOut
                  ? null
                  : (value) {
                      if (value != null) {
                        ref
                            .read(paymentModeProvider.notifier)
                            .setPaymentMode(value);
                      }
                    },
              axis: Axis.horizontal,
              spacing: 16,
              items: [
                ShadRadio(
                  value: 'cash',
                  label: StyledText('Cash', style: TextStyler().fontSize(14)),
                ),
                ShadRadio(
                  value: 'upi',
                  label: StyledText('UPI', style: TextStyler().fontSize(14)),
                ),
              ],
            ),
          ],
        ),
        const Gap(24),
        ShadButton(
          width: double.infinity,
          height: 44,
          enabled: !_isCheckingOut && cart.items.isNotEmpty && terminal != null,
          onPressed: () async {
            if (terminal == null) return;

            setState(() {
              _isCheckingOut = true;
            });

            try {
              final order = await ref
                  .read(cartProvider.notifier)
                  .checkout(
                    storeId: terminal.storeId,
                    paymentMethod: paymentMode,
                  );

              if (!context.mounted) return;
              ShadToaster.of(context).show(
                ShadToast(
                  description: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(LucideIcons.check, size: 20),
                      const Gap(8),
                      StyledText(
                        'Order no:${order.billNo} placed successfully!',
                      ),
                    ],
                  ),
                  alignment: Alignment.topCenter,
                  duration: const Duration(seconds: 4),
                ),
              );
            } catch (e) {
              if (!context.mounted) return;
              final message = e is ApiException
                  ? e.message
                  : 'Failed to place order. Please try again.';
              ShadToaster.of(context).show(
                ShadToast.destructive(
                  description: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(LucideIcons.x, color: Colors.white, size: 20),
                      const Gap(8),
                      Text(message),
                    ],
                  ),
                  alignment: Alignment.topCenter,
                  duration: const Duration(seconds: 4),
                ),
              );
            } finally {
              if (mounted) {
                setState(() {
                  _isCheckingOut = false;
                });
              }
            }
          },
          child: _isCheckingOut
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : StyledText('Save & Print', style: TextStyler().fontSize(16)),
        ),
      ],
    );
  }

  RowBox _summaryTile({required String title, required String value}) {
    return RowBox(
      style: FlexBoxStyler().mainAxisAlignment(.spaceBetween),
      children: [
        StyledText(title, style: TextStyler().color(Colors.grey.shade600)),
        StyledText(value, style: TextStyler().fontWeight(.bold)),
      ],
    );
  }
}
