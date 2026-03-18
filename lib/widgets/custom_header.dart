import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

/// Custom Header Widget with dynamic gradient background
/// Displays Ramadan greeting, location, and next prayer time
class CustomHeader extends StatelessWidget {
  final String greeting;
  final String subGreeting;
  final String? location;
  final String? nextPrayer;
  final String? nextPrayerTime;
  final VoidCallback? onLocationTap;

  const CustomHeader({
    super.key,
    required this.greeting,
    required this.subGreeting,
    this.location,
    this.nextPrayer,
    this.nextPrayerTime,
    this.onLocationTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.paddingMedium,
        AppDimensions.paddingMedium,
        AppDimensions.paddingMedium,
        AppDimensions.paddingMedium,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: AppColors.headerGradient,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppDimensions.borderRadiusLarge),
          bottomRight: Radius.circular(AppDimensions.borderRadiusLarge),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Location Row
            if (location != null)
              Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    color: AppColors.accentGold,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: onLocationTap,
                    child: Text(
                      location!,
                      style: GoogleFonts.poppins(
                        color: AppColors.secondaryWhite.withValues(alpha: 0.9),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: AppDimensions.paddingSmall),

            // Main Greeting
            Text(
              greeting,
              style: GoogleFonts.poppins(
                color: AppColors.secondaryWhite,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),

            // Sub Greeting
            Text(
              subGreeting,
              style: GoogleFonts.inter(
                color: AppColors.secondaryWhite.withValues(alpha: 0.85),
                fontSize: 12,
              ),
              maxLines: 2,
            ),

            const SizedBox(height: AppDimensions.paddingSmall),

            // Ramadan Mubarak Badge and Next Prayer Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Ramadan Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingSmall,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.accentGold.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(
                      AppDimensions.borderRadiusSmall,
                    ),
                    border: Border.all(
                      color: AppColors.accentGold.withValues(alpha: 0.5),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.mosque,
                        color: AppColors.accentGold,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Ramadhan 1446 H',
                        style: GoogleFonts.poppins(
                          color: AppColors.accentGold,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                // Next Prayer Info
                if (nextPrayer != null && nextPrayerTime != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.paddingSmall,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(
                        AppDimensions.borderRadiusSmall,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.schedule,
                          color: AppColors.secondaryWhite,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$nextPrayer - $nextPrayerTime',
                          style: GoogleFonts.poppins(
                            color: AppColors.secondaryWhite,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
