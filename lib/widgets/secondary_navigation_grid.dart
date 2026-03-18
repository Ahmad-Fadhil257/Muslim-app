import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

/// Secondary Navigation Grid Item Model
class SecondaryNavigationItem {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;
  final bool isActive;

  const SecondaryNavigationItem({
    required this.label,
    required this.icon,
    required this.color,
    this.onTap,
    this.isActive = false,
  });

  SecondaryNavigationItem copyWith({
    String? label,
    IconData? icon,
    Color? color,
    VoidCallback? onTap,
    bool? isActive,
  }) {
    return SecondaryNavigationItem(
      label: label ?? this.label,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      onTap: onTap ?? this.onTap,
      isActive: isActive ?? this.isActive,
    );
  }
}

/// Secondary Navigation Grid Widget (3-column)
/// Displays "Catatan Ramadhan" section: Shalat, Ceramah, Infaq
class SecondaryNavigationGrid extends StatelessWidget {
  final String sectionTitle;
  final List<SecondaryNavigationItem> items;
  final int crossAxisCount;
  final double spacing;

  const SecondaryNavigationGrid({
    super.key,
    required this.sectionTitle,
    required this.items,
    this.crossAxisCount = 3,
    this.spacing = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingMedium,
        vertical: AppDimensions.paddingSmall,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title with icon (centered)
          Center(
            child: Padding(
              padding: const EdgeInsets.only(
                bottom: AppDimensions.paddingMedium,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.bookmark,
                      color: AppColors.primaryGreen,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    sectionTitle,
                    style: GoogleFonts.poppins(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: spacing,
              mainAxisSpacing: spacing,
              childAspectRatio: 0.9,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              return _SecondaryNavigationCard(item: items[index]);
            },
          ),
        ],
      ),
    );
  }
}

class _SecondaryNavigationCard extends StatefulWidget {
  final SecondaryNavigationItem item;

  const _SecondaryNavigationCard({required this.item});

  @override
  State<_SecondaryNavigationCard> createState() =>
      _SecondaryNavigationCardState();
}

class _SecondaryNavigationCardState extends State<_SecondaryNavigationCard> {
  bool _isPressed = false;

  void _onTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final isActive = item.isActive;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Card with icon (smaller, centered)
        Expanded(
          child: AnimatedScale(
            scale: _isPressed ? 0.92 : 1.0,
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeInOut,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: item.onTap,
                onTapDown: _onTapDown,
                onTapUp: _onTapUp,
                onTapCancel: _onTapCancel,
                borderRadius: BorderRadius.circular(
                  AppDimensions.borderRadiusSmall,
                ),
                splashColor: item.color.withValues(alpha: 0.15),
                highlightColor: item.color.withValues(alpha: 0.08),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  decoration: BoxDecoration(
                    color: isActive
                        ? item.color.withValues(alpha: 0.15)
                        : AppColors.secondaryWhite,
                    borderRadius: BorderRadius.circular(
                      AppDimensions.borderRadiusSmall,
                    ),
                    border: Border.all(
                      color: isActive
                          ? item.color.withValues(alpha: 0.4)
                          : Colors.transparent,
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isActive
                            ? item.color.withValues(alpha: 0.2)
                            : Colors.black.withValues(alpha: 0.05),
                        blurRadius: isActive ? 10 : 6,
                        offset: Offset(0, isActive ? 3 : 2),
                        spreadRadius: isActive ? 1 : 0,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      AppDimensions.borderRadiusSmall,
                    ),
                    child: Stack(
                      children: [
                        // Gradient overlay
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.white.withValues(
                                    alpha: isActive ? 0.95 : 0.92,
                                  ),
                                  isActive
                                      ? item.color.withValues(alpha: 0.08)
                                      : item.color.withValues(alpha: 0.02),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // Centered Icon
                        Center(
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: item.color.withValues(
                                alpha: isActive ? 0.25 : 0.12,
                              ),
                              borderRadius: BorderRadius.circular(
                                AppDimensions.borderRadiusSmall,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: item.color.withValues(
                                    alpha: isActive ? 0.25 : 0.1,
                                  ),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(item.icon, color: item.color, size: 24),
                          ),
                        ),

                        // Active indicator dot
                        if (isActive)
                          Positioned(
                            top: 6,
                            right: 6,
                            child: Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: item.color,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: item.color.withValues(alpha: 0.5),
                                    blurRadius: 3,
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 6),

        // Label below card (like bottom_nav_bar)
        Text(
          item.label,
          style: GoogleFonts.poppins(
            color: isActive ? item.color : AppColors.textPrimary,
            fontSize: 11,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
