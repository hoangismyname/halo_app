import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/widgets/halo_avatar.dart';
import '../../../core/widgets/halo_button.dart';

class FriendBottomSheet extends ConsumerWidget {
  final String userId;
  final Map<String, dynamic> locationData;

  const FriendBottomSheet({
    super.key,
    required this.userId,
    required this.locationData,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final speed = locationData['speed'] as double? ?? 0;
    final timestamp = locationData['timestamp'] as String?;

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

          // Avatar & Name
          const HaloAvatar(
            size: AppSizes.avatarLg,
            showBorder: true,
            isOnline: true,
          ),
          const SizedBox(height: AppSizes.md),

          Text(
            'Bạn bè',
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: AppSizes.sm),

          // Status info
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _InfoChip(
                icon: Icons.speed,
                label: '${speed.toStringAsFixed(0)} km/h',
              ),
              const SizedBox(width: AppSizes.sm),
              if (timestamp != null)
                _InfoChip(
                  icon: Icons.access_time,
                  label: _formatTime(timestamp),
                ),
            ],
          ),

          const SizedBox(height: AppSizes.lg),

          // Actions
          Row(
            children: [
              Expanded(
                child: HaloButton(
                  text: 'Nhắn tin',
                  icon: Icons.chat_bubble_outline,
                  onPressed: () {
                    Navigator.pop(context);
                    // Navigate to chat
                  },
                ),
              ),
              const SizedBox(width: AppSizes.md),
              Expanded(
                child: HaloButton(
                  text: 'Chỉ đường',
                  icon: Icons.directions,
                  outlined: true,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),

          SizedBox(height: MediaQuery.paddingOf(context).bottom + AppSizes.sm),
        ],
      ),
    );
  }

  String _formatTime(String timestamp) {
    try {
      final dt = DateTime.parse(timestamp);
      final diff = DateTime.now().difference(dt);
      if (diff.inMinutes < 1) return 'Vừa xong';
      if (diff.inMinutes < 60) return '${diff.inMinutes}p trước';
      return '${diff.inHours}h trước';
    } catch (_) {
      return '';
    }
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.primary),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
