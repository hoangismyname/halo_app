import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class MapControls extends StatelessWidget {
  final VoidCallback onMyLocation;
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;

  const MapControls({
    super.key,
    required this.onMyLocation,
    required this.onZoomIn,
    required this.onZoomOut,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ControlButton(
          icon: Icons.my_location,
          onTap: onMyLocation,
          color: AppColors.primary,
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 8,
              ),
            ],
          ),
          child: Column(
            children: [
              _ControlButton(
                icon: Icons.add,
                onTap: onZoomIn,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              ),
              Container(height: 1, color: AppColors.divider),
              _ControlButton(
                icon: Icons.remove,
                onTap: onZoomOut,
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? color;
  final BorderRadius? borderRadius;

  const _ControlButton({
    required this.icon,
    required this.onTap,
    this.color,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color == null
          ? Colors.transparent
          : AppColors.surface.withValues(alpha: 0.9),
      borderRadius: borderRadius ?? BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        child: Container(
          width: 44,
          height: 44,
          decoration: color != null && borderRadius == null
              ? BoxDecoration(
                  color: AppColors.surface.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 8,
                    ),
                  ],
                )
              : null,
          child: Icon(
            icon,
            color: color ?? AppColors.textPrimary,
            size: 22,
          ),
        ),
      ),
    );
  }
}
