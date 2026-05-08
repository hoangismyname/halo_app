import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../auth/domain/user_model.dart';
import 'data/profile_repository.dart';

part 'profile_providers.g.dart';

/// Profile for a specific user
@riverpod
Future<UserModel?> userProfile(Ref ref, String userId) async {
  final repo = ref.watch(profileRepositoryProvider);
  return repo.getProfile(userId);
}

/// Profile update notifier
@riverpod
class ProfileNotifier extends _$ProfileNotifier {
  @override
  FutureOr<void> build() {}

  Future<bool> updateProfile({
    String? displayName,
    String? bio,
    String? avatarUrl,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(profileRepositoryProvider);
      await repo.updateProfile(
        displayName: displayName,
        bio: bio,
        avatarUrl: avatarUrl,
      );
    });
    return !state.hasError;
  }
}
