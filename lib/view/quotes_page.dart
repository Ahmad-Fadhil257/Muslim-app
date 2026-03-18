import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/quotes_data.dart';
import '../theme/app_theme.dart';
import '../widgets/quote_card.dart';

/// Quotes (Nasihat) Page - Inspirational Quotes
/// Displays 10 carefully curated quotes covering four themes:
/// - Religious knowledge (Tuntutan Ilmu)
/// - Worship (Beribadah)
/// - Environmental stewardship (Berbakti Lingkungan)
/// - Family devotion (Berbakti Keluarga)
class QuotesPage extends StatelessWidget {
  static const routeName = '/quotes';

  const QuotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cardBackground,
      body: CustomScrollView(
        slivers: [
          // App Bar with decorative header
          SliverAppBar(
            backgroundColor: AppColors.primaryGreen,
            foregroundColor: AppColors.secondaryWhite,
            elevation: 0,
            pinned: true,
            expandedHeight: 120,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Nasihat & Quotes',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: AppColors.headerGradient,
                  ),
                ),
                child: Stack(
                  children: [
                    // Decorative Islamic pattern
                    Positioned(
                      right: -20,
                      top: 20,
                      child: Icon(
                        Icons.auto_awesome,
                        size: 100,
                        color: AppColors.secondaryWhite.withOpacity(0.1),
                      ),
                    ),
                    Positioned(
                      left: -10,
                      bottom: 40,
                      child: Icon(
                        Icons.lightbulb_outline,
                        size: 60,
                        color: AppColors.accentGold.withOpacity(0.2),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          // Quotes List
          SliverPadding(
            padding: const EdgeInsets.all(AppDimensions.paddingMedium),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return QuoteCard(
                  quote: inspirationalQuotes[index],
                  index: index,
                );
              }, childCount: inspirationalQuotes.length),
            ),
          ),
        ],
      ),
    );
  }
}
