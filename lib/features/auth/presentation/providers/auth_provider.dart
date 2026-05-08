import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/auth_repository.dart';
import '../../domain/user_model.dart';

part 'auth_provider.g.dart';

/// Watches auth state changes from Supabase
@riverpod
Stream<AuthState> authStateChanges(Ref ref) {
  final repo = ref.watch(authRepositoryProvider);
  return repo.authStateChanges;
}

/// Current authenticated user
@riverpod
User? currentUser(Ref ref) {
  ref.watch(authStateChangesProvider);
  final repo = ref.watch(authRepositoryProvider);
  return repo.currentUser;
}

/// Current user's profile
@riverpod
Future<UserModel?> currentProfile(Ref ref) async {
  ref.watch(authStateChangesProvider);
  final repo = ref.watch(authRepositoryProvider);
  if (!repo.isAuthenticated) return null;
  return repo.getMyProfile();
}

/// Auth notifier for login/signup/logout actions
@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  FutureOr<void> build() {}

  Future<bool> signUp({
    required String email,
    required String password,
    required String username,
    String? displayName,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(authRepositoryProvider);
      await repo.signUp(
        email: email,
        password: password,
        username: username,
        displayName: displayName,
      );
    });
    return !state.hasError;
  }

  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(authRepositoryProvider);
      await repo.signIn(email: email, password: password);
    });
    return !state.hasError;
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(authRepositoryProvider);
      await repo.signOut();
      AuthRepository.isGuestMode = false;
      ref.invalidate(authStateChangesProvider);
    });
  }

  Future<void> signInAsGuest() async {
    state = const AsyncLoading();
    AuthRepository.isGuestMode = true;
    ref.invalidate(authStateChangesProvider);
    state = const AsyncData(null);
  }

  String? get errorMessage {
    if (state.hasError) {
      final error = state.error;
      if (error is AuthException) {
        return error.message;
      }
      return error.toString();
    }
    return null;
  }
}

/// Boolean indicating if user is logged in
@riverpod
bool isAuthenticated(Ref ref) {
  return ref.watch(currentUserProvider) != null || AuthRepository.isGuestMode;
}
