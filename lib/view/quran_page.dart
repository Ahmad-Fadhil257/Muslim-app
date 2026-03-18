import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '../viewmodel/quran_view_model.dart';
import '../model/surah.dart';
import '../theme/app_theme.dart';

class QuranPage extends StatefulWidget {
  static const routeName = '/quran';
  const QuranPage({super.key});

  @override
  State<QuranPage> createState() => _QuranPageState();
}

class _QuranPageState extends State<QuranPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QuranViewModel>().fetchSurahList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<QuranViewModel>();

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
                                  Icons.menu_book_rounded,
                                  color: AppColors.accentGold,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Al-Quran',
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

                    // Search Bar
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.secondaryWhite.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(
                          AppDimensions.borderRadiusMedium,
                        ),
                        border: Border.all(
                          color: AppColors.secondaryWhite.withValues(
                            alpha: 0.3,
                          ),
                        ),
                      ),
                      child: TextField(
                        controller: _searchController,
                        style: GoogleFonts.poppins(
                          color: AppColors.secondaryWhite,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Cari surat...',
                          hintStyle: GoogleFonts.poppins(
                            color: AppColors.secondaryWhite.withValues(
                              alpha: 0.6,
                            ),
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: AppColors.secondaryWhite.withValues(
                              alpha: 0.6,
                            ),
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value.toLowerCase();
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // Surah List
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
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.error_outline,
                                size: 48,
                                color: Colors.red.shade400,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Gagal memuat data',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              FilledButton(
                                onPressed: () {
                                  context
                                      .read<QuranViewModel>()
                                      .fetchSurahList();
                                },
                                style: FilledButton.styleFrom(
                                  backgroundColor: AppColors.primaryGreen,
                                ),
                                child: const Text('Coba Lagi'),
                              ),
                            ],
                          ),
                        );
                      }
                      if (vm.surahList.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.book_outlined,
                                size: 48,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Tidak ada data',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      // Filter surah based on search query
                      final filteredSurah = vm.surahList.where((surah) {
                        if (_searchQuery.isEmpty) return true;
                        return surah.namaLatin.toLowerCase().contains(
                              _searchQuery,
                            ) ||
                            surah.nama.toLowerCase().contains(_searchQuery) ||
                            surah.arti.toLowerCase().contains(_searchQuery);
                      }).toList();

                      if (filteredSurah.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 48,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Surat tidak ditemukan',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.all(
                          AppDimensions.paddingMedium,
                        ),
                        itemCount: filteredSurah.length,
                        itemBuilder: (context, i) {
                          final Surah s = filteredSurah[i];
                          return _SurahCard(
                            surah: s,
                            onTap: () => _showSurahDetail(context, s),
                          );
                        },
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

  void _showSurahDetail(BuildContext context, Surah s) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          maxChildSize: 0.95,
          minChildSize: 0.5,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: AppColors.secondaryWhite,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppDimensions.borderRadiusLarge),
                  topRight: Radius.circular(AppDimensions.borderRadiusLarge),
                ),
              ),
              child: Column(
                children: [
                  // Handle
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                  // Header
                  Container(
                    padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: AppColors.headerGradient,
                      ),
                      borderRadius: BorderRadius.circular(
                        AppDimensions.borderRadiusMedium,
                      ),
                    ),
                    margin: const EdgeInsets.all(AppDimensions.paddingMedium),
                    child: Column(
                      children: [
                        Text(
                          s.nama,
                          style: GoogleFonts.poppins(
                            color: AppColors.secondaryWhite,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          s.namaLatin,
                          style: GoogleFonts.poppins(
                            color: AppColors.accentGold,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.secondaryWhite.withValues(
                              alpha: 0.2,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${s.tempatTurun} • ${s.jumlahAyat} Ayat',
                            style: GoogleFonts.inter(
                              color: AppColors.secondaryWhite,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Content
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      padding: const EdgeInsets.all(
                        AppDimensions.paddingMedium,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Arti
                          _DetailRow(
                            icon: Icons.translate,
                            label: 'Arti',
                            value: s.arti,
                          ),
                          const SizedBox(height: 16),

                          // Description
                          _DetailRow(
                            icon: Icons.description_outlined,
                            label: 'Deskripsi',
                            value: s.deskripsi.replaceAll(
                              RegExp(r'<[^>]*>|&[^;]+;'),
                              '',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Close Button
                  Padding(
                    padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                    child: SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () => Navigator.pop(context),
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.primaryGreen,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppDimensions.borderRadiusMedium,
                            ),
                          ),
                        ),
                        child: Text(
                          'Tutup',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _SurahCard extends StatelessWidget {
  final Surah surah;
  final VoidCallback onTap;

  const _SurahCard({required this.surah, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isMakkah = surah.tempatTurun.toLowerCase() == 'mekah';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMedium),
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingMedium),
            child: Row(
              children: [
                // Surah Number
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: AppColors.headerGradient,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      '${surah.nomor}',
                      style: GoogleFonts.poppins(
                        color: AppColors.secondaryWhite,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),

                // Surah Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        surah.namaLatin,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: isMakkah
                                  ? Colors.blue.shade50
                                  : Colors.green.shade50,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              isMakkah ? 'Makkiyah' : 'Madaniyah',
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                color: isMakkah
                                    ? Colors.blue.shade700
                                    : Colors.green.shade700,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${surah.jumlahAyat} Ayat',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Arabic Name
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      surah.nama,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryGreen,
                      ),
                    ),
                    Text(
                      surah.arti,
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: AppColors.primaryGreen),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
