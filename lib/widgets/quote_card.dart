import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/quotes_data.dart';
import '../theme/app_theme.dart';

/// Card widget for displaying individual inspirational quote
class QuoteCard extends StatelessWidget {
  final Quote quote;
  final int index;

  const QuoteCard({super.key, required this.quote, required this.index});

  @override
  Widget build(BuildContext context) {
    // Alternate between light green and white background
    final bool isAlternate = index % 2 == 1;

    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.paddingMedium),
      decoration: BoxDecoration(
        color: isAlternate
            ? AppColors.secondaryWhite
            : AppColors.primaryGreen.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Decorative icon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.format_quote, color: AppColors.accentGold, size: 30),
                _buildCategoryBadge(),
              ],
            ),
            const SizedBox(height: AppDimensions.paddingSmall),

            // Arabic text (right aligned)
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                quote.arabic,
                style: GoogleFonts.amiri(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryGreen,
                ),
                textDirection: TextDirection.rtl,
              ),
            ),
            const SizedBox(height: AppDimensions.paddingSmall),

            // Indonesian text
            Text(
              quote.text,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: AppColors.textPrimary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: AppDimensions.paddingSmall),

            // Source
            Text(
              '- ${quote.source}',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build category badge
  Widget _buildCategoryBadge() {
    String categoryText;
    switch (quote.category) {
      case QuoteCategory.menuntutIlmu:
        categoryText = 'Ilmu';
        break;
      case QuoteCategory.beribadah:
        categoryText = 'Ibadah';
        break;
      case QuoteCategory.berbaktiLingkungan:
        categoryText = 'Lingkungan';
        break;
      case QuoteCategory.berbaktiKeluarga:
        categoryText = 'Keluarga';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primaryGreen.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        categoryText,
        style: GoogleFonts.poppins(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryGreen,
        ),
      ),
    );
  }
}
