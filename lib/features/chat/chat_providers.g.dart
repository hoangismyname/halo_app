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

/// Stream messages for a specific room

@ProviderFor(messagesStream)
final messagesStreamProvider = MessagesStreamFamily._();

/// Stream messages for a specific room

final class MessagesStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Map<String, dynamic>>>,
          List<Map<String, dynamic>>,
          Stream<List<Map<String, dynamic>>>
        >
    with
        $FutureModifier<List<Map<String, dynamic>>>,
        $StreamProvider<List<Map<String, dynamic>>> {
  /// Stream messages for a specific room
  MessagesStreamProvider._({
    required MessagesStreamFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'messagesStreamProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$messagesStreamHash();

  @override
  String toString() {
    return r'messagesStreamProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<Map<String, dynamic>>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Map<String, dynamic>>> create(Ref ref) {
    final argument = this.argument as String;
    return messagesStream(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is MessagesStreamProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$messagesStreamHash() => r'2685755e320a82e1d6e9481f02982bab15cb009d';

/// Stream messages for a specific room

final class MessagesStreamFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Map<String, dynamic>>>, String> {
  MessagesStreamFamily._()
    : super(
        retry: null,
        name: r'messagesStreamProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Stream messages for a specific room

  MessagesStreamProvider call(String roomId) =>
      MessagesStreamProvider._(argument: roomId, from: this);

  @override
  String toString() => r'messagesStreamProvider';
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

String _$chatActionsHash() => r'40e638f5c228519fc14d42b26279382565fb4673';

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
