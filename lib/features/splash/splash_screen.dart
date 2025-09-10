import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../widgets/umbra_background.dart';
import '../../widgets/umbra_logo.dart';
import '../chat/presentation/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..forward();

  @override
  void initState() {
    super.initState();
    unawaited(_goNext());
  }

  Future<void> _goNext() async {
  await Future.delayed(const Duration(milliseconds: 1650));
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 520),
        pageBuilder: (_, __, ___) => const HomeScreen(),
        transitionsBuilder: (_, anim, __, child) {
          final curved = CurvedAnimation(parent: anim, curve: Curves.easeOutExpo);
            return FadeTransition(
              opacity: curved,
              child: child,
            );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Scaffold(
      body: UmbraBackground(
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              final scale = 0.85 + (_controller.value * 0.15);
              final opacity = _controller.value.clamp(0.0, 1.0);
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Transform.scale(
                    scale: scale,
                    child: const UmbraLogo(size: 128),
                  ),
                  const SizedBox(height: 28),
                  Opacity(
                    opacity: opacity,
                    child: ShaderMask(
                      shaderCallback: (rect) => LinearGradient(
                        colors: [primary, primary.withOpacity(0.35)],
                      ).createShader(rect),
                      child: Text(
                        'UMBRA',
                        style: GoogleFonts.inter(
                          fontSize: 34,
                          letterSpacing: 8,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Opacity(
                    opacity: opacity * 0.85,
                    child: Text(
                      'Answer Engine',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        letterSpacing: 4,
                        fontWeight: FontWeight.w500,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
