import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../theme/app_theme.dart';
import '../widgets/custom_header.dart';
import '../widgets/prayer_time_card.dart';
import '../widgets/main_navigation_grid.dart';
import '../widgets/secondary_navigation_grid.dart';
import '../widgets/bottom_nav_bar.dart';

import 'shalat_page.dart';
import 'quran_page.dart';
import 'doa_page.dart';
import 'qibla_page.dart';
import 'chat_page.dart';
import 'login_page.dart';
import 'profile_page.dart';
import 'shalat_notes_page.dart';
import 'ceramah_notes_page.dart';
import 'infaq_notes_page.dart';
import 'tasbih_page.dart';
import 'quotes_page.dart';
import '../viewmodel/auth_view_model.dart';
import '../viewmodel/shalat_view_model.dart';

/// HomePage - Main entry point of the Muslim App
/// Features Ramadan-themed UI with prayer times, navigation, and quick actions
///
/// API Integration Points:
/// - Prayer Times: Integrate with [ShalatRepository] for real-time prayer schedules
/// - Location: Use [Geolocator] package for user's current location
/// - AI Chat: Connect to [GeminiService] for Islamic Q&A feature
/// - Notes: Use [Supabase] for storing user notes (Shalat, Ceramah, Infaq)
class HomePage extends StatefulWidget {
  static const routeName = '/home';

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentNavIndex = 0;

  String _location = 'Cianjur, Indonesia';

