// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// List of chat rooms

@ProviderFor(chatRoomsList)
final chatRoomsListProvider = ChatRoomsListProvider._();

/// List of chat rooms

final class ChatRoomsListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ChatRoomModel>>,
          List<ChatRoomModel>,
          FutureOr<List<ChatRoomModel>>
        >
    with
        $FutureModifier<List<ChatRoomModel>>,
        $FutureProvider<List<ChatRoomModel>> {
  /// List of chat rooms
  ChatRoomsListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatRoomsListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatRoomsListHash();

  @$internal
  @override
  $FutureProviderElement<List<ChatRoomModel>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ChatRoomModel>> create(Ref ref) {
    return chatRoomsList(ref);
  }
}

String _$chatRoomsListHash() => r'29668e8ee46602aba6132b94cf86ebf4f51e25ea';

/// List of chat rooms with last message info

@ProviderFor(chatRoomsWithLastMessage)
final chatRoomsWithLastMessageProvider = ChatRoomsWithLastMessageProvider._();

/// List of chat rooms with last message info

final class ChatRoomsWithLastMessageProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Map<String, dynamic>>>,
          List<Map<String, dynamic>>,
          FutureOr<List<Map<String, dynamic>>>
        >
    with
        $FutureModifier<List<Map<String, dynamic>>>,
        $FutureProvider<List<Map<String, dynamic>>> {
  /// List of chat rooms with last message info
  ChatRoomsWithLastMessageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatRoomsWithLastMessageProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatRoomsWithLastMessageHash();

  @$internal
  @override
  $FutureProviderElement<List<Map<String, dynamic>>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Map<String, dynamic>>> create(Ref ref) {
    return chatRoomsWithLastMessage(ref);
  }
}

String _$chatRoomsWithLastMessageHash() =>
    r'e5397e16ee981cab3d458df63c80e208f35b2000';

/// Manages paginated message loading + realtime inserts for a single room.
///
/// - `build()`: fetches the most recent [_kPageSize] messages and subscribes
///   to realtime INSERT events.
/// - `loadMore()`: fetches the next [_kPageSize] older messages and prepends
///   them to the current state.
/// - Realtime inserts are appended to the end of the list automatically.

@ProviderFor(ChatRoomMessages)
final chatRoomMessagesProvider = ChatRoomMessagesFamily._();

/// Manages paginated message loading + realtime inserts for a single room.
///
/// - `build()`: fetches the most recent [_kPageSize] messages and subscribes
///   to realtime INSERT events.
/// - `loadMore()`: fetches the next [_kPageSize] older messages and prepends
///   them to the current state.
/// - Realtime inserts are appended to the end of the list automatically.
final class ChatRoomMessagesProvider
    extends
        $AsyncNotifierProvider<ChatRoomMessages, List<Map<String, dynamic>>> {
  /// Manages paginated message loading + realtime inserts for a single room.
  ///
  /// - `build()`: fetches the most recent [_kPageSize] messages and subscribes
  ///   to realtime INSERT events.
  /// - `loadMore()`: fetches the next [_kPageSize] older messages and prepends
  ///   them to the current state.
  /// - Realtime inserts are appended to the end of the list automatically.
  ChatRoomMessagesProvider._({
    required ChatRoomMessagesFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'chatRoomMessagesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$chatRoomMessagesHash();

  @override
  String toString() {
    return r'chatRoomMessagesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ChatRoomMessages create() => ChatRoomMessages();

  @override
  bool operator ==(Object other) {
    return other is ChatRoomMessagesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$chatRoomMessagesHash() => r'ec517e0e8dc11458422c1ae701dab9c77283006a';

/// Manages paginated message loading + realtime inserts for a single room.
///
/// - `build()`: fetches the most recent [_kPageSize] messages and subscribes
///   to realtime INSERT events.
/// - `loadMore()`: fetches the next [_kPageSize] older messages and prepends
///   them to the current state.
/// - Realtime inserts are appended to the end of the list automatically.

final class ChatRoomMessagesFamily extends $Family
    with
        $ClassFamilyOverride<
          ChatRoomMessages,
          AsyncValue<List<Map<String, dynamic>>>,
          List<Map<String, dynamic>>,
          FutureOr<List<Map<String, dynamic>>>,
          String
        > {
  ChatRoomMessagesFamily._()
    : super(
        retry: null,
        name: r'chatRoomMessagesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Manages paginated message loading + realtime inserts for a single room.
  ///
  /// - `build()`: fetches the most recent [_kPageSize] messages and subscribes
  ///   to realtime INSERT events.
  /// - `loadMore()`: fetches the next [_kPageSize] older messages and prepends
  ///   them to the current state.
  /// - Realtime inserts are appended to the end of the list automatically.

  ChatRoomMessagesProvider call(String roomId) =>
      ChatRoomMessagesProvider._(argument: roomId, from: this);

  @override
  String toString() => r'chatRoomMessagesProvider';
}

/// Manages paginated message loading + realtime inserts for a single room.
///
/// - `build()`: fetches the most recent [_kPageSize] messages and subscribes
///   to realtime INSERT events.
/// - `loadMore()`: fetches the next [_kPageSize] older messages and prepends
///   them to the current state.
/// - Realtime inserts are appended to the end of the list automatically.

abstract class _$ChatRoomMessages
    extends $AsyncNotifier<List<Map<String, dynamic>>> {
  late final _$args = ref.$arg as String;
  String get roomId => _$args;

  FutureOr<List<Map<String, dynamic>>> build(String roomId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<Map<String, dynamic>>>,
              List<Map<String, dynamic>>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<Map<String, dynamic>>>,
                List<Map<String, dynamic>>
              >,
              AsyncValue<List<Map<String, dynamic>>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}

/// Chat actions notifier

@ProviderFor(ChatActions)
final chatActionsProvider = ChatActionsProvider._();

/// Chat actions notifier
final class ChatActionsProvider
    extends $AsyncNotifierProvider<ChatActions, void> {
  /// Chat actions notifier
  ChatActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatActionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatActionsHash();

  @$internal
  @override
  ChatActions create() => ChatActions();
}

String _$chatActionsHash() => r'4fa5df8b691ee25fff38f34432a30901d1fc8bdc';

/// Chat actions notifier

abstract class _$ChatActions extends $AsyncNotifier<void> {
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
