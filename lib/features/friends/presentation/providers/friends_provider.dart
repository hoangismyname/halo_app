import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../auth/domain/user_model.dart';
import '../../data/friends_repository.dart';

part 'friends_provider.g.dart';

/// All accepted friends
@riverpod
Future<List<UserModel>> friendsList(ref) async {
  final repo = ref.watch(friendsRepositoryProvider);
  return repo.getFriends();
}

/// Pending friend requests
@riverpod
Future<List<Map<String, dynamic>>> pendingRequests(ref) async {
  final repo = ref.watch(friendsRepositoryProvider);
  return repo.getPendingRequests();
}

/// Search users
@riverpod
class UserSearch extends _$UserSearch {
  @override
  FutureOr<List<UserModel>> build() => [];

  Future<void> search(String query) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(friendsRepositoryProvider);
      return repo.searchUsers(query);
    });
  }

  void clear() {
    state = const AsyncData([]);
  }
}

/// Friends actions (add, accept, remove)
@riverpod
class FriendsActions extends _$FriendsActions {
  @override
  FutureOr<void> build() {}

  Future<bool> sendRequest(String friendId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(friendsRepositoryProvider);
      await repo.sendFriendRequest(friendId);
      ref.invalidate(friendsListProvider);
      ref.invalidate(pendingRequestsProvider);
    });
    return !state.hasError;
  }

  Future<bool> acceptRequest(String friendshipId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(friendsRepositoryProvider);
      await repo.acceptFriendRequest(friendshipId);
      ref.invalidate(friendsListProvider);
      ref.invalidate(pendingRequestsProvider);
    });
    return !state.hasError;
  }

  Future<bool> removeFriend(String friendshipId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(friendsRepositoryProvider);
      await repo.removeFriend(friendshipId);
      ref.invalidate(friendsListProvider);
    });
    return !state.hasError;
  }
}
