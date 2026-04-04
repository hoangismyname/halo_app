import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/constants/supabase_constants.dart';
import '../domain/user_model.dart';

part 'auth_repository.g.dart';

class AuthRepository {
  final SupabaseClient _client;

  AuthRepository(this._client);

  // TODO(Project Phase 2): Đổi isGuestMode thành false để bật tính năng xác thực thực tế (Supabase Authentication).
  static bool isGuestMode = true;

  SupabaseClient get client => _client;

  User? get currentUser => isGuestMode
      ? const User(
          id: 'guest',
          appMetadata: {},
          userMetadata: {},
          aud: 'authenticated',
          createdAt: '2024-01-01T00:00:00Z')
      : _client.auth.currentUser;

  String? get currentUserId => isGuestMode ? 'guest' : currentUser?.id;
  bool get isAuthenticated => isGuestMode || currentUser != null;

  Stream<AuthState> get authStateChanges => isGuestMode
      ? Stream.value(AuthState(AuthChangeEvent.signedIn, null))
      : _client.auth.onAuthStateChange;

  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String username,
    String? displayName,
  }) async {
    final response = await _client.auth.signUp(
      email: email,
      password: password,
      data: {
        'username': username,
        'display_name': displayName ?? username,
      },
    );

    if (response.user != null) {
      // Create profile entry
      await _client.from(SupabaseConstants.profilesTable).upsert({
        'id': response.user!.id,
        'username': username,
        'display_name': displayName ?? username,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });
    }

    return response;
  }

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  Future<UserModel?> getProfile(String userId) async {
    if (isGuestMode) {
      return const UserModel(
        id: 'guest',
        username: 'guest_user',
        displayName: 'Khách (Demo)',
      );
    }
    
    final data = await _client
        .from(SupabaseConstants.profilesTable)
        .select()
        .eq('id', userId)
        .maybeSingle();

    if (data == null) return null;
    return UserModel.fromJson(data);
  }

  Future<UserModel?> getMyProfile() async {
    if (currentUserId == null) return null;
    return getProfile(currentUserId!);
  }

  Future<void> updateProfile(Map<String, dynamic> updates) async {
    if (currentUserId == null) return;
    updates['updated_at'] = DateTime.now().toIso8601String();
    await _client
        .from(SupabaseConstants.profilesTable)
        .update(updates)
        .eq('id', currentUserId!);
  }

  Future<void> updateOnlineStatus(bool isOnline) async {
    await updateProfile({
      'is_online': isOnline,
      'last_seen': DateTime.now().toIso8601String(),
    });
  }

  Future<String?> uploadAvatar(String filePath, String fileName) async {
    final path = '${currentUserId!}/$fileName';
    await _client.storage
        .from(SupabaseConstants.avatarsBucket)
        .upload(path, Uri.parse(filePath) as dynamic);
    return _client.storage
        .from(SupabaseConstants.avatarsBucket)
        .getPublicUrl(path);
  }
}

@riverpod
AuthRepository authRepository(ref) {
  return AuthRepository(Supabase.instance.client);
}
