import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'data/status_repository.dart';

part 'status_providers.g.dart';

/// Result of a status update operation.
class StatusUpdateResult {
  const StatusUpdateResult({required this.success, this.errorMessage});

  final bool success;
  final String? errorMessage;
}

/// Stream of all user statuses (excluding the current user).
@riverpod
Stream<List<Map<String, dynamic>>> statusesStream(Ref ref) {
  final repo = ref.watch(statusRepositoryProvider);
  return repo.streamStatuses();
}

/// Status update notifier.
///
/// Call [updateStatus] to update the current user's status.
/// The returned [StatusUpdateResult] contains both the success flag
/// and any error message — do NOT read the provider again after the
/// async call, as the provider may have been auto-disposed.
@riverpod
class StatusNotifier extends _$StatusNotifier {
  @override
  FutureOr<void> build() {}

  /// Update the current user's status emoji and text.
  ///
  /// Returns a [StatusUpdateResult] with the outcome.
  /// The result is self-contained — do NOT read the provider
  /// again after this call to check for errors.
  Future<StatusUpdateResult> updateStatus({
    required String emoji,
    required String text,
  }) async {
    state = const AsyncLoading();
    // FIXME: Cannot use the Ref of statusProvider after it has been disposed.
    state = await AsyncValue.guard(() async {
      final repo = ref.read(statusRepositoryProvider);
      await repo.updateStatus(emoji: emoji, text: text);
    });

    // Capture the result BEFORE returning — don't let callers
    // access the provider after the async gap.
    if (state.hasError) {
      return StatusUpdateResult(
        success: false,
        errorMessage: state.error.toString(),
      );
    }
    return const StatusUpdateResult(success: true);
  }
}
