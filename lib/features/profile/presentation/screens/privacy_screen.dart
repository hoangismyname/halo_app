import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';

class PublicProfileNotifier extends Notifier<bool> {
  @override
  bool build() => true;
  void updateValue(bool value) => state = value;
}

final publicProfileProvider = NotifierProvider<PublicProfileNotifier, bool>(
  PublicProfileNotifier.new,
);

class ShowActivityNotifier extends Notifier<bool> {
  @override
  bool build() => true;
  void updateValue(bool value) => state = value;
}

final showActivityProvider = NotifierProvider<ShowActivityNotifier, bool>(
  ShowActivityNotifier.new,
);

class PrivacyScreen extends ConsumerWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quyền riêng tư')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        children: [
          _PrivacySwitch(
            title: 'Hồ sơ công khai',
            subtitle: 'Mọi người có thể tìm thấy bạn',
            value: ref.watch(publicProfileProvider),
            onChanged: (val) =>
                ref.read(publicProfileProvider.notifier).updateValue(val),
          ),
          const Divider(indent: 16, endIndent: 16),
          _PrivacySwitch(
            title: 'Trạng thái hoạt động',
            subtitle: 'Hiển thị khi bạn đang online',
            value: ref.watch(showActivityProvider),
            onChanged: (val) =>
                ref.read(showActivityProvider.notifier).updateValue(val),
          ),
          const Divider(indent: 16, endIndent: 16),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 24.0),
            title: const Text(
              'Người dùng đã chặn',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            trailing: const Icon(
              Icons.chevron_right,
              color: AppColors.textTertiary,
            ),
            onTap: () {
              // TODO: Implement blocked users list screen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Tính năng đang phát triển')),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _PrivacySwitch extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _PrivacySwitch({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24.0),
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          color: AppColors.textSecondary,
        ),
      ),
      value: value,
      onChanged: onChanged,
      activeThumbColor: AppColors.primary,
    );
  }
}
