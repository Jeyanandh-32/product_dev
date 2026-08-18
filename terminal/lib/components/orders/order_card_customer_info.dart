import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:models/models.dart';

/// Compact customer summary row inside the POS order card item.
class OrderCardCustomerInfo extends StatelessWidget {
  final Customer customer;

  const OrderCardCustomerInfo({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(FLucideIcons.user, size: 13.5, color: Color(0xFF64748B)),
        const Gap(6),
        Expanded(
          child: Text(
            '${customer.name} • ${customer.mobileNumber}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0F172A),
            ),
          ),
        ),
      ],
    );
  }
}
