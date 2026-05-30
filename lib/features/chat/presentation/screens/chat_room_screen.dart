import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../chat_providers.dart';
import '../../data/chat_repository.dart';
import '../widgets/message_bubble.dart';
import '../widgets/chat_input.dart';
import '../widgets/sticker_picker.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';

class ChatRoomScreen extends ConsumerStatefulWidget {
  final String roomId;

  /// Optional pre-cached friend name passed via route extra.
  /// When provided, the screen skips the extra DB query to load the title.
  final String? friendName;

  const ChatRoomScreen({super.key, required this.roomId, this.friendName});

  @override
  ConsumerState<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends ConsumerState<ChatRoomScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showStickerPicker = false;
  late String _roomTitle;
  bool _isLoadingMore = false;

  /// Tracks which user IDs are currently typing and when they started.
  final Map<String, DateTime> _typingUsers = {};

  Timer? _debounceTimer;
  Timer? _typingExpiryTimer;
  RealtimeChannel? _typingChannel;

  String get _currentUserId =>
      Supabase.instance.client.auth.currentUser?.id ?? '';

  @override
  void initState() {
    super.initState();
    _roomTitle = widget.friendName ?? 'Chat';
    if (widget.friendName == null) {
      _loadRoomTitle();
    }
    _subscribeToTyping();
    _scrollController.addListener(_onScroll);
  }

  /// When user scrolls near the top, load more older messages.
  void _onScroll() {
    if (_isLoadingMore) return;

    // Since the ListView is reversed, position 0 = bottom (newest).
    // maxScrollExtent = top (oldest). We trigger load when near the top.
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    const threshold = 200.0;

    if (currentScroll >= maxScroll - threshold) {
      _loadMoreMessages();
    }
  }

  Future<void> _loadMoreMessages() async {
    final notifier = ref.read(chatRoomMessagesProvider(widget.roomId).notifier);
    if (!notifier.hasMore) return;

    setState(() => _isLoadingMore = true);
    try {
      await notifier.loadMore();
    } finally {
      if (mounted) setState(() => _isLoadingMore = false);
    }
  }

  void _subscribeToTyping() {
    final repo = ref.read(chatRepositoryProvider);
    _typingChannel = repo.subscribeTyping(widget.roomId, _onTyping);
  }

  void _onTyping(Map<String, dynamic> payload) {
    final userId = payload['user_id'] as String?;
    if (userId == null || userId == _currentUserId) return;

    final now = DateTime.now();
    setState(() {
      _typingUsers[userId] = now;
    });

    // Remove typing status after 3 seconds of inactivity for that user
    _typingExpiryTimer?.cancel();
    _typingExpiryTimer = Timer(const Duration(seconds: 3), () {
      final cutoff = DateTime.now().subtract(const Duration(seconds: 3));
      setState(() {
        _typingUsers.removeWhere((_, time) => time.isBefore(cutoff));
      });
    });
  }

  /// Broadcasts a typing event to other room members, debounced to avoid
  /// flooding the channel. Called on every keystroke.
  void _broadcastTypingDebounced() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 1500), () {
      final repo = ref.read(chatRepositoryProvider);
      repo.broadcastTyping(widget.roomId);
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _typingExpiryTimer?.cancel();
    _typingChannel?.unsubscribe();
    _scrollController.removeListener(_onScroll);
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

    _debounceTimer?.cancel();
    await ref.read(chatActionsProvider.notifier).sendMessage(
          roomId: widget.roomId,
          content: content.trim(),
        );

    ref.invalidate(chatRoomsWithLastMessageProvider);
    _scrollToBottom();
  }

  Future<void> _sendSticker(String stickerUrl) async {
    await ref.read(chatActionsProvider.notifier).sendSticker(
          roomId: widget.roomId,
          stickerUrl: stickerUrl,
        );

    ref.invalidate(chatRoomsWithLastMessageProvider);
    setState(() => _showStickerPicker = false);
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final messagesAsync = ref.watch(chatRoomMessagesProvider(widget.roomId));
    final typingUsersCount = _typingUsers.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(_roomTitle),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, size: 20),
        ),
      ),
      body: Column(
        children: [
          // Typing indicator
          if (typingUsersCount > 0)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.md,
                vertical: AppSizes.xs,
              ),
              color: AppColors.surface,
              child: Row(
                children: [
                  const _TypingDots(),
                  const SizedBox(width: 8),
                  Text(
                    typingUsersCount == 1 ? 'đang nhập...' : 'có người đang nhập...',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      color: AppColors.textTertiary,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),

          // Messages list
          Expanded(
            child: messagesAsync.when(
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
                  // +1 for the loading indicator at the top
                  itemCount: messages.length + (_isLoadingMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    // Loading indicator at the "top" (which is the last item
                    // because the list is reversed)
                    if (_isLoadingMore && index == messages.length) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Center(
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      );
                    }

                    final msg = messages[messages.length - 1 - index];
                    final senderId = msg['sender_id'] as String? ?? '';
                    final isMe = senderId == _currentUserId;
                    final content = msg['content'] as String? ?? '';
                    final type = msg['message_type'] as String? ?? 'text';
                    final stickerUrl = msg['sticker_url'] as String?;
                    final createdAt = msg['created_at'] as String?;
                    final metadata =
                        msg['metadata'] as Map<String, dynamic>? ?? {};

                    final msgId = msg['id'] as String? ?? index.toString();

                    return MessageBubble(
                      key: ValueKey(msgId),
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
            onTyping: _broadcastTypingDebounced,
            showingStickerPicker: _showStickerPicker,
          ),
        ],
      ),
    );
  }

  Future<void> _loadRoomTitle() async {
    try {
      final repo = ref.read(chatRepositoryProvider);
      final members = await repo.getRoomMembers(widget.roomId);
      for (final member in members) {
        final userId = member['user_id'] as String?;
        if (userId != null && userId != _currentUserId) {
          final profile = member['profiles'] as Map<String, dynamic>?;
          if (profile != null && mounted) {
            setState(() {
              _roomTitle = profile['display_name'] as String? ??
                  profile['username'] as String? ??
                  'Chat';
            });
          }
          break;
        }
      }
    } catch (_) {
      // Keep default title
    }
  }
}

/// Animated bouncing dots indicating active typing.
class _TypingDots extends StatefulWidget {
  const _TypingDots();

  @override
  State<_TypingDots> createState() => _TypingDotsState();
}

class _TypingDotsState extends State<_TypingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            final delay = index * 0.2;
            final value =
                ((_controller.value + delay) % 1.0);
            final scale = (value < 0.5 ? value * 2 : (1 - value) * 2)
                .clamp(0.0, 1.0);
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 1.5),
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: AppColors.textTertiary.withValues(alpha: 0.3 + scale * 0.7),
                shape: BoxShape.circle,
              ),
            );
          }),
        );
      },
    );
  }
}