  @override
  void initState() {
    super.initState();
    // Fetch today's prayer schedule when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ShalatViewModel>().fetchTodaySchedule();
    });
  }

  /// Calculate next prayer based on current time and prayer schedule
  (String name, String time, DateTime dateTime) _getNextPrayer() {
    final schedule = context.read<ShalatViewModel>().todaySchedule;
    if (schedule == null) {
      return ('Maghrib', '18:45', DateTime.now().add(const Duration(hours: 2)));
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Map prayer times
    final prayers = [
      ('Subuh', schedule.subuh),
      ('Dzuhur', schedule.dzuhur),
      ('Ashar', schedule.ashar),
      ('Maghrib', schedule.maghrib),
      ('Isya', schedule.isya),
    ];

    for (final prayer in prayers) {
      final timeParts = prayer.$2.split(':');
      if (timeParts.length >= 2) {
        final prayerTime = DateTime(
          today.year,
          today.month,
          today.day,
          int.tryParse(timeParts[0]) ?? 0,
          int.tryParse(timeParts[1]) ?? 0,
        );
        if (prayerTime.isAfter(now)) {
          return (prayer.$1, prayer.$2, prayerTime);
        }
      }
    }

    // If all prayers passed, return first prayer of next day (Subuh)
    final tomorrow = today.add(const Duration(days: 1));
    final timeParts = prayers[0].$2.split(':');
    return (
      prayers[0].$1,
      prayers[0].$2,
      DateTime(
        tomorrow.year,
        tomorrow.month,
        tomorrow.day,
        int.tryParse(timeParts[0]) ?? 0,
        int.tryParse(timeParts[1]) ?? 0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final salatViewModel = context.watch<ShalatViewModel>();

    // Update location from viewmodel
    _location = '${salatViewModel.currentCityName}, Indonesia';

    // Get next prayer from API data
    final nextPrayer = _getNextPrayer();

    return Scaffold(
      backgroundColor: AppColors.cardBackground,
      body: Column(
        children: [
          // Custom Header with gradient
          CustomHeader(
            greeting: 'Assalamu\'alaikum',
            subGreeting: 'Semoga Allah memudahakan urusan Anda',
            location: _location,
            nextPrayer: nextPrayer.$1,
            nextPrayerTime: nextPrayer.$2,
            onLocationTap: () {
              // TODO: Implement location picker
            },
          ),

          // Prayer Time Card with countdown
          PrayerTimeCard(
            nextPrayerName: nextPrayer.$1,
            nextPrayerTime: nextPrayer.$2,
            nextPrayerDateTime: nextPrayer.$3,
            onTap: () {
              Navigator.pushNamed(context, ShalatPage.routeName);
            },
          ),

          // Main Content Area
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppDimensions.paddingMedium),

                  // Main Navigation Grid (2-column)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.paddingMedium,
                    ),
                    child: Text(
                      'Menu Utama',
                      style: GoogleFonts.poppins(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.paddingSmall),

                  MainNavigationGrid(
                    items: [
                      NavigationItem(
                        label: 'Al-Quran',
                        icon: Icons.menu_book_rounded,
                        color: const Color(0xFF6B4EE6),
                        onTap: () =>
                            Navigator.pushNamed(context, QuranPage.routeName),
                      ),
                      NavigationItem(
                        label: 'Jadwal Shalat',
                        icon: Icons.schedule,
                        color: AppColors.primaryGreen,
                        onTap: () =>
                            Navigator.pushNamed(context, ShalatPage.routeName),
                      ),
                      NavigationItem(
                        label: 'Doa Harian',
                        icon: Icons.favorite,
                        color: const Color(0xFFFF6B6B),
                        onTap: () =>
                            Navigator.pushNamed(context, DoaPage.routeName),
                      ),
                      NavigationItem(
                        label: 'Kiblat',
                        icon: Icons.explore,
                        color: const Color(0xFF4ECDC4),
                        onTap: () =>
                            Navigator.pushNamed(context, QiblaPage.routeName),
                      ),
                      NavigationItem(
                        label: 'AI Islam',
                        icon: Icons.auto_awesome,
                        color: AppColors.accentGold,
                        onTap: () =>
                            Navigator.pushNamed(context, ChatPage.routeName),
                      ),
                      NavigationItem(
                        label: 'Tasbih',
                        icon: Icons.touch_app,
                        color: const Color(0xFF9C27B0),
                        onTap: () =>
                            Navigator.pushNamed(context, TasbihPage.routeName),
                      ),
                      NavigationItem(
                        label: 'Nasihat',
                        icon: Icons.format_quote,
                        color: const Color(0xFF00BCD4),
                        onTap: () =>
                            Navigator.pushNamed(context, QuotesPage.routeName),
                      ),
                    ],
                    crossAxisCount: 2,
                  ),

                  const SizedBox(height: AppDimensions.paddingMedium),

                  // Secondary Navigation Grid (3-column) - Catatan Ramadhan
                  SecondaryNavigationGrid(
                    sectionTitle: 'Catatan Ramadhan',
                    items: [
                      SecondaryNavigationItem(
                        label: 'Shalat',
                        icon: Icons.check_circle_outline,
                        color: AppColors.primaryGreen,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            ShalatNotesPage.routeName,
                          );
                        },
                      ),
                      SecondaryNavigationItem(
                        label: 'Ceramah',
                        icon: Icons.record_voice_over,
                        color: const Color(0xFF7B68EE),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            CeramahNotesPage.routeName,
                          );
                        },
                      ),
                      SecondaryNavigationItem(
                        label: 'Infaq',
                        icon: Icons.volunteer_activism,
                        color: AppColors.accentGold,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            InfaqNotesPage.routeName,
                          );
                        },
                      ),
                    ],
                    crossAxisCount: 3,
                  ),

                  const SizedBox(height: AppDimensions.paddingLarge * 2),
                ],
              ),
            ),
          ),
        ],
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentNavIndex,
        onTap: (index) {
          setState(() {
            _currentNavIndex = index;
          });

          // Handle navigation based on index
          switch (index) {
            case 0:
              // Already on Home
              break;
            case 1:
              Navigator.pushNamed(context, QuranPage.routeName);
              break;
            case 2:
              Navigator.pushNamed(context, ShalatPage.routeName);
              break;
            case 3:
              Navigator.pushNamed(context, DoaPage.routeName);
              break;
            case 4:
              Navigator.pushNamed(context, ProfilePage.routeName);
              break;
          }
        },
        items: const [
          BottomNavItem(
            label: 'Home',
            activeIcon: Icons.home_rounded,
            inactiveIcon: Icons.home_outlined,
          ),
          BottomNavItem(
            label: 'Quran',
            activeIcon: Icons.menu_book_rounded,
            inactiveIcon: Icons.menu_book_outlined,
          ),
          BottomNavItem(
            label: 'Waktu Shalat',
            activeIcon: Icons.schedule_rounded,
            inactiveIcon: Icons.schedule_outlined,
          ),
          BottomNavItem(
            label: 'Doa',
            activeIcon: Icons.favorite_rounded,
            inactiveIcon: Icons.favorite_outline,
          ),
          BottomNavItem(
            label: 'Profile',
            activeIcon: Icons.person_rounded,
            inactiveIcon: Icons.person_outline,
          ),
        ],
      ),
    );
  }
}
