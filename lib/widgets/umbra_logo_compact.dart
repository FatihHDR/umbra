import 'package:flutter/material.dart';

import 'umbra_logo.dart';

/// A smaller horizontal brand mark for tight spaces like AppBars.
class UmbraLogoCompact extends StatelessWidget {
  const UmbraLogoCompact({super.key, this.size = 22});
  final double size;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        UmbraLogo(size: size),
        const SizedBox(width: 8),
        Text(
          'UMBRA',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                letterSpacing: 2,
                fontWeight: FontWeight.w600,
              ),
        )
      ],
    );
  }
}
