import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../chat_providers.dart';
import '../widgets/message_bubble.dart';
import '../widgets/chat_input.dart';
import '../widgets/sticker_picker.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';

class ChatRoomScreen extends ConsumerStatefulWidget {
  final String roomId;

  const ChatRoomScreen({super.key, required this.roomId});

  @override
  ConsumerState<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends ConsumerState<ChatRoomScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showStickerPicker = false;

  String get _currentUserId =>
      Supabase.instance.client.auth.currentUser?.id ?? '';

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _sendMessage(String content) async {
    if (content.trim().isEmpty) return;

    await ref.read(chatActionsProvider.notifier).sendMessage(
          roomId: widget.roomId,
          content: content.trim(),
        );

    _scrollToBottom();
  }

  Future<void> _sendSticker(String stickerUrl) async {
    await ref.read(chatActionsProvider.notifier).sendSticker(
          roomId: widget.roomId,
          stickerUrl: stickerUrl,
        );

    setState(() => _showStickerPicker = false);
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final messagesStream = ref.watch(messagesStreamProvider(widget.roomId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, size: 20),
        ),
      ),
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: messagesStream.when(
              data: (messages) {
                if (messages.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.chat_bubble_outline,
                            size: 48,
                            color: AppColors.textTertiary.withValues(alpha: 0.3)),
                        const SizedBox(height: AppSizes.md),
                        const Text(
                          'Bắt đầu cuộc trò chuyện!',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.md, vertical: AppSizes.sm),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[messages.length - 1 - index];
                    final senderId = msg['sender_id'] as String? ?? '';
                    final isMe = senderId == _currentUserId;
                    final content = msg['content'] as String? ?? '';
                    final type = msg['message_type'] as String? ?? 'text';
                    final stickerUrl = msg['sticker_url'] as String?;
                    final createdAt = msg['created_at'] as String?;
                    final metadata =
                        msg['metadata'] as Map<String, dynamic>? ?? {};

                    return MessageBubble(
                      content: content,
                      isMe: isMe,
                      messageType: type,
                      stickerUrl: stickerUrl,
                      metadata: metadata,
                      timestamp: createdAt != null
                          ? DateTime.tryParse(createdAt)
                          : null,
                    );
                  },
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
              error: (error, _) => Center(
                child: Text('Lỗi: $error',
                    style: const TextStyle(color: AppColors.error)),
              ),
            ),
          ),

          // Sticker picker
          if (_showStickerPicker)
            StickerPicker(
              onStickerSelected: _sendSticker,
              onClose: () => setState(() => _showStickerPicker = false),
            ),

          // Chat input
          ChatInput(
            onSend: _sendMessage,
            onStickerTap: () =>
                setState(() => _showStickerPicker = !_showStickerPicker),
            showingStickerPicker: _showStickerPicker,
          ),
        ],
      ),
    );
  }
}
