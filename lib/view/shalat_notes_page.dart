import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../theme/app_theme.dart';

class ShalatNotesPage extends StatefulWidget {
  static const routeName = '/shalat-notes';

  const ShalatNotesPage({super.key});

  @override
  State<ShalatNotesPage> createState() => _ShalatNotesPageState();
}

class _ShalatNotesPageState extends State<ShalatNotesPage> {
  List<Map<String, dynamic>> _notes = [];
  bool _isLoading = true;
  DateTime _selectedDate = DateTime.now();

  final List<String> _prayers = ['Subuh', 'Dzuhur', 'Ashar', 'Maghrib', 'Isya'];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    setState(() => _isLoading = true);
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user != null) {
        final startOfMonth = DateTime(
          _selectedDate.year,
          _selectedDate.month,
          1,
        );
        final endOfMonth = DateTime(
          _selectedDate.year,
          _selectedDate.month + 1,
          0,
        );

        final response = await Supabase.instance.client
            .from('shalat_notes')
            .select()
            .eq('user_id', user.id)
            .gte('date', startOfMonth.toIso8601String().split('T')[0])
            .lte('date', endOfMonth.toIso8601String().split('T')[0])
            .order('date', ascending: false);
        setState(() {
          _notes = List<Map<String, dynamic>>.from(response);
        });
      }
    } catch (e) {
      // Handle error
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _togglePrayer(String prayerName, bool isCompleted) async {
    // Prevent recording for future dates
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selectedDate = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
    );

    if (selectedDate.isAfter(today)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tidak bisa mencatat untuk tanggal mendatang'),
            duration: Duration(seconds: 2),
          ),
        );
      }
      return;
    }

    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user != null) {
        final dateStr = _selectedDate.toIso8601String().split('T')[0];

        if (isCompleted) {
          // Mark as completed
          await Supabase.instance.client.from('shalat_notes').upsert({
            'user_id': user.id,
            'date': dateStr,
            'prayer_name': prayerName,
            'is_completed': true,
            'updated_at': DateTime.now().toIso8601String(),
          }, onConflict: 'user_id,date,prayer_name');
        } else {
          // Mark as not completed
          await Supabase.instance.client.from('shalat_notes').upsert({
            'user_id': user.id,
            'date': dateStr,
            'prayer_name': prayerName,
            'is_completed': false,
            'updated_at': DateTime.now().toIso8601String(),
          }, onConflict: 'user_id,date,prayer_name');
        }

        await _loadNotes();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                isCompleted
                    ? '$prayerName ditandai selesai'
                    : '$prayerName ditandai belum selesai',
              ),
              duration: const Duration(seconds: 1),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal menyimpan: $e')));
      }
    }
  }

  bool _isPrayerCompleted(String prayerName) {
    final dateStr = _selectedDate.toIso8601String().split('T')[0];
    return _notes.any(
      (note) =>
          note['date'] == dateStr &&
          note['prayer_name'] == prayerName &&
          note['is_completed'] == true,
    );
  }

  int _getCompletedCount() {
    final dateStr = _selectedDate.toIso8601String().split('T')[0];
    return _notes
        .where(
          (note) => note['date'] == dateStr && note['is_completed'] == true,
        )
        .length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cardBackground,
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: AppColors.secondaryWhite,
        title: Text(
          'Catatan Shalat',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Date Selector
                Container(
                  color: AppColors.primaryGreen,
                  padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _selectedDate = _selectedDate.subtract(
                                  const Duration(days: 1),
                                );
                              });
                              _loadNotes();
                            },
                            icon: const Icon(
                              Icons.chevron_left,
                              color: AppColors.secondaryWhite,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _selectedDate = DateTime.now();
                              });
                              _loadNotes();
                            },
                            icon: const Icon(
                              Icons.today,
                              color: AppColors.secondaryWhite,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '${_getMonthName(_selectedDate.month)} ${_selectedDate.year}',
                        style: GoogleFonts.poppins(
                          color: AppColors.secondaryWhite,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _selectedDate = DateTime(
                              _selectedDate.year,
                              _selectedDate.month + 1,
                              1,
                            );
                          });
                          _loadNotes();
                        },
                        icon: const Icon(
                          Icons.chevron_right,
                          color: AppColors.secondaryWhite,
                        ),
                      ),
                    ],
                  ),
                ),

                // Day Selector
                Container(
                  height: 70,
                  color: AppColors.primaryGreen,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.paddingSmall,
                    ),
                    itemCount: _getDaysInMonth(),
                    itemBuilder: (context, index) {
                      final day = index + 1;
                      final date = DateTime(
                        _selectedDate.year,
                        _selectedDate.month,
                        day,
                      );
                      final isSelected =
                          date.day == _selectedDate.day &&
                          date.month == _selectedDate.month &&
                          date.year == _selectedDate.year;
                      final isToday =
                          date.day == DateTime.now().day &&
                          date.month == DateTime.now().month &&
                          date.year == DateTime.now().year;

                      return GestureDetector(
                        onTap: () {
                          setState(() => _selectedDate = date);
                        },
                        child: Container(
                          width: 45,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.accentGold
                                : (isToday
                                      ? Colors.white.withValues(alpha: 0.2)
                                      : Colors.transparent),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _getDayName(date.weekday),
                                style: GoogleFonts.poppins(
                                  color: AppColors.secondaryWhite,
                                  fontSize: 10,
                                ),
                              ),
                              Text(
                                day.toString(),
                                style: GoogleFonts.poppins(
                                  color: AppColors.secondaryWhite,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Selected Date Info
                Container(
                  padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                  color: AppColors.secondaryWhite,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatDate(_selectedDate),
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getCompletedCount() == 5
                              ? Colors.green
                              : AppColors.primaryGreen,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${_getCompletedCount()}/5 Shalat',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Prayer List
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                    itemCount: _prayers.length,
                    itemBuilder: (context, index) {
                      final prayer = _prayers[index];
                      final isCompleted = _isPrayerCompleted(prayer);

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: AppColors.secondaryWhite,
                          borderRadius: BorderRadius.circular(
                            AppDimensions.borderRadiusMedium,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          leading: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: isCompleted
                                  ? Colors.green.withValues(alpha: 0.1)
                                  : AppColors.cardBackground,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              isCompleted
                                  ? Icons.check_circle
                                  : Icons.check_circle_outline,
                              color: isCompleted ? Colors.green : Colors.grey,
                              size: 28,
                            ),
                          ),
                          title: Text(
                            prayer,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              decoration: isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                              color: isCompleted
                                  ? AppColors.textSecondary
                                  : AppColors.textPrimary,
                            ),
                          ),
                          subtitle: Text(
                            isCompleted ? 'Selesai' : 'Belum dikerjakan',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: isCompleted
                                  ? Colors.green
                                  : AppColors.textSecondary,
                            ),
                          ),
                          trailing: Switch(
                            value: isCompleted,
                            onChanged: (value) => _togglePrayer(prayer, value),
                            activeColor: AppColors.primaryGreen,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  int _getDaysInMonth() {
    return DateTime(_selectedDate.year, _selectedDate.month + 1, 0).day;
  }

  String _getMonthName(int month) {
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return months[month - 1];
  }

  String _getDayName(int weekday) {
    const days = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
    return days[weekday - 1];
  }

  String _formatDate(DateTime date) {
    const days = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu',
    ];
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return '${days[date.weekday - 1]}, ${date.day} ${months[date.month - 1]} ${date.year}';
  }
}
