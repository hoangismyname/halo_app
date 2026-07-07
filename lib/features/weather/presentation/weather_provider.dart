import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/weather_repository.dart';
import '../domain/weather_state.dart';

part 'weather_provider.g.dart';

/// How often weather is automatically refreshed (minutes).
const _refreshIntervalMinutes = 10;

/// Riverpod notifier that tracks weather at the user's real-time location.
///
/// Automatically refreshes every [_refreshIntervalMinutes] minutes and
/// whenever the user's position changes by more than 500 m.
@riverpod
class WeatherNotifier extends _$WeatherNotifier {
  Timer? _refreshTimer;
  StreamSubscription<Position>? _positionStream;
  Position? _lastPosition;

  @override
  WeatherState build() {
    ref.onDispose(_dispose);
    // Defer tracking to avoid blocking the build phase with permission requests.
    Future.microtask(_startTracking);
    return const WeatherInitial();
  }

  // ──────────────────────────────────────────────────────────── lifecycle ──

  void _dispose() {
    _refreshTimer?.cancel();
    _positionStream?.cancel();
  }

  // ─────────────────────────────────────────────────────────── tracking ──

  Future<void> _startTracking() async {
    final hasPermission = await _ensurePermission();
    if (!hasPermission) {
      state = const WeatherError('Không có quyền truy cập vị trí.');
      return;
    }

    // Fetch immediately with current position.
    await _fetchForCurrentPosition();

    // Listen to position stream for significant moves.
    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.medium,
        distanceFilter: 500, // metres before a new fetch
      ),
    ).listen(_onPositionChanged);

    // Periodic background refresh.
    _refreshTimer = Timer.periodic(
      const Duration(minutes: _refreshIntervalMinutes),
      (_) => _fetchForCurrentPosition(),
    );
  }

  void _onPositionChanged(Position position) {
    _lastPosition = position;
    _fetchAt(position.latitude, position.longitude);
  }

  Future<void> _fetchForCurrentPosition() async {
    try {
      final position = _lastPosition ?? await Geolocator.getCurrentPosition();
      _lastPosition = position;
      await _fetchAt(position.latitude, position.longitude);
    } catch (e) {
      state = WeatherError(_humanReadableError(e));
    }
  }

  Future<void> _fetchAt(double lat, double lng) async {
    state = const WeatherLoading();
    try {
      final repo = ref.read(weatherRepositoryProvider);
      final weather = await repo.fetchCurrentWeather(
        latitude: lat,
        longitude: lng,
      );
      state = WeatherLoaded(weather);
    } catch (e) {
      state = WeatherError(_humanReadableError(e));
    }
  }

  // ────────────────────────────────────────────────────────── permissions ──

  Future<bool> _ensurePermission() async {
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
  }

  // ────────────────────────────────────────────────────────── public API ──

  /// Force a manual refresh at the current position.
  Future<void> refresh() => _fetchForCurrentPosition();

  // ─────────────────────────────────────────────────────────── helpers ──

  String _humanReadableError(Object error) {
    final msg = error.toString().toLowerCase();
    if (msg.contains('socketexception') || msg.contains('network')) {
      return 'Không có kết nối mạng.';
    }
    if (msg.contains('timeout')) {
      return 'Yêu cầu hết thời gian chờ.';
    }
    return 'Không thể tải thời tiết.';
  }
}
