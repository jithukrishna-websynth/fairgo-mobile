import 'package:flutter/material.dart';

class FairGoLogo extends StatelessWidget {
  const FairGoLogo({super.key, this.width = 220});

  final double width;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/logos/fairgo_logo.png',
      width: width,
      semanticLabel: 'Fair-Go, everywhere you go',
    );
  }
}
