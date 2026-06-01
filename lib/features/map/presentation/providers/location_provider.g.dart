// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Friend locations map: userId -> {lat, lng, timestamp}

@ProviderFor(FriendLocations)
final friendLocationsProvider = FriendLocationsProvider._();

/// Friend locations map: userId -> {lat, lng, timestamp}
final class FriendLocationsProvider
    extends
        $NotifierProvider<FriendLocations, Map<String, Map<String, dynamic>>> {
  /// Friend locations map: userId -> {lat, lng, timestamp}
  FriendLocationsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'friendLocationsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$friendLocationsHash();

  @$internal
  @override
  FriendLocations create() => FriendLocations();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, Map<String, dynamic>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, Map<String, dynamic>>>(
        value,
      ),
    );
  }
}

String _$friendLocationsHash() => r'f0e51089aabf5032ec560d699ad6b8f2dbe350c8';

/// Friend locations map: userId -> {lat, lng, timestamp}

abstract class _$FriendLocations
    extends $Notifier<Map<String, Map<String, dynamic>>> {
  Map<String, Map<String, dynamic>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              Map<String, Map<String, dynamic>>,
              Map<String, Map<String, dynamic>>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                Map<String, Map<String, dynamic>>,
                Map<String, Map<String, dynamic>>
              >,
              Map<String, Map<String, dynamic>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Location sharing toggle

@ProviderFor(LocationSharing)
final locationSharingProvider = LocationSharingProvider._();

/// Location sharing toggle
final class LocationSharingProvider
    extends $NotifierProvider<LocationSharing, bool> {
  /// Location sharing toggle
  LocationSharingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'locationSharingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$locationSharingHash();

  @$internal
  @override
  LocationSharing create() => LocationSharing();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$locationSharingHash() => r'3482d28312effad3e0b40fe0a0cfec6dbf53ba45';

/// Location sharing toggle

abstract class _$LocationSharing extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
