import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/constants/supabase_constants.dart';
import '../domain/user_model.dart';

part 'auth_repository.g.dart';

/// Repository handling Supabase Authentication and user profile operations.
class AuthRepository {
  final SupabaseClient _client;

  AuthRepository(this._client);

  SupabaseClient get client => _client;

  /// Currently authenticated Supabase user, or null if not signed in.
  User? get currentUser => _client.auth.currentUser;

  /// UUID of the currently authenticated user.
  String? get currentUserId => currentUser?.id;

  /// Whether a user is currently authenticated with Supabase.
  bool get isAuthenticated => currentUser != null;

  /// Stream of Supabase auth state changes (sign in, sign out, token refresh).
  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  /// Register a new user with email/password.
  ///
  /// The database trigger `handle_new_user()` auto-creates a profile row,
  /// so we don't need to upsert manually. We only pass metadata for the
  /// trigger to use.
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String username,
    String? displayName,
  }) async {
    return await _client.auth.signUp(
      email: email,
      password: password,
      data: {'username': username, 'display_name': displayName ?? username},
    );
  }

  /// Sign in with email and password.
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  /// Sign in with Google.
  Future<bool> signInWithGoogle() async {
    return await _client.auth.signInWithOAuth(OAuthProvider.google);
  }

  /// Sign in with Facebook.
  Future<bool> signInWithFacebook() async {
    return await _client.auth.signInWithOAuth(OAuthProvider.facebook);
  }

  /// Sign out the current user.
  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  /// Fetch a user profile by ID. Returns null if not found.
  Future<UserModel?> getProfile(String userId) async {
    final data = await _client
        .from(SupabaseConstants.profilesTable)
        .select()
        .eq('id', userId)
        .maybeSingle();

    if (data == null) return null;
    return UserModel.fromJson(data);
  }

  /// Fetch the current user's own profile.
  Future<UserModel?> getMyProfile() async {
    final uid = currentUserId;
    if (uid == null) return null;
    return getProfile(uid);
  }

  /// Update fields on the current user's profile.
  ///
  /// Automatically sets [updated_at] to the current UTC time.
  Future<void> updateProfile(Map<String, dynamic> updates) async {
    final uid = currentUserId;
    if (uid == null) return;
    updates['updated_at'] = DateTime.now().toUtc().toIso8601String();
    await _client
        .from(SupabaseConstants.profilesTable)
        .update(updates)
        .eq('id', uid);
  }

  /// Update the current user's online status and last-seen timestamp.
  Future<void> updateOnlineStatus(bool isOnline) async {
    await updateProfile({
      'is_online': isOnline,
      'last_seen': DateTime.now().toUtc().toIso8601String(),
    });
  }

  /// Upload an avatar image for the current user.
  ///
  /// The file is stored in the [SupabaseConstants.avatarsBucket] under
  /// `{user_id}/{fileName}`. Returns the public URL of the uploaded file.
  Future<String?> uploadAvatar(String filePath, String fileName) async {
    final uid = currentUserId;
    if (uid == null) return null;

    final file = File(filePath);
    if (!await file.exists()) return null;

    final storagePath = '$uid/$fileName';
    await _client.storage
        .from(SupabaseConstants.avatarsBucket)
        .upload(
          storagePath,
          file,
          fileOptions: const FileOptions(upsert: true),
        );

    return _client.storage
        .from(SupabaseConstants.avatarsBucket)
        .getPublicUrl(storagePath);
  }
}

@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepository(Supabase.instance.client);
}
