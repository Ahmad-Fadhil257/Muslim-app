import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

/// Main Navigation Grid Item Model
class NavigationItem {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;
  final bool isActive;

  const NavigationItem({
    required this.label,
    required this.icon,
    required this.color,
    this.onTap,
    this.isActive = false,
  });

  NavigationItem copyWith({
    String? label,
    IconData? icon,
    Color? color,
    VoidCallback? onTap,
    bool? isActive,
  }) {
    return NavigationItem(
      label: label ?? this.label,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      onTap: onTap ?? this.onTap,
      isActive: isActive ?? this.isActive,
    );
  }
}

/// Main Navigation Grid Widget (2-column)
/// Displays primary features: Al-Quran, Jadwal, Doa Harian, Kiblat, AI
class MainNavigationGrid extends StatelessWidget {
  final List<NavigationItem> items;
  final int crossAxisCount;
  final double spacing;

  const MainNavigationGrid({
    super.key,
    required this.items,
    this.crossAxisCount = 2,
    this.spacing = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingMedium,
        vertical: AppDimensions.paddingSmall,
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: spacing,
          mainAxisSpacing: spacing,
          childAspectRatio: 1.1,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          return _MainNavigationCard(item: items[index]);
        },
      ),
    );
  }
}

class _MainNavigationCard extends StatefulWidget {
  final NavigationItem item;

  const _MainNavigationCard({required this.item});

  @override
  State<_MainNavigationCard> createState() => _MainNavigationCardState();
}

class _MainNavigationCardState extends State<_MainNavigationCard> {
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
                  AppDimensions.borderRadiusMedium,
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
                      AppDimensions.borderRadiusMedium,
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
                        blurRadius: isActive ? 12 : 8,
                        offset: Offset(0, isActive ? 4 : 2),
                        spreadRadius: isActive ? 1 : 0,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      AppDimensions.borderRadiusMedium,
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
                                      ? item.color.withValues(alpha: 0.1)
                                      : item.color.withValues(alpha: 0.03),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // Centered Icon
                        Center(
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: item.color.withValues(
                                alpha: isActive ? 0.25 : 0.15,
                              ),
                              borderRadius: BorderRadius.circular(
                                AppDimensions.borderRadiusSmall,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: item.color.withValues(
                                    alpha: isActive ? 0.3 : 0.15,
                                  ),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(item.icon, color: item.color, size: 28),
                          ),
                        ),

                        // Active indicator dot
                        if (isActive)
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: item.color,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: item.color.withValues(alpha: 0.5),
                                    blurRadius: 4,
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

        const SizedBox(height: 8),

        // Label below card (like bottom_nav_bar)
        Text(
          item.label,
          style: GoogleFonts.poppins(
            color: isActive ? item.color : AppColors.textPrimary,
            fontSize: 12,
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
