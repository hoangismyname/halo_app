// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Riverpod notifier that tracks weather at the user's real-time location.
///
/// Automatically refreshes every [_refreshIntervalMinutes] minutes and
/// whenever the user's position changes by more than 500 m.

@ProviderFor(WeatherNotifier)
final weatherProvider = WeatherNotifierProvider._();

/// Riverpod notifier that tracks weather at the user's real-time location.
///
/// Automatically refreshes every [_refreshIntervalMinutes] minutes and
/// whenever the user's position changes by more than 500 m.
final class WeatherNotifierProvider
    extends $NotifierProvider<WeatherNotifier, WeatherState> {
  /// Riverpod notifier that tracks weather at the user's real-time location.
  ///
  /// Automatically refreshes every [_refreshIntervalMinutes] minutes and
  /// whenever the user's position changes by more than 500 m.
  WeatherNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'weatherProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$weatherNotifierHash();

  @$internal
  @override
  WeatherNotifier create() => WeatherNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WeatherState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WeatherState>(value),
    );
  }
}

String _$weatherNotifierHash() => r'456dd185e37b54af22e913496f91364f6d483b55';

/// Riverpod notifier that tracks weather at the user's real-time location.
///
/// Automatically refreshes every [_refreshIntervalMinutes] minutes and
/// whenever the user's position changes by more than 500 m.

abstract class _$WeatherNotifier extends $Notifier<WeatherState> {
  WeatherState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<WeatherState, WeatherState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<WeatherState, WeatherState>,
              WeatherState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
