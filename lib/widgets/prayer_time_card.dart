import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

/// Prayer Time Card Widget with glassmorphism effect
/// Displays next prayer name, time, and countdown timer
class PrayerTimeCard extends StatefulWidget {
  final String nextPrayerName;
  final String nextPrayerTime;
  final DateTime nextPrayerDateTime;
  final VoidCallback? onTap;

  const PrayerTimeCard({
    super.key,
    required this.nextPrayerName,
    required this.nextPrayerTime,
    required this.nextPrayerDateTime,
    this.onTap,
  });

  @override
  State<PrayerTimeCard> createState() => _PrayerTimeCardState();
}

class _PrayerTimeCardState extends State<PrayerTimeCard> {
  Timer? _timer;
  Duration _timeLeft = Duration.zero;

  @override
  void initState() {
    super.initState();
    _updateTimeLeft();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateTimeLeft();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateTimeLeft() {
    final now = DateTime.now();
    if (widget.nextPrayerDateTime.isAfter(now)) {
      setState(() {
        _timeLeft = widget.nextPrayerDateTime.difference(now);
      });
    } else {
      setState(() {
        _timeLeft = Duration.zero;
      });
    }
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingMedium,
          vertical: AppDimensions.paddingSmall,
        ),
        padding: const EdgeInsets.all(AppDimensions.paddingMedium),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: AppColors.prayerCardGradient,
          ),
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMedium),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryGreen.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.accentGold.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(
                  AppDimensions.borderRadiusSmall,
                ),
              ),
              child: const Icon(
                Icons.access_time_filled,
                color: AppColors.accentGold,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            // Prayer Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Shalat Berikutnya',
                    style: GoogleFonts.poppins(
                      color: AppColors.secondaryWhite.withValues(alpha: 0.8),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.nextPrayerName,
                    style: GoogleFonts.poppins(
                      color: AppColors.secondaryWhite,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.nextPrayerTime,
                    style: GoogleFonts.inter(
                      color: AppColors.secondaryWhite.withValues(alpha: 0.7),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            // Countdown
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: AppColors.accentGold,
                borderRadius: BorderRadius.circular(
                  AppDimensions.borderRadiusSmall,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Tersisa',
                    style: GoogleFonts.poppins(
                      color: AppColors.darkGreen,
                      fontSize: 8,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    _formatDuration(_timeLeft),
                    style: GoogleFonts.poppins(
                      color: AppColors.darkGreen,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
