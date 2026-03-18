import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';

/// Button widget for limit selection (33, 99, Bebas)
class LimitOptionButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isReset;

  const LimitOptionButton({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.isReset = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 80,
        height: 45,
        decoration: BoxDecoration(
          color: isReset
              ? Colors.red.shade600
              : (isSelected
                    ? AppColors.primaryGreen
                    : AppColors.cardBackground),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isReset
                  ? AppColors.secondaryWhite
                  : (isSelected
                        ? AppColors.secondaryWhite
                        : AppColors.textPrimary),
            ),
          ),
        ),
      ),
    );
  }
}
