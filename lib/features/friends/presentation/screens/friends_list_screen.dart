import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/friends_provider.dart';
import '../../../auth/domain/user_model.dart';
import '../../../chat/chat_providers.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/halo_avatar.dart';

class FriendsListScreen extends ConsumerWidget {
  const FriendsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final friendsAsync = ref.watch(friendsListProvider);
    final pendingAsync = ref.watch(pendingRequestsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bạn bè'),
        actions: [
          IconButton(
            onPressed: () => context.push('/add-friend'),
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.person_add,
                size: 20,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Pending requests section
          pendingAsync.when(
            data: (requests) {
              if (requests.isEmpty) return const SliverToBoxAdapter();
              return SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSizes.md,
                        AppSizes.md,
                        AppSizes.md,
                        AppSizes.sm,
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.warning.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${requests.length}',
                              style: const TextStyle(
                                color: AppColors.warning,
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Lời mời kết bạn',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ...requests.map((req) => _RequestTile(request: req)),
                    const Divider(height: 24),
                  ],
                ),
              );
            },
            loading: () => const SliverToBoxAdapter(),
            error: (_, _) => const SliverToBoxAdapter(),
          ),

          // Friends list
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
            sliver: friendsAsync.when(
              data: (friends) {
                if (friends.isEmpty) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.people_outline,
                            size: 64,
                            color: AppColors.textTertiary.withValues(
                              alpha: 0.5,
                            ),
                          ),
                          const SizedBox(height: AppSizes.md),
                          const Text(
                            'Chưa có bạn bè',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textTertiary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Thêm bạn bè để bắt đầu kết nối!',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              color: AppColors.textTertiary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final friend = friends[index];
                    return _FriendTile(friend: friend);
                  }, childCount: friends.length),
                );
              },
              loading: () => const SliverFillRemaining(
                child: Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              ),
              error: (error, _) => SliverFillRemaining(
                child: Center(
                  child: Text(
                    'Lỗi tải danh sách bạn bè',
                    style: TextStyle(color: AppColors.error),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Friend Tile ─────────────────────────────────────────────────────────────

class _FriendTile extends ConsumerStatefulWidget {
  final UserModel friend;

  const _FriendTile({required this.friend});

  @override
  ConsumerState<_FriendTile> createState() => _FriendTileState();
}

class _FriendTileState extends ConsumerState<_FriendTile> {
  bool _isLoadingChat = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.sm),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSizes.md,
          vertical: AppSizes.xs,
        ),
        leading: HaloAvatar(
          imageUrl: widget.friend.avatarUrl,
          name: widget.friend.displayName.isNotEmpty
              ? widget.friend.displayName
              : widget.friend.username,
          isOnline: widget.friend.isOnline,
          size: AppSizes.avatarMd,
        ),
        title: Text(
          widget.friend.displayName.isNotEmpty
              ? widget.friend.displayName
              : widget.friend.username,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: Row(
          children: [
            Text(
              widget.friend.statusEmoji,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                widget.friend.statusText.isNotEmpty
                    ? widget.friend.statusText
                    : '@${widget.friend.username}',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  color: AppColors.textTertiary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        trailing: _isLoadingChat
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.primary,
                ),
              )
            : IconButton(
                onPressed: () async {
                  setState(() => _isLoadingChat = true);
                  try {
                    final roomId = await ref
                        .read(chatActionsProvider.notifier)
                        .getOrCreateDM(widget.friend.id);
                    if (context.mounted) {
                      if (roomId != null) {
                        context.push('/chat/$roomId');
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Không thể mở cuộc trò chuyện.'),
                            backgroundColor: AppColors.error,
                          ),
                        );
                      }
                    }
                  } finally {
                    if (mounted) setState(() => _isLoadingChat = false);
                  }
                },
                icon: const Icon(
                  Icons.chat_bubble_outline,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
      ),
    );
  }
}

// ─── Request Tile ─────────────────────────────────────────────────────────────

class _RequestTile extends ConsumerStatefulWidget {
  final Map<String, dynamic> request;

  const _RequestTile({required this.request});

  @override
  ConsumerState<_RequestTile> createState() => _RequestTileState();
}

class _RequestTileState extends ConsumerState<_RequestTile> {
  bool _isAccepting = false;
  bool _isRejecting = false;

  @override
  Widget build(BuildContext context) {
    final profile = widget.request['profiles'] as Map<String, dynamic>?;
    final requestId = widget.request['id'] as String;
    final isBusy = _isAccepting || _isRejecting;

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSizes.md,
        vertical: AppSizes.xs,
      ),
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          HaloAvatar(
            imageUrl: profile?['avatar_url'],
            name: profile?['display_name'] ?? profile?['username'] ?? '?',
            size: AppSizes.avatarMd,
          ),
          const SizedBox(width: AppSizes.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile?['display_name'] ?? profile?['username'] ?? 'Unknown',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  '@${profile?['username'] ?? ''}',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),

          // ── Accept button ─────────────────────────────
          if (_isAccepting)
            const SizedBox(
              width: 36,
              height: 36,
              child: Padding(
                padding: EdgeInsets.all(8),
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.online,
                ),
              ),
            )
          else
            IconButton(
              onPressed: isBusy
                  ? null
                  : () async {
                      setState(() => _isAccepting = true);
                      try {
                        final success = await ref
                            .read(friendsActionsProvider.notifier)
                            .acceptRequest(requestId);
                        if (context.mounted && !success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Không thể chấp nhận lời mời. Thử lại sau.',
                              ),
                              backgroundColor: AppColors.error,
                            ),
                          );
                        }
                      } finally {
                        if (mounted) setState(() => _isAccepting = false);
                      }
                    },
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.online.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: AppColors.online,
                  size: 18,
                ),
              ),
            ),

          // ── Reject button ─────────────────────────────
          if (_isRejecting)
            const SizedBox(
              width: 36,
              height: 36,
              child: Padding(
                padding: EdgeInsets.all(8),
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.error,
                ),
              ),
            )
          else
            IconButton(
              onPressed: isBusy
                  ? null
                  : () async {
                      setState(() => _isRejecting = true);
                      try {
                        final success = await ref
                            .read(friendsActionsProvider.notifier)
                            .removeFriend(requestId);
                        if (context.mounted && !success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Không thể từ chối lời mời. Thử lại sau.',
                              ),
                              backgroundColor: AppColors.error,
                            ),
                          );
                        }
                      } finally {
                        if (mounted) setState(() => _isRejecting = false);
                      }
                    },
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  color: AppColors.error,
                  size: 18,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
