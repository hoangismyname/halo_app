import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/constants/supabase_constants.dart';
import '../../auth/domain/user_model.dart';

part 'profile_repository.g.dart';

class ProfileRepository {
  final SupabaseClient _client;

  ProfileRepository(this._client);

  String? get _userId => _client.auth.currentUser?.id;

  /// Get profile by ID
  Future<UserModel?> getProfile(String userId) async {
    final data = await _client
        .from(SupabaseConstants.profilesTable)
        .select()
        .eq('id', userId)
        .maybeSingle();

    if (data == null) return null;
    return UserModel.fromJson(data);
  }

  /// Update profile fields
  Future<void> updateProfile({
    String? displayName,
    String? bio,
    String? avatarUrl,
  }) async {
    if (_userId == null) return;

    final updates = <String, dynamic>{
      'updated_at': DateTime.now().toIso8601String(),
    };

    if (displayName != null) updates['display_name'] = displayName;
    if (bio != null) updates['bio'] = bio;
    if (avatarUrl != null) updates['avatar_url'] = avatarUrl;

    await _client
        .from(SupabaseConstants.profilesTable)
        .update(updates)
        .eq('id', _userId!);
  }

  /// Upload avatar to Supabase Storage and return public URL
  Future<String?> uploadAvatar(List<int> fileBytes, String fileName) async {
    if (_userId == null) return null;

    final path = '$_userId/$fileName';

    await _client.storage
        .from(SupabaseConstants.avatarsBucket)
        .uploadBinary(path, fileBytes as dynamic,
            fileOptions: const FileOptions(upsert: true));

    final url = _client.storage
        .from(SupabaseConstants.avatarsBucket)
        .getPublicUrl(path);

    // Update profile with new avatar URL
    await updateProfile(avatarUrl: url);

    return url;
  }
}

@riverpod
ProfileRepository profileRepository(ref) {
  return ProfileRepository(Supabase.instance.client);
}
