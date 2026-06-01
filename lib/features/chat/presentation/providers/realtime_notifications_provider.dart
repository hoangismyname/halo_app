import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/halo_avatar.dart';
import '../../../../core/widgets/top_snackbar.dart';
import '../../../../core/router/app_router.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

part 'realtime_notifications_provider.g.dart';

@Riverpod(keepAlive: true)
class RealtimeNotifications extends _$RealtimeNotifications {
  RealtimeChannel? _messageChannel;
  RealtimeChannel? _friendshipChannel;

  @override
  void build() {
    final user = ref.watch(currentUserProvider);
    if (user == null) {
      _unsubscribe();
      return;
    }

    _subscribe(user.id);

    ref.onDispose(() {
      _unsubscribe();
    });
  }

  void _unsubscribe() {
    _messageChannel?.unsubscribe();
    _messageChannel = null;
    _friendshipChannel?.unsubscribe();
    _friendshipChannel = null;
  }

  void _subscribe(String currentUserId) {
    final client = Supabase.instance.client;

    // 1. Subscribe to new messages
    _messageChannel = client.channel('global-messages');
    _messageChannel!
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'messages',
          callback: (payload) async {
            final newRecord = payload.newRecord;
            final senderId = newRecord['sender_id'] as String?;
            final roomId = newRecord['room_id'] as String?;
            final content = newRecord['content'] as String? ?? '';
            final messageType = newRecord['message_type'] as String? ?? 'text';

            // Ignore messages sent by ourselves
            if (senderId == null || senderId == currentUserId || roomId == null)
              return;

            // Fetch sender's profile
            try {
              final profileData = await client
                  .from('profiles')
                  .select('display_name, username, avatar_url')
                  .eq('id', senderId)
                  .maybeSingle();

              if (profileData == null) return;

              final displayName = profileData['display_name'] as String? ?? '';
              final username = profileData['username'] as String? ?? '';
              final avatarUrl = profileData['avatar_url'] as String?;
              final senderName = displayName.isNotEmpty
                  ? displayName
                  : username;

              final context = rootNavigatorKey.currentContext;
              if (context != null && context.mounted) {
                String displayContent = content;
                if (messageType == 'sticker') {
                  displayContent = '🎨 Đã gửi một sticker';
                } else if (messageType == 'location') {
                  displayContent = '📍 Đã chia sẻ vị trí';
                }

                _showNotification(
                  context: context,
                  title: senderName,
                  body: displayContent,
                  avatarUrl: avatarUrl,
                  icon: Icons.chat_bubble_outline,
                  iconColor: AppColors.primary,
                  onTap: () {
                    context.push(
                      '/chat/$roomId',
                      extra: {'friendName': senderName},
                    );
                  },
                );
              }
            } catch (e) {
              debugPrint('Error getting sender info for notification: $e');
            }
          },
        )
        .subscribe();

    // 2. Subscribe to friend requests (friendships table pending requests)
    _friendshipChannel = client.channel('global-friendships');
    _friendshipChannel!
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'friendships',
          callback: (payload) async {
            final newRecord = payload.newRecord;
            final userId = newRecord['user_id'] as String?;
            final friendId = newRecord['friend_id'] as String?;
            final status = newRecord['status'] as String?;

            // Check if it's a pending request sent to the current user
            if (userId == null ||
                friendId != currentUserId ||
                status != 'pending')
              return;

            // Fetch sender's profile
            try {
              final profileData = await client
                  .from('profiles')
                  .select('display_name, username, avatar_url')
                  .eq('id', userId)
                  .maybeSingle();

              if (profileData == null) return;

              final displayName = profileData['display_name'] as String? ?? '';
              final username = profileData['username'] as String? ?? '';
              final avatarUrl = profileData['avatar_url'] as String?;
              final senderName = displayName.isNotEmpty
                  ? displayName
                  : username;

              final context = rootNavigatorKey.currentContext;
              if (context != null && context.mounted) {
                _showNotification(
                  context: context,
                  title: 'Lời mời kết bạn mới',
                  body: '$senderName muốn kết bạn với bạn!',
                  avatarUrl: avatarUrl,
                  icon: Icons.person_add_outlined,
                  iconColor: AppColors.warning,
                  onTap: () {
                    context.go('/friends');
                  },
                );
              }
            } catch (e) {
              debugPrint('Error getting friendship sender info: $e');
            }
          },
        )
        .subscribe();
  }

  void _showNotification({
    required BuildContext context,
    required String title,
    required String body,
    required String? avatarUrl,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    TopSnackBar.show(
      context,
      duration: const Duration(seconds: 4),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSizes.md),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          border: Border.all(
            color: iconColor.withValues(alpha: 0.35),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: iconColor.withValues(alpha: 0.2),
              blurRadius: 16,
              spreadRadius: 2,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            HaloAvatar(
              imageUrl: avatarUrl,
              name: title,
              size: AppSizes.avatarMd,
            ),
            const SizedBox(width: AppSizes.md),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    body,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSizes.sm),
            Icon(icon, color: iconColor, size: 22),
          ],
        ),
      ),
    );
  }
}
