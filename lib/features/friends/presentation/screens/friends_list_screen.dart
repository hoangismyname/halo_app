import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/friends_provider.dart';
import '../../../auth/domain/user_model.dart';
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
              child: const Icon(Icons.person_add, size: 20, color: Colors.white),
            ),
          ),
        ],
      ),
      body: CustomScrollView(
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
                          AppSizes.md, AppSizes.md, AppSizes.md, AppSizes.sm),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
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
            error: (_, __) => const SliverToBoxAdapter(),
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
                            color: AppColors.textTertiary.withValues(alpha: 0.5),
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
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final friend = friends[index];
                      return _FriendTile(friend: friend);
                    },
                    childCount: friends.length,
                  ),
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

class _FriendTile extends StatelessWidget {
  final UserModel friend;

  const _FriendTile({required this.friend});

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
            horizontal: AppSizes.md, vertical: AppSizes.xs),
        leading: HaloAvatar(
          imageUrl: friend.avatarUrl,
          name: friend.displayName.isNotEmpty
              ? friend.displayName
              : friend.username,
          isOnline: friend.isOnline,
          size: AppSizes.avatarMd,
        ),
        title: Text(
          friend.displayName.isNotEmpty
              ? friend.displayName
              : friend.username,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: Row(
          children: [
            Text(
              friend.statusEmoji,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                friend.statusText.isNotEmpty
                    ? friend.statusText
                    : '@${friend.username}',
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
        trailing: IconButton(
          onPressed: () {
            // Open chat with this friend
          },
          icon: const Icon(Icons.chat_bubble_outline,
              color: AppColors.primary, size: 20),
        ),
      ),
    );
  }
}

class _RequestTile extends ConsumerWidget {
  final Map<String, dynamic> request;

  const _RequestTile({required this.request});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = request['profiles'] as Map<String, dynamic>?;
    final requestId = request['id'] as String;

    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: AppSizes.md, vertical: AppSizes.xs),
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(
          color: AppColors.warning.withValues(alpha: 0.2),
        ),
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
          // Accept
          IconButton(
            onPressed: () {
              ref.read(friendsActionsProvider.notifier).acceptRequest(requestId);
            },
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.online.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child:
                  const Icon(Icons.check, color: AppColors.online, size: 18),
            ),
          ),
          // Reject
          IconButton(
            onPressed: () {
              ref.read(friendsActionsProvider.notifier).removeFriend(requestId);
            },
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child:
                  const Icon(Icons.close, color: AppColors.error, size: 18),
            ),
          ),
        ],
      ),
    );
  }
}
