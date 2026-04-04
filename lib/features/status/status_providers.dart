import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'data/status_repository.dart';

part 'status_providers.g.dart';

/// Stream of all user statuses
@riverpod
Stream<List<Map<String, dynamic>>> statusesStream(ref) {
  final repo = ref.watch(statusRepositoryProvider);
  return repo.streamStatuses();
}

/// Status update notifier
@riverpod
class StatusNotifier extends _$StatusNotifier {
  @override
  FutureOr<void> build() {}

  Future<bool> updateStatus({
    required String emoji,
    required String text,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(statusRepositoryProvider);
      await repo.updateStatus(emoji: emoji, text: text);
    });
    return !state.hasError;
  }
}
