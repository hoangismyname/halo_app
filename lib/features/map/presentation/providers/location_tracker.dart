import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'location_tracker.g.dart';

/// Holds the user's current position.
///
/// This provider runs the Geolocator position stream **in the background**,
/// independent of the MapScreen lifecycle. It keeps the stream alive even
/// when the user navigates to other screens (Chat, Friends, Profile, etc.)
/// so that the user's position is always up-to-date when they return to the
/// map.
@riverpod
class LocationTracker extends _$LocationTracker {
  StreamSubscription<Position>? _stream;

  @override
  Position? build() {
    // Keep this provider alive even when no widget is listening.
    // This ensures the Geolocator stream keeps running in the background
    // when the user navigates away from the MapScreen.
    ref.keepAlive();
    ref.onDispose(_dispose);

    _initTracking();
    return null;
  }

  Future<void> _initTracking() async {
    if (kIsWeb) return;

    final prefs = await SharedPreferences.getInstance();

    // Restore last saved position immediately so consumers have a value
    final lastLat = prefs.getDouble('last_lat');
    final lastLng = prefs.getDouble('last_lng');
    if (lastLat != null && lastLng != null) {
      state = Position(
        latitude: lastLat,
        longitude: lastLng,
        timestamp: DateTime.now(),
        accuracy: 0,
        altitude: 0,
        heading: 0,
        speed: 0,
        speedAccuracy: 0,
        altitudeAccuracy: 0,
        headingAccuracy: 0,
      );
    }

    // Check permissions
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return;
    }

    // Get current position immediately for an accurate starting point
    try {
      final currentPos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      state = currentPos;
      _savePosition(currentPos);
    } catch (e) {
      debugPrint('LocationTracker: initial position failed: $e');
    }

    // Start the continuous position stream
    _stream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen((pos) {
      state = pos;
      _savePosition(pos);
    });
  }

  Future<void> _savePosition(Position pos) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble('last_lat', pos.latitude);
    prefs.setDouble('last_lng', pos.longitude);
  }

  void _dispose() {
    _stream?.cancel();
    _stream = null;
  }
}
