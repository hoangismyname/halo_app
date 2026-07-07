import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class Map3DToggleButton extends StatelessWidget {
  final bool is3DEnabled;
  final VoidCallback onTap;
  final BorderRadius? borderRadius;

  const Map3DToggleButton({
    super.key,
    required this.is3DEnabled,
    required this.onTap,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: borderRadius ?? BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        child: SizedBox(
          width: 44,
          height: 44,
          child: Center(
            child: Text(
              is3DEnabled ? '2D' : '3D',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: is3DEnabled ? AppColors.primary : AppColors.textPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
