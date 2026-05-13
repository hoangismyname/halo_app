import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../status_providers.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/halo_avatar.dart';

class StatusScreen extends ConsumerStatefulWidget {
  const StatusScreen({super.key});

  @override
  ConsumerState<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends ConsumerState<StatusScreen> {
  @override
  Widget build(BuildContext context) {
    final statusesAsync = ref.watch(statusesStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trạng thái'),
        actions: [
          IconButton(
            onPressed: _showUpdateStatusDialog,
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
      body: statusesAsync.when(
        data: (statuses) {
          final filtered = statuses
              .where(
                (s) =>
                    (s['status_text'] as String?)?.isNotEmpty == true ||
                    (s['status_emoji'] as String?)?.isNotEmpty == true,
              )
              .toList();

          if (filtered.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.mood,
                    size: 64,
                    color: AppColors.textTertiary.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: AppSizes.md),
                  const Text(
                    'Chưa có trạng thái nào',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textTertiary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Hãy chia sẻ trạng thái của bạn!',
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
            padding: const EdgeInsets.all(AppSizes.md),
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              final status = filtered[index];
              return _StatusCard(status: status);
            },
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (error, _) => Center(
          child: Text(
            'Lỗi: $error',
            style: const TextStyle(color: AppColors.error),
          ),
        ),
      ),
    );
  }

  void _showUpdateStatusDialog() {
    final textController = TextEditingController();
    final commonEmojis = [
      '😊',
      '😎',
      '🔥',
      '💪',
      '🎮',
      '📚',
      '🏃',
      '💤',
      '🎵',
      '🍕',
      '☕',
      '✈️',
      '🏠',
      '💼',
      '🎉',
      '❤️',
    ];
    String selectedEmoji = '😊';

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Container(
          padding: EdgeInsets.only(
            left: AppSizes.lg,
            right: AppSizes.lg,
            top: AppSizes.lg,
            bottom: MediaQuery.viewInsetsOf(context).bottom + AppSizes.lg,
          ),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.textTertiary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: AppSizes.lg),
              const Text(
                'Cập nhật trạng thái',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSizes.lg),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: commonEmojis.map((emoji) {
                  final isSelected = emoji == selectedEmoji;
                  return GestureDetector(
                    onTap: () => setSheetState(() => selectedEmoji = emoji),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary.withValues(alpha: 0.2)
                            : AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(12),
                        border: isSelected
                            ? Border.all(color: AppColors.primary, width: 2)
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          emoji,
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: AppSizes.md),
              TextField(
                controller: textController,
                maxLength: 100,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  color: AppColors.textPrimary,
                ),
                cursorColor: AppColors.primary,
                decoration: InputDecoration(
                  hintText: 'Bạn đang làm gì?',
                  hintStyle: const TextStyle(color: AppColors.textTertiary),
                  filled: true,
                  fillColor: AppColors.inputFill,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.md),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  // FIXME: Cannot use the Ref of statusProvider after it has been disposed.
                  onPressed: () async {
                    final result = await ref
                        .read(statusProvider.notifier)
                        .updateStatus(
                          emoji: selectedEmoji,
                          text: textController.text.trim(),
                        );

                    if (!context.mounted) return;

                    if (result.success) {
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            result.errorMessage ?? 'Cập nhật thất bại',
                          ),
                          backgroundColor: AppColors.error,
                        ),
                      );
                    }
                  },
                  child: const Text('Lưu trạng thái'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  final Map<String, dynamic> status;
  const _StatusCard({required this.status});

  @override
  Widget build(BuildContext context) {
    final emoji = status['status_emoji'] as String? ?? '😊';
    final text = status['status_text'] as String? ?? '';
    final name =
        status['display_name'] as String? ??
        status['username'] as String? ??
        'Unknown';
    final avatarUrl = status['avatar_url'] as String?;
    final isOnline = status['is_online'] as bool? ?? false;
    final updatedAt = status['updated_at'] as String?;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.md),
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          HaloAvatar(
            imageUrl: avatarUrl,
            name: name,
            size: AppSizes.avatarMd,
            isOnline: isOnline,
          ),
          const SizedBox(width: AppSizes.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(emoji, style: const TextStyle(fontSize: 18)),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        text,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (updatedAt != null)
            Text(
              _timeAgo(updatedAt),
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 11,
                color: AppColors.textTertiary,
              ),
            ),
        ],
      ),
    );
  }

  String _timeAgo(String timestamp) {
    try {
      final dt = DateTime.parse(timestamp);
      final diff = DateTime.now().difference(dt);
      if (diff.inMinutes < 1) return 'Vừa xong';
      if (diff.inMinutes < 60) return '${diff.inMinutes}p';
      if (diff.inHours < 24) return '${diff.inHours}h';
      return '${diff.inDays}d';
    } catch (_) {
      return '';
    }
  }
}
