import 'dart:async';
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

  /// Start broadcasting location via Supabase Realtime
  void startLocationSharing() {
    if (kIsWeb) return; // Web doesn't share location

    _locationChannel = _client.channel(SupabaseConstants.locationChannel);

    _positionSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 20, // Update every 20 meters
      ),
    ).listen((position) {
      // Broadcast to other users
      _locationChannel?.sendBroadcastMessage(
        event: 'location',
        payload: {
          'user_id': _userId,
          'latitude': position.latitude,
          'longitude': position.longitude,
          'timestamp': DateTime.now().toIso8601String(),
          'speed': position.speed,
        },
      );

      // Also update the database periodically
      _updateLocationInDB(position.latitude, position.longitude);
    });

    _locationChannel?.subscribe();
  }

  /// Stop sharing location
  void stopLocationSharing() {
    _positionSubscription?.cancel();
    _positionSubscription = null;
    _locationChannel?.unsubscribe();
    _locationChannel = null;
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
LocationRepository locationRepository(ref) {
  final repo = LocationRepository(Supabase.instance.client);
  ref.onDispose(() => repo.dispose());
  return repo;
}
