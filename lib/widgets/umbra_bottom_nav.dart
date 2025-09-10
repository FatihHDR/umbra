import 'package:flutter/material.dart';
import 'dart:ui';

/// Glass floating navigation pill with:
/// - Blur + translucency
/// - Smaller height & icons
/// - Active pill highlight
/// - Shadow / glow
/// - Reduced horizontal padding & larger corner radius
class UmbraBottomNav extends StatelessWidget {
  const UmbraBottomNav({super.key, required this.currentIndex, required this.onTap});

  final int currentIndex; // 0..4
  final ValueChanged<int> onTap;

  static const List<IconData> _icons = [
    Icons.home_rounded,
    Icons.chat_bubble_rounded,
    Icons.history_rounded,
    Icons.description_rounded,
    Icons.settings_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final inactive = Colors.white.withOpacity(0.68);
    final glass = Colors.white.withOpacity(0.06);

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 0, 18, 30), // extra bottom gap for floating feel
        child: ClipRRect(
          borderRadius: BorderRadius.circular(44),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: glass,
                borderRadius: BorderRadius.circular(44),
                border: Border.all(color: Colors.white.withOpacity(0.10), width: 1),
                boxShadow: [
                  BoxShadow(
                    color: primary.withOpacity(0.20),
                    blurRadius: 26,
                    spreadRadius: 1,
                    offset: const Offset(0, 6),
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.35),
                    blurRadius: 36,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: SizedBox(
                height: 52,
                child: Row(
                  children: List.generate(_icons.length, (i) {
                    final selected = i == currentIndex;
                    return _NavItem(
                      icon: _icons[i],
                      selected: selected,
                      primary: primary,
                      inactive: inactive,
                      onTap: () => onTap(i),
                    );
                  }),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.selected,
    required this.primary,
    required this.inactive,
    required this.onTap,
  });

  final IconData icon;
  final bool selected;
  final Color primary;
  final Color inactive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final highlight = primary.withOpacity(0.18);
    final borderColor = primary.withOpacity(0.48);
    return Expanded(
      child: Semantics(
        selected: selected,
        button: true,
        child: InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          onTap: onTap,
          child: Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 260),
              curve: Curves.easeOutCubic,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
              decoration: selected
                  ? BoxDecoration(
                      color: highlight,
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: borderColor.withOpacity(0.55), width: 1),
                    )
                  : null,
              child: Icon(
                icon,
                size: 19,
                color: selected ? primary : inactive,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
