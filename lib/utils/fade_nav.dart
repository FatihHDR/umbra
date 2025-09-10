import 'package:flutter/material.dart';

/// Helper for consistent fade transition when switching main tabs via pushReplacement.
void fadeReplace(BuildContext context, Widget page) {
  Navigator.of(context).pushReplacement(_FadeRoute(child: page));
}

class _FadeRoute extends PageRouteBuilder {
  _FadeRoute({required Widget child})
      : super(
          transitionDuration: const Duration(milliseconds: 260),
          reverseTransitionDuration: const Duration(milliseconds: 220),
          pageBuilder: (_, __, ___) => child,
          transitionsBuilder: (_, animation, __, child) {
            final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic, reverseCurve: Curves.easeInCubic);
            return FadeTransition(opacity: curved, child: child);
          },
        );
}
