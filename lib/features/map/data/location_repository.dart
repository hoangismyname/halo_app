import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/constants/supabase_constants.dart';

part 'location_repository.g.dart';

class LocationRepository {
  final SupabaseClient _client;
  StreamSubscription<Position>? _positionSubscription;
  RealtimeChannel? _locationChannel;

  LocationRepository(this._client);

  String? get _userId => _client.auth.currentUser?.id;

  /// Check and request location permissions
  Future<bool> checkPermissions() async {
    if (kIsWeb) return true; // Web handles permissions differently

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return false;
    }
    if (permission == LocationPermission.deniedForever) return false;

    return true;
  }

  /// Get current position
  Future<Position?> getCurrentPosition() async {
    try {
      final hasPermission = await checkPermissions();
      if (!hasPermission) return null;

      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10,
        ),
      );
    } catch (e) {
      debugPrint('Error getting location: $e');
      return null;
    }
  }

  Position? _lastExactPosition;
  double? _fuzzedLat;
  double? _fuzzedLng;

  /// Start broadcasting location via Supabase Realtime
  void startLocationSharing({String precision = 'absolute'}) {
    if (kIsWeb) return; // Web doesn't share location

    _locationChannel = _client.channel(SupabaseConstants.locationChannel);

    _positionSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 20, // Update every 20 meters
      ),
    ).listen((position) {
      double lat = position.latitude;
      double lng = position.longitude;
      double? speed = position.speed;

      if (precision == 'relative') {
        _updateFuzzedLocation(position);
        lat = _fuzzedLat!;
        lng = _fuzzedLng!;
        speed = 0.0; // Hide speed for privacy
      }

      // Broadcast to other users
      _locationChannel?.sendBroadcastMessage(
        event: 'location',
        payload: {
          'user_id': _userId,
          'latitude': lat,
          'longitude': lng,
          'precision': precision,
          'timestamp': DateTime.now().toIso8601String(),
          'speed': speed,
        },
      );

      // Also update the database periodically
      _updateLocationInDB(lat, lng);
    });

    _locationChannel?.subscribe();
  }

  void _updateFuzzedLocation(Position currentPosition) {
    if (_lastExactPosition == null || _fuzzedLat == null || _fuzzedLng == null) {
      _generateNewFuzzedLocation(currentPosition);
      return;
    }
    
    // Calculate distance from last exact position
    final distance = Geolocator.distanceBetween(
      _lastExactPosition!.latitude,
      _lastExactPosition!.longitude,
      currentPosition.latitude,
      currentPosition.longitude,
    );
    
    // If moved more than 1km from where we last generated the offset, regenerate it
    if (distance > 1000) {
      _generateNewFuzzedLocation(currentPosition);
    }
  }

  void _generateNewFuzzedLocation(Position position) {
    _lastExactPosition = position;
    final random = math.Random();
    
    // Random distance between 500m and 1000m
    final distance = 500 + random.nextDouble() * 500;
    // Random angle in radians
    final angle = random.nextDouble() * 2 * math.pi;
    
    // 1 degree of latitude is ~111,320 meters
    final latOffset = (distance * math.cos(angle)) / 111320.0;
    // 1 degree of longitude depends on latitude
    final lngOffset = (distance * math.sin(angle)) / (111320.0 * math.cos(position.latitude * math.pi / 180.0));
    
    _fuzzedLat = position.latitude + latOffset;
    _fuzzedLng = position.longitude + lngOffset;
  }

  /// Stop sharing location
  void stopLocationSharing() {
    _positionSubscription?.cancel();
    _positionSubscription = null;
    _locationChannel?.unsubscribe();
    _locationChannel = null;
    _lastExactPosition = null;
    _fuzzedLat = null;
    _fuzzedLng = null;
  }

  /// Subscribe to friend location broadcasts
  RealtimeChannel subscribeToLocations(
      void Function(Map<String, dynamic>) onLocation) {
    final channel = _client.channel(SupabaseConstants.locationChannel);
    channel
        .onBroadcast(
          event: 'location',
          callback: (payload) => onLocation(payload),
        )
        .subscribe();
    return channel;
  }

  /// Update location in the database
  Future<void> _updateLocationInDB(double lat, double lng) async {
    if (_userId == null) return;
    try {
      await _client.from(SupabaseConstants.profilesTable).update({
        'latitude': lat,
        'longitude': lng,
        'location_updated_at': DateTime.now().toIso8601String(),
      }).eq('id', _userId!);
    } catch (e) {
      debugPrint('Error updating location in DB: $e');
    }
  }

  void dispose() {
    stopLocationSharing();
  }
}

@riverpod
LocationRepository locationRepository(Ref ref) {
  final repo = LocationRepository(Supabase.instance.client);
  ref.onDispose(() => repo.dispose());
  return repo;
}
