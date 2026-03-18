import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '../viewmodel/doa_view_model.dart';
import '../model/doa.dart';
import '../theme/app_theme.dart';

class DoaPage extends StatefulWidget {
  static const routeName = '/doa';
  const DoaPage({super.key});

  @override
  State<DoaPage> createState() => _DoaPageState();
}

class _DoaPageState extends State<DoaPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DoaViewModel>().fetchDoaList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DoaViewModel>();

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
                                  Icons.auto_awesome,
                                  color: AppColors.accentGold,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Doa Harian',
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
                    const SizedBox(height: 8),
                    Text(
                      'Kumpulan doa sehari-hari',
                      style: GoogleFonts.inter(
                        color: AppColors.secondaryWhite.withValues(alpha: 0.8),
                        fontSize: 14,
                      ),
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
                          hintText: 'Cari doa...',
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

              // Doa List
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
                                FilledButton(
                                  onPressed: () {
                                    context.read<DoaViewModel>().fetchDoaList();
                                  },
                                  style: FilledButton.styleFrom(
                                    backgroundColor: AppColors.primaryGreen,
                                  ),
                                  child: const Text('Coba Lagi'),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      if (vm.list.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.auto_awesome_outlined,
                                size: 64,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Tidak ada data',
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      // Filter doa based on search query
                      final filteredDoa = vm.list.where((doa) {
                        if (_searchQuery.isEmpty) return true;
                        return doa.doa.toLowerCase().contains(_searchQuery) ||
                            doa.arti.toLowerCase().contains(_searchQuery);
                      }).toList();

                      if (filteredDoa.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 64,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Doa tidak ditemukan',
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
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
                        itemCount: filteredDoa.length,
                        itemBuilder: (context, i) {
                          final item = filteredDoa[i];
                          return _DoaCard(
                            doa: item,
                            index: i + 1,
                            onTap: () => _showDoaDetail(context, item, i + 1),
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

  void _showDoaDetail(BuildContext context, DoaModel doa, int index) {
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
                    margin: const EdgeInsets.all(AppDimensions.paddingMedium),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: AppColors.headerGradient,
                      ),
                      borderRadius: BorderRadius.circular(
                        AppDimensions.borderRadiusMedium,
                      ),
                    ),
                    child: Column(
                      children: [
                        // Number Badge
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppColors.accentGold,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Center(
                            child: Text(
                              '$index',
                              style: GoogleFonts.poppins(
                                color: AppColors.darkGreen,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          doa.doa,
                          style: GoogleFonts.poppins(
                            color: AppColors.secondaryWhite,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          doa.arti,
                          style: GoogleFonts.inter(
                            color: AppColors.secondaryWhite.withValues(
                              alpha: 0.8,
                            ),
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
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
                          // Arabic Text
                          if (doa.ayat.isNotEmpty) ...[
                            _SectionTitle(
                              icon: Icons.format_quote,
                              title: 'Arab',
                            ),
                            const SizedBox(height: 12),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: AppColors.primaryGreen.withValues(
                                  alpha: 0.05,
                                ),
                                borderRadius: BorderRadius.circular(
                                  AppDimensions.borderRadiusMedium,
                                ),
                                border: Border.all(
                                  color: AppColors.primaryGreen.withValues(
                                    alpha: 0.2,
                                  ),
                                ),
                              ),
                              child: Text(
                                doa.ayat,
                                style: GoogleFonts.amiri(
                                  fontSize: 24,
                                  color: AppColors.primaryGreen,
                                  height: 1.8,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],

                          // Latin
                          if (doa.latin.isNotEmpty) ...[
                            _SectionTitle(
                              icon: Icons.translate,
                              title: 'Latin',
                            ),
                            const SizedBox(height: 12),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.cardBackground,
                                borderRadius: BorderRadius.circular(
                                  AppDimensions.borderRadiusMedium,
                                ),
                              ),
                              child: Text(
                                doa.latin,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: AppColors.textPrimary,
                                  height: 1.6,
                                  fontStyle: FontStyle.italic,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],

                          // Arti
                          if (doa.arti.isNotEmpty) ...[
                            _SectionTitle(
                              icon: Icons.book_outlined,
                              title: 'Arti',
                            ),
                            const SizedBox(height: 12),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.cardBackground,
                                borderRadius: BorderRadius.circular(
                                  AppDimensions.borderRadiusMedium,
                                ),
                              ),
                              child: Text(
                                doa.arti,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: AppColors.textPrimary,
                                  height: 1.6,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ],
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

class _DoaCard extends StatelessWidget {
  final DoaModel doa;
  final int index;
  final VoidCallback onTap;

  const _DoaCard({required this.doa, required this.index, required this.onTap});

  @override
  Widget build(BuildContext context) {
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
                // Number Badge
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
                      '$index',
                      style: GoogleFonts.poppins(
                        color: AppColors.secondaryWhite,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),

                // Doa Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doa.doa,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        doa.arti,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // Arrow
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.chevron_right,
                    color: AppColors.primaryGreen,
                    size: 20,
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

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionTitle({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primaryGreen),
        const SizedBox(width: 8),
        Text(
          title,
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
