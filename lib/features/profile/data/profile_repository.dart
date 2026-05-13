import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/constants/supabase_constants.dart';
import '../../auth/domain/user_model.dart';

part 'profile_repository.g.dart';

class ProfileRepository {
  final SupabaseClient _client;
  final ImagePicker _picker;

  ProfileRepository(this._client, {ImagePicker? picker})
    : _picker = picker ?? ImagePicker();

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
      'updated_at': DateTime.now().toUtc().toIso8601String(),
    };

    if (displayName != null) updates['display_name'] = displayName;
    if (bio != null) updates['bio'] = bio;
    if (avatarUrl != null) updates['avatar_url'] = avatarUrl;

    await _client
        .from(SupabaseConstants.profilesTable)
        .update(updates)
        .eq('id', _userId!);
  }

  /// Pick an image from gallery/camera, upload to Supabase Storage,
  /// update the profile avatar URL, and return the public URL.
  ///
  /// Returns null if the user cancels or if an error occurs.
  Future<String?> uploadAvatar() async {
    final uid = _userId;
    if (uid == null) return null;

    // Pick image from gallery
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 80,
    );
    if (image == null) return null;

    final bytes = await image.readAsBytes();
    final ext = image.path.split('.').last.toLowerCase();
    final fileName = 'avatar.$ext';
    final storagePath = '$uid/$fileName';

    // Upload to Supabase Storage
    await _client.storage
        .from(SupabaseConstants.avatarsBucket)
        .uploadBinary(
          storagePath,
          bytes,
          fileOptions: const FileOptions(upsert: true),
        );

    final url = _client.storage
        .from(SupabaseConstants.avatarsBucket)
        .getPublicUrl(storagePath);

    // Update profile with new avatar URL
    await updateProfile(avatarUrl: url);

    return url;
  }
}

@riverpod
ProfileRepository profileRepository(Ref ref) {
  return ProfileRepository(Supabase.instance.client);
}
