import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/widgets/halo_avatar.dart';
import '../../../core/widgets/halo_button.dart';
import '../../auth/domain/user_model.dart';
import '../../chat/chat_providers.dart';
import '../presentation/providers/map_navigation_provider.dart';
import '../presentation/providers/location_tracker.dart';

class FriendBottomSheet extends ConsumerWidget {
  final String userId;
  final Map<String, dynamic> locationData;
  final UserModel? friend;

  const FriendBottomSheet({
    super.key,
    required this.userId,
    required this.locationData,
    this.friend,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final speed = locationData['speed'] as double? ?? 0;
    final timestamp = locationData['timestamp'] as String?;

    final name = friend?.displayName.isNotEmpty == true
        ? friend!.displayName
        : friend?.username ?? 'Bạn bè';

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
          HaloAvatar(
            imageUrl: friend?.avatarUrl,
            name: name,
            size: AppSizes.avatarLg,
            showBorder: true,
            isOnline: friend?.isOnline ?? false,
          ),
          const SizedBox(height: AppSizes.md),

          Text(
            name,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),

          if (friend != null) ...[
            const SizedBox(height: 4),
            Text(
              '@${friend!.username}',
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                color: AppColors.textTertiary,
              ),
            ),
          ],

          if (friend != null &&
              (friend!.statusEmoji.isNotEmpty ||
                  friend!.statusText.isNotEmpty)) ...[
            const SizedBox(height: AppSizes.sm),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(friend!.statusEmoji,
                      style: const TextStyle(fontSize: 16)),
                  if (friend!.statusText.isNotEmpty) ...[
                    const SizedBox(width: 4),
                    Text(
                      friend!.statusText,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],

          const SizedBox(height: AppSizes.sm),

          // Status info
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (locationData['precision'] == 'relative')
                const _InfoChip(
                  icon: Icons.my_location,
                  label: 'Khu vực 1km',
                )
              else
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
                  onPressed: () async {
                    Navigator.pop(context);
                    final roomId = await ref
                        .read(chatActionsProvider.notifier)
                        .getOrCreateDM(userId);
                    if (roomId != null && context.mounted) {
                      context.push(
                        '/chat/$roomId',
                        extra: {'friendName': name},
                      );
                    }
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
                    final myPos = ref.read(locationTrackerProvider);
                    final friendLat =
                        locationData['latitude'] as double?;
                    final friendLng =
                        locationData['longitude'] as double?;

                    if (myPos == null ||
                        friendLat == null ||
                        friendLng == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Không xác định được vị trí. Vui lòng thử lại.'),
                          backgroundColor: AppColors.error,
                        ),
                      );
                      return;
                    }

                    ref
                        .read(mapNavigationProvider.notifier)
                        .fetchRoute(
                          startLat: myPos.latitude,
                          startLng: myPos.longitude,
                          endLat: friendLat,
                          endLng: friendLng,
                          friendId: userId,
                        );

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
