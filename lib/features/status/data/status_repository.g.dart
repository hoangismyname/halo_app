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

String _$statusRepositoryHash() => r'e7b2831179cf0a2197570c1daa4addba430cfaa2';
