import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/auth_repository.dart';
import '../../domain/user_model.dart';

part 'auth_provider.g.dart';

/// Watches auth state changes from Supabase.
@riverpod
Stream<AuthState> authStateChanges(Ref ref) {
  final repo = ref.watch(authRepositoryProvider);
  return repo.authStateChanges;
}

/// Current authenticated Supabase user.
@riverpod
User? currentUser(Ref ref) {
  ref.watch(authStateChangesProvider);
  final repo = ref.watch(authRepositoryProvider);
  return repo.currentUser;
}

/// Current user's profile from the `profiles` table.
@riverpod
Future<UserModel?> currentProfile(Ref ref) async {
  ref.watch(authStateChangesProvider);
  final repo = ref.watch(authRepositoryProvider);
  if (!repo.isAuthenticated) return null;
  return repo.getMyProfile();
}

/// Auth notifier for login, signup, and logout actions.
@Riverpod(keepAlive: true)
class AuthNotifier extends _$AuthNotifier {
  @override
  FutureOr<void> build() {}

  /// Register a new account. Returns true on success.
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

  /// Sign in with email and password. Returns true on success.
  Future<bool> signIn({required String email, required String password}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(authRepositoryProvider);
      await repo.signIn(email: email, password: password);
    });
    return !state.hasError;
  }

  /// Sign in with Google. Returns true on success.
  Future<bool> signInWithGoogle() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(authRepositoryProvider);
      await repo.signInWithGoogle();
    });
    return !state.hasError;
  }

  /// Sign in with Facebook. Returns true on success.
  Future<bool> signInWithFacebook() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(authRepositoryProvider);
      await repo.signInWithFacebook();
    });
    return !state.hasError;
  }

  /// Sign out the current user and invalidate auth providers.
  Future<void> signOut() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(authRepositoryProvider);
      await repo.signOut();
      ref.invalidate(authStateChangesProvider);
    });
  }

  /// Human-readable error message from the last failed operation.
  String? get errorMessage {
    if (state.hasError) {
      final error = state.error;
      if (error is AuthException) return error.message;
      return error.toString();
    }
    return null;
  }
}

/// Whether the user is currently authenticated with Supabase.
@riverpod
bool isAuthenticated(Ref ref) {
  return ref.watch(currentUserProvider) != null;
}
