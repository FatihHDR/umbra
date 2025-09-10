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
    final bg = theme.colorScheme.surface; // opaque so nothing "behind" shows
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(28, 0, 28, 16),
        child: Container(
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.white.withOpacity(0.06), width: 1),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Theme(
            // Remove ripple spread / splash, keep only color change via selectedItemColor
            data: theme.copyWith(
              splashFactory: NoSplash.splashFactory,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
            ),
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
              iconSize: 22,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: ''),
                BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_rounded), label: ''),
                BottomNavigationBarItem(icon: Icon(Icons.history_rounded), label: ''),
                BottomNavigationBarItem(icon: Icon(Icons.description_rounded), label: ''),
                BottomNavigationBarItem(icon: Icon(Icons.settings_rounded), label: ''),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
