import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'features/chat/presentation/providers/realtime_notifications_provider.dart';

class HaloApp extends ConsumerWidget {
  const HaloApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    // Initialize global notification listener
    ref.listen(realtimeNotificationsProvider, (_, _) {});

    return MaterialApp.router(
      title: 'Halo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: router,
    );
  }
}
