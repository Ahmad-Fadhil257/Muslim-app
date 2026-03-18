import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../viewmodel/shalat_view_model.dart';
import '../theme/app_theme.dart';

/// Helper function to format date with fallback
String _formatMonthYear(DateTime date) {
  try {
    return DateFormat('MMMM yyyy', 'id_ID').format(date);
  } catch (e) {
    // Fallback to English if Indonesian locale fails
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[date.month - 1]} ${date.year}';
  }
}

String _formatDayName(DateTime date) {
  try {
    return DateFormat('EEEE', 'id_ID').format(date);
  } catch (e) {
    // Fallback to English
    final days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return days[date.weekday - 1];
  }
}

class ShalatPage extends StatefulWidget {
  static const routeName = '/shalat';
  const ShalatPage({super.key});

  @override
  State<ShalatPage> createState() => _ShalatPageState();
}

class _ShalatPageState extends State<ShalatPage> {
  // sesuai API yang kamu kasih:
  final int cityId = 1206;
  final int year = 2026;
  final int month = 3; // March 2026

  final DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ShalatViewModel>().fetchMonthlySchedule(
        cityId: cityId,
        year: year,
        month: month,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ShalatViewModel>();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.primaryGreen, AppColors.lightGreen],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // Custom Header
              Padding(
                padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back Button Row
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.secondaryWhite.withValues(
                                alpha: 0.2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.arrow_back,
                              color: AppColors.secondaryWhite,
                              size: 20,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: AppColors.accentGold.withValues(
                                    alpha: 0.2,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    AppDimensions.borderRadiusSmall,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.schedule,
                                  color: AppColors.accentGold,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Jadwal Shalat',
                                style: GoogleFonts.poppins(
                                  color: AppColors.secondaryWhite,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Location & Date
                    Container(
                      padding: const EdgeInsets.all(
                        AppDimensions.paddingMedium,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryWhite.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(
                          AppDimensions.borderRadiusMedium,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: AppColors.accentGold,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Cianjur  ',
                            style: GoogleFonts.poppins(
                              color: AppColors.secondaryWhite,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.calendar_today,
                            color: AppColors.accentGold,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _formatMonthYear(_selectedDate),
                            style: GoogleFonts.poppins(
                              color: AppColors.secondaryWhite,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(AppDimensions.borderRadiusLarge),
                      topRight: Radius.circular(
                        AppDimensions.borderRadiusLarge,
                      ),
                    ),
                  ),
                  child: Builder(
                    builder: (_) {
                      if (vm.isLoading) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primaryGreen,
                          ),
                        );
                      }

                      if (vm.error != null) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(
                              AppDimensions.paddingMedium,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  size: 64,
                                  color: Colors.red.shade400,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Gagal memuat data',
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Silakan coba lagi',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                FilledButton.icon(
                                  onPressed: () {
                                    context
                                        .read<ShalatViewModel>()
                                        .fetchMonthlySchedule(
                                          cityId: cityId,
                                          year: year,
                                          month: month,
                                        );
                                  },
                                  icon: const Icon(Icons.refresh),
                                  label: const Text('Coba Lagi'),
                                  style: FilledButton.styleFrom(
                                    backgroundColor: AppColors.primaryGreen,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      if (vm.schedules.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.calendar_today_outlined,
                                size: 64,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Data kosong',
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      // Find today's schedule
                      final todayStr = DateFormat(
                        'dd-MM-yyyy',
                      ).format(_selectedDate);
                      final todaySchedule = vm.schedules.firstWhere(
                        (s) => s.tanggal == todayStr,
                        orElse: () => vm.schedules.isNotEmpty
                            ? vm.schedules[0]
                            : vm.schedules.first,
                      );

                      return SingleChildScrollView(
                        padding: const EdgeInsets.all(
                          AppDimensions.paddingMedium,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Today's Date Header
                            Container(
                              padding: const EdgeInsets.all(
                                AppDimensions.paddingMedium,
                              ),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: AppColors.headerGradient,
                                ),
                                borderRadius: BorderRadius.circular(
                                  AppDimensions.borderRadiusMedium,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 56,
                                    height: 56,
                                    decoration: BoxDecoration(
                                      color: AppColors.accentGold,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          DateFormat(
                                            'dd',
                                          ).format(_selectedDate),
                                          style: GoogleFonts.poppins(
                                            color: AppColors.darkGreen,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _formatDayName(_selectedDate),
                                          style: GoogleFonts.poppins(
                                            color: AppColors.secondaryWhite,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          _formatMonthYear(_selectedDate),
                                          style: GoogleFonts.inter(
                                            color: AppColors.secondaryWhite
                                                .withValues(alpha: 0.8),
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.accentGold,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      'Hari Ini',
                                      style: GoogleFonts.poppins(
                                        color: AppColors.darkGreen,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Prayer Times
                            Text(
                              'Waktu Shalat',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Prayer Cards Grid
                            GridView.count(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              crossAxisCount: 2,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                              childAspectRatio: 1.5,
                              children: [
                                _PrayerTimeCard(
                                  name: 'Subuh',
                                  time: todaySchedule.subuh,
                                  icon: Icons.nights_stay,
                                  isFirst: true,
                                ),
                                _PrayerTimeCard(
                                  name: 'Dzuhur',
                                  time: todaySchedule.dzuhur,
                                  icon: Icons.wb_sunny,
                                ),
                                _PrayerTimeCard(
                                  name: 'Ashar',
                                  time: todaySchedule.ashar,
                                  icon: Icons.wb_twilight,
                                ),
                                _PrayerTimeCard(
                                  name: 'Maghrib',
                                  time: todaySchedule.maghrib,
                                  icon: Icons.nightlight_round,
                                ),
                                _PrayerTimeCard(
                                  name: 'Isya',
                                  time: todaySchedule.isya,
                                  icon: Icons.dark_mode,
                                  isLast: true,
                                ),
                                _PrayerTimeCard(
                                  name: 'Imsak',
                                  time: todaySchedule.imsak,
                                  icon: Icons.brightness_3,
                                ),
                              ],
                            ),

                            const SizedBox(height: 20),

                            // Additional Info
                            Container(
                              padding: const EdgeInsets.all(
                                AppDimensions.paddingMedium,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.secondaryWhite,
                                borderRadius: BorderRadius.circular(
                                  AppDimensions.borderRadiusMedium,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  _InfoRow(
                                    icon: Icons.wb_sunny_outlined,
                                    label: 'Terbit',
                                    value: todaySchedule.terbit,
                                  ),
                                  const Divider(height: 16),
                                  _InfoRow(
                                    icon: Icons.brightness_high_outlined,
                                    label: 'Dhuha',
                                    value: todaySchedule.dhuha,
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 24),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PrayerTimeCard extends StatelessWidget {
  final String name;
  final String time;
  final IconData icon;
  final bool isFirst;
  final bool isLast;

  const _PrayerTimeCard({
    required this.name,
    required this.time,
    required this.icon,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.secondaryWhite,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMedium),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMedium),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingMedium),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: AppColors.primaryGreen, size: 24),
                const SizedBox(height: 8),
                Text(
                  name,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time.isNotEmpty ? time : '-',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryGreen,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.accentGold, size: 20),
        const SizedBox(width: 12),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        const Spacer(),
        Text(
          value.isNotEmpty ? value : '-',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
