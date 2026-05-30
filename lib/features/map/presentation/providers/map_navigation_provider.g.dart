// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_navigation_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MapNavigation)
final mapNavigationProvider = MapNavigationProvider._();

final class MapNavigationProvider
    extends $NotifierProvider<MapNavigation, MapNavigationState> {
  MapNavigationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mapNavigationProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mapNavigationHash();

  @$internal
  @override
  MapNavigation create() => MapNavigation();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MapNavigationState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MapNavigationState>(value),
    );
  }
}

String _$mapNavigationHash() => r'32944a877cd08a83f31815bab582436213dfa5cc';

abstract class _$MapNavigation extends $Notifier<MapNavigationState> {
  MapNavigationState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<MapNavigationState, MapNavigationState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<MapNavigationState, MapNavigationState>,
              MapNavigationState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
