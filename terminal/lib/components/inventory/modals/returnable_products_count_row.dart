import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

/// Row displaying returnable product count and search match status.
class ReturnableProductsCountRow extends StatelessWidget {
  final int returnableCount;
  final int totalCount;
  final int matchingCount;
  final bool isSearching;

  const ReturnableProductsCountRow({
    super.key,
    required this.returnableCount,
    required this.totalCount,
    required this.matchingCount,
    required this.isSearching,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            '$returnableCount of $totalCount products returnable',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF64748B),
            ),
          ),
        ),
        if (isSearching) ...[
          const Gap(8),
          Text(
            '$matchingCount matching search',
            style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
          ),
        ],
      ],
    );
  }
}
