import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/constants/supabase_constants.dart';

part 'status_repository.g.dart';

class StatusRepository {
  final SupabaseClient _client;

  StatusRepository(this._client);

  String? get _userId => _client.auth.currentUser?.id;

  /// Update current user's status
  Future<void> updateStatus({
    required String emoji,
    required String text,
  }) async {
    if (_userId == null) return;

    await _client.from(SupabaseConstants.profilesTable).update({
      'status_emoji': emoji,
      'status_text': text,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', _userId!);
  }

  /// Stream all friends' statuses
  Stream<List<Map<String, dynamic>>> streamStatuses() {
    return _client
        .from(SupabaseConstants.profilesTable)
        .stream(primaryKey: ['id'])
        .order('updated_at');
  }
}

@riverpod
StatusRepository statusRepository(ref) {
  return StatusRepository(Supabase.instance.client);
}
