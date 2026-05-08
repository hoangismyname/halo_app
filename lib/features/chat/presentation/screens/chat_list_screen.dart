import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../chat_providers.dart';
import '../../domain/chat_room_model.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/halo_avatar.dart';

class ChatListScreen extends ConsumerWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatRoomsAsync = ref.watch(chatRoomsWithLastMessageProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tin nhắn'),
        actions: [
          IconButton(
            onPressed: () {
              // Create new chat
            },
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.edit, size: 18, color: Colors.white),
            ),
          ),
        ],
      ),
      body: chatRoomsAsync.when(
        data: (rooms) {
          if (rooms.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    size: 64,
                    color: AppColors.textTertiary.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: AppSizes.md),
                  const Text(
                    'Chưa có cuộc trò chuyện',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textTertiary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Bắt đầu nhắn tin với bạn bè!',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: AppSizes.sm),
            itemCount: rooms.length,
            itemBuilder: (context, index) {
              final data = rooms[index];
              final room = data['room'] as ChatRoomModel;
              final lastMessage = data['last_message'] as String?;
              final lastMessageType = data['last_message_type'] as String?;
              final lastMessageTime = data['last_message_time'] as String?;
              final otherName = data['other_name'] as String? ?? 'Chat';
              final otherAvatar = data['other_avatar'] as String?;
              final otherOnline = data['other_online'] as bool? ?? false;

              return _ChatRoomTile(
                roomId: room.id,
                name: otherName,
                isGroup: room.isGroup,
                avatarUrl: otherAvatar,
                isOnline: otherOnline,
                lastMessage: lastMessage,
                lastMessageType: lastMessageType,
                lastMessageTime: lastMessageTime,
                onTap: () => context.push('/chat/${room.id}'),
              );
            },
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (error, _) => Center(
          child: Text(
            'Lỗi tải tin nhắn',
            style: TextStyle(color: AppColors.error),
          ),
        ),
      ),
    );
  }
}

class _ChatRoomTile extends StatelessWidget {
  final String roomId;
  final String name;
  final bool isGroup;
  final String? avatarUrl;
  final bool isOnline;
  final String? lastMessage;
  final String? lastMessageType;
  final String? lastMessageTime;
  final VoidCallback onTap;

  const _ChatRoomTile({
    required this.roomId,
    required this.name,
    required this.isGroup,
    this.avatarUrl,
    this.isOnline = false,
    this.lastMessage,
    this.lastMessageType,
    this.lastMessageTime,
    required this.onTap,
  });

  String _getMessagePreview() {
    if (lastMessage == null) return 'Nhấn để xem tin nhắn';
    switch (lastMessageType) {
      case 'sticker':
        return '🎨 Sticker';
      case 'image':
        return '📷 Ảnh';
      case 'location':
        return '📍 Vị trí';
      default:
        return lastMessage!;
    }
  }

  String _formatTime(String? timestamp) {
    if (timestamp == null) return '';
    try {
      final dt = DateTime.parse(timestamp);
      final now = DateTime.now();
      final diff = now.difference(dt);

      if (diff.inMinutes < 1) return 'Vừa xong';
      if (diff.inMinutes < 60) return '${diff.inMinutes}p';
      if (diff.inHours < 24) return '${diff.inHours}h';
      if (diff.inDays < 7) return '${diff.inDays}d';
      return '${dt.day}/${dt.month}';
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: AppSizes.md, vertical: AppSizes.xs),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSizes.md, vertical: AppSizes.xs),
        leading: HaloAvatar(
          imageUrl: avatarUrl,
          name: name,
          size: AppSizes.avatarMd,
          isOnline: isOnline,
        ),
        title: Text(
          name,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: Text(
          _getMessagePreview(),
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 13,
            color: AppColors.textTertiary,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (lastMessageTime != null)
              Text(
                _formatTime(lastMessageTime),
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 11,
                  color: AppColors.textTertiary,
                ),
              ),
            if (isGroup) ...[
              const SizedBox(height: 4),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Nhóm',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 10,
                    color: AppColors.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
