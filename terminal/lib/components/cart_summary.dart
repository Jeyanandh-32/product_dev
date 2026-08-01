import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';
import 'package:models/models.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:styled_divider/styled_divider.dart';
import 'package:terminal/exceptions/api_exception.dart';
import 'package:terminal/signals/auth_signal.dart';
import 'package:terminal/signals/cart_signal.dart';

class CartSummary extends StatefulWidget {
  const CartSummary({super.key});

  @override
  State<CartSummary> createState() => _CartSummaryState();
}

class _CartSummaryState extends State<CartSummary> {
  bool _isCheckingOut = false;
  final TextEditingController _discountController = TextEditingController();

  @override
  void dispose() {
    _discountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SignalBuilder(
      builder: (context) {
        final cart = cartSignal.value;
        final paymentMode = paymentModeSignal.value;
        final authState = authSignal.value;
        final terminal = authState.value;

        return ColumnBox(
          style: FlexBoxStyler()
              .paddingTop(16)
              .crossAxisAlignment(CrossAxisAlignment.start),
          children: [
            StyledText(
              'Summary',
              style: TextStyler().fontSize(16).fontWeight(.w600),
            ),
            const Gap(16),
            _summaryTile(
              title: 'Total No of Items',
              value: '${cart.noOfItems}',
            ),
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
            if (paymentMode != PaymentMethod.complimentary) ...[
              RowBox(
                style: FlexBoxStyler()
                    .mainAxisAlignment(MainAxisAlignment.spaceBetween)
                    .crossAxisAlignment(CrossAxisAlignment.center),
                children: [
                  StyledText(
                    'Discount (₹)',
                    style: TextStyler().color(Colors.grey.shade600),
                  ),
                  SizedBox(
                    width: 100,
                    height: 32,
                    child: ShadInput(
                      controller: _discountController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      placeholder: const Text('0.00'),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      onChanged: (val) {
                        final parsed = double.tryParse(val) ?? 0.0;
                        CartController.setDiscount(parsed);
                      },
                    ),
                  ),
                ],
              ),
              const Gap(4),
            ],
            if (cart.discountTotal > 0) ...[
              _summaryTile(
                title: 'Total Discount',
                value: '-₹${cart.discountTotal.toStringAsFixed(2)}',
              ),
              const Gap(4),
            ],
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
            ColumnBox(
              style: FlexBoxStyler()
                  .crossAxisAlignment(CrossAxisAlignment.start)
                  .width(double.infinity),
              children: [
                StyledText(
                  'Payment Mode',
                  style: TextStyler()
                      .fontSize(14)
                      .fontWeight(.w500)
                      .color(Colors.grey.shade700),
                ),
                const Gap(8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: ShadRadioGroup<PaymentMethod>(
                    initialValue: paymentMode,
                    onChanged: _isCheckingOut
                        ? null
                        : (value) {
                            if (value != null &&
                                value != paymentModeSignal.value) {
                              Future.microtask(() {
                                paymentModeSignal.value = value;
                                CartController.setDiscount(
                                  discountInputSignal.value,
                                );
                              });
                            }
                          },
                    axis: Axis.horizontal,
                    spacing: 12,
                    items: [
                      ShadRadio(
                        value: PaymentMethod.cash,
                        label: StyledText(
                          'Cash',
                          style: TextStyler().fontSize(14),
                        ),
                      ),
                      ShadRadio(
                        value: PaymentMethod.upi,
                        label: StyledText(
                          'UPI',
                          style: TextStyler().fontSize(14),
                        ),
                      ),
                      ShadRadio(
                        value: PaymentMethod.complimentary,
                        label: StyledText(
                          'Free/Complimentary',
                          style: TextStyler().fontSize(14),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Gap(24),
            ShadButton(
              width: double.infinity,
              height: 44,
              enabled:
                  !_isCheckingOut && cart.items.isNotEmpty && terminal != null,
              onPressed: () async {
                if (terminal == null) return;

                setState(() {
                  _isCheckingOut = true;
                });

                try {
                  final order = await CartController.checkout(
                    storeId: terminal.storeId,
                    paymentMethod: paymentMode,
                  );

                  _discountController.clear();

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
                          const Icon(
                            LucideIcons.x,
                            color: Colors.white,
                            size: 20,
                          ),
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
                  : StyledText(
                      'Save & Print',
                      style: TextStyler().fontSize(16),
                    ),
            ),
          ],
        );
      },
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
