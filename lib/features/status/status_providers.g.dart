// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'status_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Stream of all user statuses

@ProviderFor(statusesStream)
final statusesStreamProvider = StatusesStreamProvider._();

/// Stream of all user statuses

final class StatusesStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Map<String, dynamic>>>,
          List<Map<String, dynamic>>,
          Stream<List<Map<String, dynamic>>>
        >
    with
        $FutureModifier<List<Map<String, dynamic>>>,
        $StreamProvider<List<Map<String, dynamic>>> {
  /// Stream of all user statuses
  StatusesStreamProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'statusesStreamProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$statusesStreamHash();

  @$internal
  @override
  $StreamProviderElement<List<Map<String, dynamic>>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Map<String, dynamic>>> create(Ref ref) {
    return statusesStream(ref);
  }
}

String _$statusesStreamHash() => r'772ae174c9e6e8ee3fd4540d08f3511c2c2ebb09';

/// Status update notifier

@ProviderFor(StatusNotifier)
final statusProvider = StatusNotifierProvider._();

/// Status update notifier
final class StatusNotifierProvider
    extends $AsyncNotifierProvider<StatusNotifier, void> {
  /// Status update notifier
  StatusNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'statusProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$statusNotifierHash();

  @$internal
  @override
  StatusNotifier create() => StatusNotifier();
}

String _$statusNotifierHash() => r'ba88efc2ffd300304d41b176799db271d9d5243a';

/// Status update notifier

abstract class _$StatusNotifier extends $AsyncNotifier<void> {
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
