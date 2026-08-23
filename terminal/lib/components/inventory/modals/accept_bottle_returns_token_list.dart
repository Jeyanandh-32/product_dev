import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

/// Highly legible list of scanned bottle return QR tokens with sequence numbers and reward tags.
class AcceptBottleReturnsTokenList extends StatelessWidget {
  const AcceptBottleReturnsTokenList({
    required this.scannedTokens,
    required this.rewardPerBottle,
    required this.onRemove,
    super.key,
  });

  final List<String> scannedTokens;
  final int rewardPerBottle;
  final ValueChanged<String> onRemove;

  @override
  Widget build(BuildContext context) {
    if (scannedTokens.isEmpty) {
      return Container(
        height: 140,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(FLucideIcons.qrCode, size: 30, color: Color(0xFF94A3B8)),
            Gap(8),
            Text(
              'No bottle tokens added yet',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF64748B)),
            ),
            Gap(2),
            Text(
              'Scan bottle QR codes or type token IDs above',
              style: TextStyle(fontSize: 11.5, color: Color(0xFF94A3B8)),
            ),
          ],
        ),
      );
    }

    return Container(
      height: 190,
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: ListView.separated(
        padding: const EdgeInsets.all(10),
        itemCount: scannedTokens.length,
        separatorBuilder: (context, index) => const Gap(8),
        itemBuilder: (context, index) {
          final token = scannedTokens[index];
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFFFF),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFCBD5E1), width: 1),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x05000000),
                  offset: Offset(0, 1),
                  blurRadius: 2,
                ),
              ],
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 24,
                  child: Text(
                    '#${index + 1}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ),
                const Gap(4),
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(FLucideIcons.recycle, size: 13, color: Color(0xFF16A34A)),
                ),
                const Gap(10),
                Expanded(
                  child: Text(
                    token,
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.6,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                ),
                const Gap(8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0FDF4),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFFBBF7D0)),
                  ),
                  child: Text(
                    '+₹$rewardPerBottle.00',
                    style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800, color: Color(0xFF15803D)),
                  ),
                ),
                const Gap(8),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () => onRemove(token),
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEE2E2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      alignment: Alignment.center,
                      child: const Icon(FLucideIcons.trash2, size: 14, color: Color(0xFFDC2626)),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
