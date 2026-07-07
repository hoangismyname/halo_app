import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';

// Providers for simple state toggling
class PushNotificationNotifier extends Notifier<bool> {
  @override
  bool build() => true;
  void updateValue(bool value) => state = value;
}

final pushNotificationProvider =
    NotifierProvider<PushNotificationNotifier, bool>(
      PushNotificationNotifier.new,
    );

class SoundNotifier extends Notifier<bool> {
  @override
  bool build() => true;
  void updateValue(bool value) => state = value;
}

final soundProvider = NotifierProvider<SoundNotifier, bool>(SoundNotifier.new);

class EmailNotifier extends Notifier<bool> {
  @override
  bool build() => false;
  void updateValue(bool value) => state = value;
}

final emailProvider = NotifierProvider<EmailNotifier, bool>(EmailNotifier.new);

class NotificationScreen extends ConsumerWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thông báo')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        children: [
          _NotificationSwitch(
            title: 'Thông báo đẩy',
            subtitle: 'Nhận thông báo trên thiết bị',
            value: ref.watch(pushNotificationProvider),
            onChanged: (val) =>
                ref.read(pushNotificationProvider.notifier).updateValue(val),
          ),
          const Divider(indent: 16, endIndent: 16),
          _NotificationSwitch(
            title: 'Âm thanh',
            subtitle: 'Phát âm thanh khi có thông báo',
            value: ref.watch(soundProvider),
            onChanged: (val) =>
                ref.read(soundProvider.notifier).updateValue(val),
          ),
          const Divider(indent: 16, endIndent: 16),
          _NotificationSwitch(
            title: 'Email',
            subtitle: 'Nhận thông báo qua email',
            value: ref.watch(emailProvider),
            onChanged: (val) =>
                ref.read(emailProvider.notifier).updateValue(val),
          ),
        ],
      ),
    );
  }
}

class _NotificationSwitch extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _NotificationSwitch({
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
