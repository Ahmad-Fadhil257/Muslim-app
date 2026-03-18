import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';

/// Circular counter display widget for Tasbih
class CounterCircle extends StatefulWidget {
  final int count;
  final int? limit;
  final double size;
  final VoidCallback onTap;

  const CounterCircle({
    super.key,
    required this.count,
    this.limit,
    this.size = 200,
    required this.onTap,
  });

  @override
  State<CounterCircle> createState() => _CounterCircleState();
}

class _CounterCircleState extends State<CounterCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTap() {
    _animationController.forward().then((_) {
      _animationController.reverse();
    });
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(scale: _scaleAnimation.value, child: child);
        },
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primaryGreen,
            border: Border.all(color: AppColors.accentGold, width: 3),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryGreen.withOpacity(0.3),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Center(
            child: Container(
              width: widget.size - 30,
              height: widget.size - 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secondaryWhite,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Count number
                  Text(
                    widget.count.toString(),
                    style: GoogleFonts.poppins(
                      fontSize: 72,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                  // Limit indicator
                  if (widget.limit != null)
                    Text(
                      '${widget.count} / ${widget.limit}',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        color: AppColors.textSecondary,
                      ),
                    )
                  else
                    Text(
                      'Bebas',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        color: AppColors.textSecondary,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
