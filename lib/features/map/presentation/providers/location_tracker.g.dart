// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_tracker.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Holds the user's current position.
///
/// This provider runs the Geolocator position stream **in the background**,
/// independent of the MapScreen lifecycle. It keeps the stream alive even
/// when the user navigates to other screens (Chat, Friends, Profile, etc.)
/// so that the user's position is always up-to-date when they return to the
/// map.

@ProviderFor(LocationTracker)
final locationTrackerProvider = LocationTrackerProvider._();

/// Holds the user's current position.
///
/// This provider runs the Geolocator position stream **in the background**,
/// independent of the MapScreen lifecycle. It keeps the stream alive even
/// when the user navigates to other screens (Chat, Friends, Profile, etc.)
/// so that the user's position is always up-to-date when they return to the
/// map.
final class LocationTrackerProvider
    extends $NotifierProvider<LocationTracker, Position?> {
  /// Holds the user's current position.
  ///
  /// This provider runs the Geolocator position stream **in the background**,
  /// independent of the MapScreen lifecycle. It keeps the stream alive even
  /// when the user navigates to other screens (Chat, Friends, Profile, etc.)
  /// so that the user's position is always up-to-date when they return to the
  /// map.
  LocationTrackerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'locationTrackerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$locationTrackerHash();

  @$internal
  @override
  LocationTracker create() => LocationTracker();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Position? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Position?>(value),
    );
  }
}

String _$locationTrackerHash() => r'a4f024c0ea7398086dfea829865ce3b3d81fb35b';

/// Holds the user's current position.
///
/// This provider runs the Geolocator position stream **in the background**,
/// independent of the MapScreen lifecycle. It keeps the stream alive even
/// when the user navigates to other screens (Chat, Friends, Profile, etc.)
/// so that the user's position is always up-to-date when they return to the
/// map.

abstract class _$LocationTracker extends $Notifier<Position?> {
  Position? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Position?, Position?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Position?, Position?>,
              Position?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
