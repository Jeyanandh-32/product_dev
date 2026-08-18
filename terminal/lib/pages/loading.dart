import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';

/// Full-page or inline loading spinner with optional text below using Forui [FCircularProgress].
class Loading extends StatelessWidget {
  final String? message;

  const Loading({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FCircularProgress(
            style: FCircularProgressStyle(
              iconStyle: const IconThemeData(
                size: 36,
                color: Color(0xFF000000),
              ),
            ),
          ),
          if (message != null) ...[
            const Gap(14),
            Text(
              message!,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF64748B),
                letterSpacing: -0.2,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
