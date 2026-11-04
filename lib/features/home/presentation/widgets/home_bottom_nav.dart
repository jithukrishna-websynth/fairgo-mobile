import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';

/// Only Home exists so far; other tabs are placeholders until designed.
class HomeBottomNav extends StatelessWidget {
  const HomeBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 12)],
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _NavItem(label: 'Home', icon: Icons.home_rounded, selected: true),
          _NavItem(label: 'Bookings', icon: Icons.grid_view_rounded),
          _NavItem(label: 'Wallet', icon: Icons.assignment_outlined),
          _NavItem(label: 'Account', icon: Icons.person_outline, showDot: true),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.label,
    required this.icon,
    this.selected = false,
    this.showDot = false,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final bool showDot;

  @override
  Widget build(BuildContext context) {
    final color = selected ? Colors.white : AppColors.textSecondary;
    return Container(
      width: 76,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: selected ? AppColors.forest : Colors.transparent,
        borderRadius: BorderRadius.circular(26),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(icon, size: 22, color: color),
              if (showDot)
                Positioned(
                  right: -2,
                  top: -1,
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Color(0xFF2F6BFF),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 3),
          Text(label, style: TextStyle(fontSize: 10, color: color)),
        ],
      ),
    );
  }
}
