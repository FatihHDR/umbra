import 'package:flutter/material.dart';

class UmbraBackground extends StatelessWidget {
  const UmbraBackground({super.key, this.child});
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(0, -0.4),
          radius: 1.2,
          colors: [
            Color(0xFF1E1E1E),
            Color(0xFF121212),
            Color(0xFF0A0A0A),
          ],
          stops: [0.0, 0.55, 1.0],
        ),
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.red.withOpacity(0.08),
              Colors.transparent,
              Colors.red.withOpacity(0.05),
            ],
            stops: const [0.0, 0.55, 1.0],
          ),
        ),
        child: child,
      ),
    );
  }
}
