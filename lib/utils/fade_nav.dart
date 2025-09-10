import 'package:flutter/material.dart';

// --- Simple Fade Replace (legacy support) ---
void fadeReplace(BuildContext context, Widget page) {
  Navigator.of(context).pushReplacement(_FadeRoute(child: page));
}

// --- New API: fade + scale ---
void fadeScaleReplace(BuildContext context, Widget page, {int ms = 180}) {
  Navigator.of(context).pushReplacement(_FadeScaleRoute(child: page, ms: ms));
}

void fadeScalePush(BuildContext context, Widget page, {int ms = 180}) {
  Navigator.of(context).push(_FadeScaleRoute(child: page, ms: ms));
}

class _FadeRoute extends PageRouteBuilder {
  _FadeRoute({required Widget child})
      : super(
          transitionDuration: const Duration(milliseconds: 260),
          reverseTransitionDuration: const Duration(milliseconds: 220),
          pageBuilder: (_, __, ___) => child,
          transitionsBuilder: (_, animation, __, child) {
            final curved = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
              reverseCurve: Curves.easeInCubic,
            );
            return FadeTransition(opacity: curved, child: child);
          },
        );
}

class _FadeScaleRoute extends PageRouteBuilder {
  _FadeScaleRoute({required Widget child, int ms = 180})
      : super(
          transitionDuration: Duration(milliseconds: (ms * 1.22).round()), // a bit longer for visibility
          reverseTransitionDuration: Duration(milliseconds: (ms * 0.9).round()),
          pageBuilder: (_, __, ___) => child,
          transitionsBuilder: (_, animation, __, child) {
            final curved = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutQuart,
              reverseCurve: Curves.easeInCubic,
            );
            final scale = Tween<double>(begin: 0.94, end: 1).animate(curved);
            final offset = Tween<Offset>(begin: const Offset(0, 0.012), end: Offset.zero).animate(curved);
            return FadeTransition(
              opacity: curved,
              child: AnimatedBuilder(
                animation: curved,
                builder: (_, __) => Transform.translate(
                  offset: offset.value * MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.height,
                  child: ScaleTransition(scale: scale, child: child),
                ),
              ),
            );
          },
        );
}
