import 'dart:ui';

import 'package:flutter/material.dart';

/// Floating, pill-shaped bottom navigation bar with only icons (no labels).
/// Usage: place in Scaffold.bottomNavigationBar and supply currentIndex & onTap.
class UmbraBottomNav extends StatelessWidget {
  const UmbraBottomNav({super.key, required this.currentIndex, required this.onTap});

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bg = theme.colorScheme.surface.withOpacity(0.86);
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(36),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(36),
                border: Border.all(color: Colors.white.withOpacity(0.08), width: 1),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              child: BottomNavigationBar(
                currentIndex: currentIndex,
                onTap: onTap,
                backgroundColor: Colors.transparent,
                elevation: 0,
                type: BottomNavigationBarType.fixed,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                selectedItemColor: theme.colorScheme.primary,
                unselectedItemColor: Colors.white70,
                items: const [
                  BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: ''),
                  BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_rounded), label: ''),
                  BottomNavigationBarItem(icon: Icon(Icons.history_rounded), label: ''),
                  BottomNavigationBarItem(icon: Icon(Icons.settings_rounded), label: ''),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
