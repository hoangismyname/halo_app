// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friends_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// All accepted friends

@ProviderFor(friendsList)
final friendsListProvider = FriendsListProvider._();

/// All accepted friends

final class FriendsListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<UserModel>>,
          List<UserModel>,
          FutureOr<List<UserModel>>
        >
    with $FutureModifier<List<UserModel>>, $FutureProvider<List<UserModel>> {
  /// All accepted friends
  FriendsListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'friendsListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$friendsListHash();

  @$internal
  @override
  $FutureProviderElement<List<UserModel>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<UserModel>> create(Ref ref) {
    return friendsList(ref);
  }
}

String _$friendsListHash() => r'4e49709352ece4cecde1474ce9751cb13f60eb01';

/// Pending friend requests

@ProviderFor(pendingRequests)
final pendingRequestsProvider = PendingRequestsProvider._();

/// Pending friend requests

final class PendingRequestsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Map<String, dynamic>>>,
          List<Map<String, dynamic>>,
          FutureOr<List<Map<String, dynamic>>>
        >
    with
        $FutureModifier<List<Map<String, dynamic>>>,
        $FutureProvider<List<Map<String, dynamic>>> {
  /// Pending friend requests
  PendingRequestsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pendingRequestsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pendingRequestsHash();

  @$internal
  @override
  $FutureProviderElement<List<Map<String, dynamic>>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Map<String, dynamic>>> create(Ref ref) {
    return pendingRequests(ref);
  }
}

String _$pendingRequestsHash() => r'3f457d7addaadf60ab3662988c0af17d20e77232';

/// Search users

@ProviderFor(UserSearch)
final userSearchProvider = UserSearchProvider._();

/// Search users
final class UserSearchProvider
    extends $AsyncNotifierProvider<UserSearch, List<UserModel>> {
  /// Search users
  UserSearchProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userSearchProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userSearchHash();

  @$internal
  @override
  UserSearch create() => UserSearch();
}

String _$userSearchHash() => r'4e413c53e0f2e79b5d3a021fffc09d5e930fd390';

/// Search users

abstract class _$UserSearch extends $AsyncNotifier<List<UserModel>> {
  FutureOr<List<UserModel>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<UserModel>>, List<UserModel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<UserModel>>, List<UserModel>>,
              AsyncValue<List<UserModel>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Friends actions (add, accept, remove)

@ProviderFor(FriendsActions)
final friendsActionsProvider = FriendsActionsProvider._();

/// Friends actions (add, accept, remove)
final class FriendsActionsProvider
    extends $AsyncNotifierProvider<FriendsActions, void> {
  /// Friends actions (add, accept, remove)
  FriendsActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'friendsActionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$friendsActionsHash();

  @$internal
  @override
  FriendsActions create() => FriendsActions();
}

String _$friendsActionsHash() => r'691d353fba58c237f3b8127d620186587d379ac1';

/// Friends actions (add, accept, remove)

abstract class _$FriendsActions extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
