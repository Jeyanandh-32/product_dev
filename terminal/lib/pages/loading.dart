import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        constraints: BoxConstraints.tight(Size(24, 24)),
      ),
    );
  }
}
