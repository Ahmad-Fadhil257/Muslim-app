import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';

/// Card widget for displaying selectable dhikr text
class DhikrCard extends StatelessWidget {
  final String arabicText;
  final String transliteration;
  final bool isSelected;
  final VoidCallback onTap;

  const DhikrCard({
    super.key,
    required this.arabicText,
    required this.transliteration,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 100,
        height: 70,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryGreen : AppColors.cardBackground,
          borderRadius: BorderRadius.circular(25),
          border: isSelected
              ? Border.all(color: AppColors.accentGold, width: 2)
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Arabic text
            Text(
              arabicText,
              style: GoogleFonts.amiri(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isSelected
                    ? AppColors.secondaryWhite
                    : AppColors.primaryGreen,
              ),
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 4),
            // Transliteration text
            Text(
              transliteration,
              style: GoogleFonts.poppins(
                fontSize: 10,
                color: isSelected
                    ? AppColors.accentGold
                    : AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
