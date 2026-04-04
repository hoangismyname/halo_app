import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/halo_avatar.dart';
import '../../../../core/widgets/halo_button.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(currentProfileProvider);
    final isLoading = ref.watch(authProvider).isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hồ sơ'),
        actions: [
          IconButton(
            onPressed: () => context.push('/edit-profile'),
            icon: const Icon(Icons.edit_outlined, color: AppColors.primary),
          ),
        ],
      ),
      body: profileAsync.when(
        data: (profile) {
          if (profile == null) {
            return const Center(
              child: Text('Không tìm thấy hồ sơ',
                  style: TextStyle(color: AppColors.textTertiary)),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.lg),
            child: Column(
              children: [
                HaloAvatar(
                  imageUrl: profile.avatarUrl,
                  name: profile.displayName.isNotEmpty
                      ? profile.displayName
                      : profile.username,
                  size: AppSizes.avatarXxl,
                  showBorder: true,
                ),
                const SizedBox(height: AppSizes.md),
                Text(
                  profile.displayName.isNotEmpty
                      ? profile.displayName
                      : profile.username,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '@${profile.username}',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15,
                    color: AppColors.textTertiary,
                  ),
                ),
                const SizedBox(height: AppSizes.sm),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(profile.statusEmoji,
                          style: const TextStyle(fontSize: 18)),
                      if (profile.statusText.isNotEmpty) ...[
                        const SizedBox(width: 6),
                        Text(
                          profile.statusText,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: AppSizes.lg),
                if (profile.bio.isNotEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSizes.md),
                    decoration: BoxDecoration(
                      gradient: AppColors.cardGradient,
                      borderRadius:
                          BorderRadius.circular(AppSizes.radiusMd),
                    ),
                    child: Text(
                      profile.bio,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 15,
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                const SizedBox(height: AppSizes.xl),
                // Stats
                Container(
                  padding: const EdgeInsets.all(AppSizes.lg),
                  decoration: BoxDecoration(
                    gradient: AppColors.cardGradient,
                    borderRadius:
                        BorderRadius.circular(AppSizes.radiusLg),
                    border: Border.all(
                        color: AppColors.border.withValues(alpha: 0.5)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _StatItem(
                          icon: Icons.people,
                          label: 'Bạn bè',
                          value: '0',
                          color: AppColors.primary),
                      Container(
                          width: 1,
                          height: 40,
                          color: AppColors.divider),
                      _StatItem(
                          icon: Icons.location_on,
                          label: 'Địa điểm',
                          value: '0',
                          color: AppColors.secondary),
                      Container(
                          width: 1,
                          height: 40,
                          color: AppColors.divider),
                      _StatItem(
                          icon: Icons.calendar_today,
                          label: 'Tham gia',
                          value: _formatDate(profile.createdAt),
                          color: AppColors.info),
                    ],
                  ),
                ),
                const SizedBox(height: AppSizes.xl),
                // Settings
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius:
                        BorderRadius.circular(AppSizes.radiusMd),
                  ),
                  child: Column(
                    children: [
                      _SettingsTile(
                        icon: Icons.location_on_outlined,
                        title: 'Chia sẻ vị trí',
                        trailing: Switch(
                            value: true,
                            onChanged: (v) {},
                            activeColor: AppColors.primary),
                      ),
                      const Divider(height: 1, indent: 56, endIndent: 16),
                      _SettingsTile(
                        icon: Icons.notifications_outlined,
                        title: 'Thông báo',
                        onTap: () {},
                      ),
                      const Divider(height: 1, indent: 56, endIndent: 16),
                      _SettingsTile(
                        icon: Icons.shield_outlined,
                        title: 'Quyền riêng tư',
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSizes.lg),
                HaloButton(
                  text: 'Đăng xuất',
                  icon: Icons.logout,
                  outlined: true,
                  isLoading: isLoading,
                  onPressed: () async {
                    await ref
                        .read(authProvider.notifier)
                        .signOut();
                    if (context.mounted) context.go('/login');
                  },
                ),
                const SizedBox(height: AppSizes.xl),
              ],
            ),
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
    );
  }

  String _formatDate(DateTime? dt) {
    if (dt == null) return '-';
    return '${dt.month}/${dt.year}';
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  const _StatItem(
      {required this.icon,
      required this.label,
      required this.value,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 6),
        Text(value,
            style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary)),
        const SizedBox(height: 2),
        Text(label,
            style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 11,
                color: AppColors.textTertiary)),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  final Widget? trailing;
  const _SettingsTile(
      {required this.icon, required this.title, this.onTap, this.trailing});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppColors.primary, size: 20),
      ),
      title: Text(title,
          style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary)),
      trailing: trailing ??
          const Icon(Icons.chevron_right, color: AppColors.textTertiary),
    );
  }
}
