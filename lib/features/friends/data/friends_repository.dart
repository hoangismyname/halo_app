import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/constants/supabase_constants.dart';
import '../../auth/domain/user_model.dart';

part 'friends_repository.g.dart';

class FriendsRepository {
  final SupabaseClient _client;

  FriendsRepository(this._client);

  String? get _userId => _client.auth.currentUser?.id;

  /// Get all accepted friends with profile info
  Future<List<UserModel>> getFriends() async {
    if (_userId == null) return [];

    // Friends where I sent the request
    final sentData = await _client
        .from(SupabaseConstants.friendshipsTable)
        .select('friend_id, profiles!friendships_friend_id_fkey(*)')
        .eq('user_id', _userId!)
        .eq('status', 'accepted');

    // Friends where they sent me the request
    final receivedData = await _client
        .from(SupabaseConstants.friendshipsTable)
        .select('user_id, profiles!friendships_user_id_fkey(*)')
        .eq('friend_id', _userId!)
        .eq('status', 'accepted');

    final friends = <UserModel>[];

    for (final row in sentData) {
      final profile = row['profiles'] as Map<String, dynamic>?;
      if (profile != null) {
        friends.add(UserModel.fromJson(profile));
      }
    }

    for (final row in receivedData) {
      final profile = row['profiles'] as Map<String, dynamic>?;
      if (profile != null) {
        friends.add(UserModel.fromJson(profile));
      }
    }

    return friends;
  }

  /// Get pending friend requests (received)
  Future<List<Map<String, dynamic>>> getPendingRequests() async {
    if (_userId == null) return [];

    final data = await _client
        .from(SupabaseConstants.friendshipsTable)
        .select('*, profiles!friendships_user_id_fkey(*)')
        .eq('friend_id', _userId!)
        .eq('status', 'pending');

    return List<Map<String, dynamic>>.from(data);
  }

  /// Send friend request
  Future<void> sendFriendRequest(String friendId) async {
    if (_userId == null) return;

    await _client.from(SupabaseConstants.friendshipsTable).insert({
      'user_id': _userId!,
      'friend_id': friendId,
      'status': 'pending',
    });
  }

  /// Accept friend request
  Future<void> acceptFriendRequest(String friendshipId) async {
    await _client
        .from(SupabaseConstants.friendshipsTable)
        .update({'status': 'accepted'})
        .eq('id', friendshipId);
  }

  /// Reject/remove friend
  Future<void> removeFriend(String friendshipId) async {
    await _client
        .from(SupabaseConstants.friendshipsTable)
        .delete()
        .eq('id', friendshipId);
  }

  /// Search users by username
  Future<List<UserModel>> searchUsers(String query) async {
    if (query.isEmpty) return [];

    final data = await _client
        .from(SupabaseConstants.profilesTable)
        .select()
        .ilike('username', '%$query%')
        .neq('id', _userId ?? '')
        .limit(20);

    return data.map((e) => UserModel.fromJson(e)).toList();
  }

  /// Stream friends with locations for the map
  Stream<List<Map<String, dynamic>>> streamFriendLocations() {
    if (_userId == null) return Stream.value([]);

    return _client
        .from(SupabaseConstants.profilesTable)
        .stream(primaryKey: ['id'])
        .map((data) => data.where((p) => p['id'] != _userId).toList());
  }
}

@riverpod
FriendsRepository friendsRepository(ref) {
  return FriendsRepository(Supabase.instance.client);
}
