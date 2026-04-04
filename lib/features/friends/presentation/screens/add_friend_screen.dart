import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/friends_provider.dart';
import '../../../auth/domain/user_model.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/halo_avatar.dart';
import '../../../../core/widgets/halo_text_field.dart';
import '../../../../core/utils/extensions.dart';

class AddFriendScreen extends ConsumerStatefulWidget {
  const AddFriendScreen({super.key});

  @override
  ConsumerState<AddFriendScreen> createState() => _AddFriendScreenState();
}

class _AddFriendScreenState extends ConsumerState<AddFriendScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _search() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      ref.read(userSearchProvider.notifier).search(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchResults = ref.watch(userSearchProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thêm bạn bè'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Column(
          children: [
            // Search bar
            Row(
              children: [
                Expanded(
                  child: HaloTextField(
                    controller: _searchController,
                    hintText: 'Tìm kiếm theo username...',
                    prefixIcon: Icons.search,
                    onSubmitted: (_) => _search(),
                  ),
                ),
                const SizedBox(width: AppSizes.sm),
                Container(
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  ),
                  child: IconButton(
                    onPressed: _search,
                    icon: const Icon(Icons.search, color: Colors.white),
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSizes.md),

            // Results
            Expanded(
              child: searchResults.when(
                data: (users) {
                  if (users.isEmpty && _searchController.text.isNotEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.search_off,
                              size: 48, color: AppColors.textTertiary.withValues(alpha: 0.5)),
                          const SizedBox(height: AppSizes.md),
                          const Text(
                            'Không tìm thấy người dùng',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              color: AppColors.textTertiary,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  if (users.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.person_search,
                              size: 64, color: AppColors.primary.withValues(alpha: 0.3)),
                          const SizedBox(height: AppSizes.md),
                          const Text(
                            'Nhập username để tìm bạn bè',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16,
                              color: AppColors.textTertiary,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      return _SearchResultTile(user: users[index]);
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
          ],
        ),
      ),
    );
  }
}

class _SearchResultTile extends ConsumerWidget {
  final UserModel user;

  const _SearchResultTile({required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          imageUrl: user.avatarUrl,
          name: user.displayName.isNotEmpty ? user.displayName : user.username,
          size: AppSizes.avatarMd,
        ),
        title: Text(
          user.displayName.isNotEmpty ? user.displayName : user.username,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: Text(
          '@${user.username}',
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 13,
            color: AppColors.textTertiary,
          ),
        ),
        trailing: ElevatedButton.icon(
          onPressed: () async {
            final success = await ref
                .read(friendsActionsProvider.notifier)
                .sendRequest(user.id);
            if (context.mounted) {
              context.showSnackBar(
                success ? 'Đã gửi lời mời kết bạn!' : 'Không thể gửi lời mời',
                isError: !success,
              );
            }
          },
          icon: const Icon(Icons.person_add, size: 16),
          label: const Text('Kết bạn'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            minimumSize: Size.zero,
            textStyle: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
