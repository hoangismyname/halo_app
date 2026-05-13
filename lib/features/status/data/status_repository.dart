import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/constants/supabase_constants.dart';

part 'status_repository.g.dart';

class StatusRepository {
  final SupabaseClient _client;

  StatusRepository(this._client);

  String? get _userId => _client.auth.currentUser?.id;

  /// Update current user's status.
  ///
  /// Throws on network or database errors. Caller should handle errors.
  Future<void> updateStatus({
    required String emoji,
    required String text,
  }) async {
    final uid = _userId;
    if (uid == null) {
      throw StateError('Cannot update status: user is not authenticated');
    }

    await _client
        .from(SupabaseConstants.profilesTable)
        .update({
          'status_emoji': emoji,
          'status_text': text,
          'updated_at': DateTime.now().toUtc().toIso8601String(),
        })
        .eq('id', uid);
  }

  Stream<List<Map<String, dynamic>>> streamStatuses() {
    final uid = _userId;
    if (uid == null) {
      return Stream.value([]);
    }
    return _client
        .from(SupabaseConstants.profilesTable)
        .stream(primaryKey: ['id'])
        .order('updated_at', ascending: false);
  }
}

@riverpod
StatusRepository statusRepository(Ref ref) {
  return StatusRepository(Supabase.instance.client);
}
