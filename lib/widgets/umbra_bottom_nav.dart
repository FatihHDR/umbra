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
  final mq = MediaQuery.of(context);
  final bottomInset = mq.padding.bottom; // safe area / gesture nav
  final bottomOffset = (bottomInset > 0 ? bottomInset : 0) + 12; // raise a bit from absolute bottom

  return SafeArea(
      top: false,
      bottom: false,
      child: Padding(
  padding: EdgeInsets.only(bottom: bottomOffset.toDouble()),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(44),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 240),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
                child: Row(
                  mainAxisSize: MainAxisSize.min,
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
    return Semantics(
      selected: selected,
      button: true,
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOutCubic,
          margin: const EdgeInsets.symmetric(horizontal: 4),
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
    );
  }
}
