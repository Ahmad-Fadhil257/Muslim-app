import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

/// Bottom Navigation Bar Item Model
class BottomNavItem {
  final String label;
  final IconData activeIcon;
  final IconData inactiveIcon;
  final bool isSelected;
  final VoidCallback? onTap;

  const BottomNavItem({
    required this.label,
    required this.activeIcon,
    required this.inactiveIcon,
    this.isSelected = false,
    this.onTap,
  });
}

/// Bottom Navigation Bar Widget
/// Displays primary navigation: Home, Read, Schedule, Heart, Profile
class CustomBottomNavBar extends StatelessWidget {
  final List<BottomNavItem> items;
  final int currentIndex;
  final Function(int)? onTap;
  final double height;

  const CustomBottomNavBar({
    super.key,
    required this.items,
    required this.currentIndex,
    this.onTap,
    this.height = 70,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height + MediaQuery.of(context).padding.bottom,
      decoration: BoxDecoration(
        color: AppColors.secondaryWhite,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (index) {
              return _BottomNavBarItem(
                item: items[index],
                isSelected: currentIndex == index,
                onTap: () => onTap?.call(index),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _BottomNavBarItem extends StatelessWidget {
  final BottomNavItem item;
  final bool isSelected;
  final VoidCallback? onTap;

  const _BottomNavBarItem({
    required this.item,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryGreen.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMedium),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isSelected ? item.activeIcon : item.inactiveIcon,
                key: ValueKey(isSelected),
                color: isSelected
                    ? AppColors.primaryGreen
                    : AppColors.textSecondary,
                size: 24,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              item.label,
              style: GoogleFonts.poppins(
                color: isSelected
                    ? AppColors.primaryGreen
                    : AppColors.textSecondary,
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
