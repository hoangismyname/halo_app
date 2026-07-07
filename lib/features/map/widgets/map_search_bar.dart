import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class MapSearchBar extends StatelessWidget {
  final VoidCallback? onTap;

  const MapSearchBar({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 35,
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            SizedBox(width: 12),
            Icon(Icons.search, color: AppColors.textSecondary, size: 16),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Tìm kiếm...',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            SizedBox(width: 12),
          ],
        ),
      ),
    );
  }
}
