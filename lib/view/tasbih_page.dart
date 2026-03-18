import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../theme/app_theme.dart';
import '../viewmodel/tasbih_view_model.dart';
import '../widgets/dhikr_card.dart';
import '../widgets/counter_circle.dart';
import '../widgets/limit_option_button.dart';

/// Tasbih (Dhikr) Counter Page
/// Features:
/// - Selectable dhikr types (Subhanallah, Alhmadulillah, Allahu Akbar)
/// - Circular counter with tap-to-increment
/// - Limit options (33, 99, Bebas/unlimited)
/// - Reset functionality
class TasbihPage extends StatelessWidget {
  static const routeName = '/tasbih';

  const TasbihPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TasbihViewModel(),
      child: Scaffold(
        backgroundColor: AppColors.cardBackground,
        appBar: AppBar(
          backgroundColor: AppColors.primaryGreen,
          foregroundColor: AppColors.secondaryWhite,
          elevation: 0,
          title: Text(
            'Tasbih (Dhikr)',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
          child: Consumer<TasbihViewModel>(
            builder: (context, vm, _) {
              return Column(
                children: [
                  const SizedBox(height: AppDimensions.paddingMedium),

                  // Top Bar - Dhikr Selection
                  _buildDhikrSelector(vm),

                  // Main Counter Area
                  Expanded(
                    child: Center(
                      child: CounterCircle(
                        count: vm.count,
                        limit: vm.limit,
                        onTap: vm.increment,
                      ),
                    ),
                  ),

                  // Bottom Limit Options
                  _buildLimitOptions(vm),

                  const SizedBox(height: AppDimensions.paddingLarge),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  /// Build the dhikr selection row
  Widget _buildDhikrSelector(TasbihViewModel vm) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingMedium,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          DhikrCard(
            arabicText: DhikrType.subhanallah.arabicText,
            transliteration: DhikrType.subhanallah.transliteration,
            isSelected: vm.selectedDhikr == DhikrType.subhanallah,
            onTap: () => vm.selectDhikr(DhikrType.subhanallah),
          ),
          DhikrCard(
            arabicText: DhikrType.alhmadulillah.arabicText,
            transliteration: DhikrType.alhmadulillah.transliteration,
            isSelected: vm.selectedDhikr == DhikrType.alhmadulillah,
            onTap: () => vm.selectDhikr(DhikrType.alhmadulillah),
          ),
          DhikrCard(
            arabicText: DhikrType.allahuAkbar.arabicText,
            transliteration: DhikrType.allahuAkbar.transliteration,
            isSelected: vm.selectedDhikr == DhikrType.allahuAkbar,
            onTap: () => vm.selectDhikr(DhikrType.allahuAkbar),
          ),
        ],
      ),
    );
  }

  /// Build the limit options row
  Widget _buildLimitOptions(TasbihViewModel vm) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingMedium,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              LimitOptionButton(
                label: '33',
                isSelected: vm.limit == 33,
                onTap: () => vm.setLimit(33),
              ),
              LimitOptionButton(
                label: '99',
                isSelected: vm.limit == 99,
                onTap: () => vm.setLimit(99),
              ),
              LimitOptionButton(
                label: 'Bebas',
                isSelected: vm.limit == null,
                onTap: () => vm.setLimit(null),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingMedium),
          // Reset Button
          GestureDetector(
            onTap: vm.reset,
            child: Container(
              width: 120,
              height: 45,
              decoration: BoxDecoration(
                color: Colors.red.shade600,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.shade600.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  'Reset',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondaryWhite,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
