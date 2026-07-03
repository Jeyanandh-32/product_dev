import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:styled_divider/styled_divider.dart';
import 'package:terminal/providers/ui_providers.dart';

class Cart extends ConsumerWidget {
  const Cart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ShadTheme.of(context);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final cartStyle = FlexBoxStyler()
        .paddingX(16)
        .paddingY(24)
        .color(Colors.white)
        .width(screenWidth * .40)
        .onMobile(.width(.infinity))
        .borderLeft(color: theme.colorScheme.border);

    return ColumnBox(
      style: cartStyle,
      children: [
        StyledText('Cart', style: TextStyler().fontSize(20).fontWeight(.w600)),
        Divider(endIndent: 48, indent: 48),
        Gap(16),
        Expanded(
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(
              context,
            ).copyWith(scrollbars: false),
            child: SingleChildScrollView(
              child: ColumnBox(
                children: [
                  _cartItem(),
                  StyledDivider(
                    lineStyle: .dashed,
                    thickness: 1.5,
                    indent: 32,
                    endIndent: 32,
                  ),
                  _cartItem(),
                  StyledDivider(
                    lineStyle: .dashed,
                    thickness: 1.5,
                    indent: 32,
                    endIndent: 32,
                  ),
                  _cartItem(),
                  StyledDivider(
                    lineStyle: .dashed,
                    thickness: 1.5,
                    indent: 32,
                    endIndent: 32,
                  ),
                  _cartItem(),
                  StyledDivider(
                    lineStyle: .dashed,
                    thickness: 1.5,
                    indent: 32,
                    endIndent: 32,
                  ),
                  _cartItem(),
                ],
              ),
            ),
          ),
        ),
        ColumnBox(
          style: FlexBoxStyler().paddingTop(16),
          children: [
            StyledText(
              'Summary',
              style: TextStyler().fontSize(16).fontWeight(.w600),
            ),
            Gap(16),
            _summaryTile(title: 'Total No of Items', value: '2'),
            Gap(4),
            _summaryTile(title: 'Total Order Quantity', value: '2'),
            Gap(4),
            _summaryTile(title: 'Order Summary', value: '₹26.70'),
            Gap(4),
            StyledDivider(lineStyle: .dashed),
            Gap(4),
            RowBox(
              style: FlexBoxStyler().mainAxisAlignment(.spaceBetween),
              children: [
                StyledText(
                  'Total Amount',
                  style: TextStyler().fontSize(16).fontWeight(.bold),
                ),
                StyledText(
                  '₹26.70',
                  style: TextStyler().fontSize(16).fontWeight(.bold),
                ),
              ],
            ),
            Gap(4),
            StyledDivider(lineStyle: .dashed),
            Gap(16),
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
                  initialValue: ref.watch(paymentModeProvider),
                  onChanged: (value) {
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
                      label: StyledText(
                        'Cash',
                        style: TextStyler().fontSize(14),
                      ),
                    ),
                    ShadRadio(
                      value: 'upi',
                      label: StyledText(
                        'UPI',
                        style: TextStyler().fontSize(14),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Gap(24),
            ShadButton(
              width: double.infinity,
              height: 44,
              child: StyledText(
                'Save & Print',
                style: TextStyler().fontSize(16),
              ),
            ),
          ],
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

  RowBox _cartItem() {
    return RowBox(
      style: FlexBoxStyler().height(120).spacing(12).paddingAll(8),
      children: [
        AspectRatio(
          aspectRatio: 3 / 2,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Box(
              style: BoxStyler().color(Color(0xFFF7F7F7)),
              child: Image.network(
                'https://positeasy.s3.ap-south-1.amazonaws.com/MID-7efd859e-a0f7-4864-a70b-69f918b99c4b/Store1s/product-image/photos/T1-Img-203a5a62-3861-46e2-b3b5-668141e23bbb.jpeg',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    LucideIcons.image,
                    size: 32,
                    color: Colors.grey.shade500,
                  );
                },
              ),
            ),
          ),
        ),
        Expanded(
          child: ColumnBox(
            style: FlexBoxStyler()
                .crossAxisAlignment(CrossAxisAlignment.start)
                .mainAxisAlignment(MainAxisAlignment.spaceBetween),
            children: [
              ColumnBox(
                style: FlexBoxStyler().crossAxisAlignment(
                  CrossAxisAlignment.start,
                ),
                children: [
                  StyledText(
                    'Black Coffee'.toUpperCase(),
                    style: TextStyler().fontSize(16).fontWeight(.w600),
                  ),
                  StyledText(
                    '₹15.00',
                    style: TextStyler()
                        .fontSize(16)
                        .color(Colors.grey.shade600),
                  ),
                ],
              ),
              RowBox(
                style: FlexBoxStyler()
                    .spacing(8)
                    .mainAxisAlignment(.spaceBetween),
                children: [
                  RowBox(
                    style: FlexBoxStyler()
                        .color(Color(0xFFF7F7F7))
                        .mainAxisSize(.min)
                        .paddingAll(4)
                        .borderRadiusAll(.circular(999))
                        .crossAxisAlignment(CrossAxisAlignment.center)
                        .spacing(12),
                    children: [
                      ShadIconButton(
                        icon: const Icon(LucideIcons.minus),
                        height: 32,
                        width: 32,
                        iconSize: 16,
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        decoration: const ShadDecoration(
                          shape: BoxShape.circle,
                        ),
                        onPressed: () {},
                      ),
                      StyledText(
                        '1',
                        style: TextStyler().fontSize(16).fontWeight(.w600),
                      ),
                      ShadIconButton(
                        icon: const Icon(LucideIcons.plus),
                        height: 32,
                        width: 32,
                        iconSize: 16,
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        decoration: const ShadDecoration(
                          shape: BoxShape.circle,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),

                  ShadIconButton.destructive(
                    height: 36,
                    width: 36,
                    iconSize: 16,
                    decoration: const ShadDecoration(shape: BoxShape.circle),
                    onPressed: () {},
                    icon: Icon(LucideIcons.trash),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
