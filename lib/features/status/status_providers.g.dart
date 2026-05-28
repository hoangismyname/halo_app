// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'status_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Stream of all user statuses (excluding the current user).

@ProviderFor(statusesStream)
final statusesStreamProvider = StatusesStreamProvider._();

/// Stream of all user statuses (excluding the current user).

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
  /// Stream of all user statuses (excluding the current user).
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

String _$statusesStreamHash() => r'9b0e98a76e05d41291815a20f5c61844666af0d7';

/// Status update notifier.
///
/// Call [updateStatus] to update the current user's status.
/// The returned [StatusUpdateResult] contains both the success flag
/// and any error message — do NOT read the provider again after the
/// async call, as the provider may have been auto-disposed.

@ProviderFor(StatusNotifier)
final statusProvider = StatusNotifierProvider._();

/// Status update notifier.
///
/// Call [updateStatus] to update the current user's status.
/// The returned [StatusUpdateResult] contains both the success flag
/// and any error message — do NOT read the provider again after the
/// async call, as the provider may have been auto-disposed.
final class StatusNotifierProvider
    extends $AsyncNotifierProvider<StatusNotifier, void> {
  /// Status update notifier.
  ///
  /// Call [updateStatus] to update the current user's status.
  /// The returned [StatusUpdateResult] contains both the success flag
  /// and any error message — do NOT read the provider again after the
  /// async call, as the provider may have been auto-disposed.
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

String _$statusNotifierHash() => r'1e26b88c952ebe5d1d7acdb78991f17b1c8fc21a';

/// Status update notifier.
///
/// Call [updateStatus] to update the current user's status.
/// The returned [StatusUpdateResult] contains both the success flag
/// and any error message — do NOT read the provider again after the
/// async call, as the provider may have been auto-disposed.

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
