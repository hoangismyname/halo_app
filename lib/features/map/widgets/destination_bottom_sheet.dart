import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/widgets/halo_button.dart';
import '../presentation/providers/location_tracker.dart';
import '../presentation/providers/map_navigation_provider.dart';

/// Bottom sheet shown when the user long-presses on the map to navigate
/// to an arbitrary coordinate (not a friend).
class DestinationBottomSheet extends ConsumerWidget {
  final double latitude;
  final double longitude;

  const DestinationBottomSheet({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.lg),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.textTertiary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: AppSizes.lg),

          // Destination icon
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.secondaryDark.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.secondaryDark.withValues(alpha: 0.4),
              ),
            ),
            child: const Icon(
              Icons.place,
              color: AppColors.secondaryDark,
              size: 32,
            ),
          ),
          const SizedBox(height: AppSizes.md),

          const Text(
            'Điểm đến',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),

          // Coordinate info
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.my_location,
                  size: 14,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 6),
                Text(
                  '${latitude.toStringAsFixed(5)}, ${longitude.toStringAsFixed(5)}',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.lg),

          // Navigate button
          SizedBox(
            width: double.infinity,
            child: HaloButton(
              text: 'Chỉ đường đến đây',
              icon: Icons.directions,
              onPressed: () {
                final myPos = ref.read(locationTrackerProvider);

                if (myPos == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Không xác định được vị trí của bạn. Vui lòng thử lại.',
                      ),
                      backgroundColor: AppColors.error,
                    ),
                  );
                  return;
                }

                ref.read(mapNavigationProvider.notifier).fetchRoute(
                  startLat: myPos.latitude,
                  startLng: myPos.longitude,
                  endLat: latitude,
                  endLng: longitude,
                );

                Navigator.pop(context);
              },
            ),
          ),

          SizedBox(height: MediaQuery.paddingOf(context).bottom + AppSizes.sm),
        ],
      ),
    );
  }
}
