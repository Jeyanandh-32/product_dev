import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';

/// Full-page loading spinner with prominent sizing using Forui [FCircularProgress].
class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FCircularProgress(
        style: FCircularProgressStyle(
          iconStyle: const IconThemeData(
            size: 36,
            color: Color(0xFF000000),
          ),
        ),
      ),
    );
  }
}
