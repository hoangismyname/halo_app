// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'status_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(statusRepository)
final statusRepositoryProvider = StatusRepositoryProvider._();

final class StatusRepositoryProvider
    extends
        $FunctionalProvider<
          StatusRepository,
          StatusRepository,
          StatusRepository
        >
    with $Provider<StatusRepository> {
  StatusRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'statusRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$statusRepositoryHash();

  @$internal
  @override
  $ProviderElement<StatusRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  StatusRepository create(Ref ref) {
    return statusRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StatusRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StatusRepository>(value),
    );
  }
}

String _$statusRepositoryHash() => r'd10b0330043ad0d98919ea5533e8e438376923cd';
