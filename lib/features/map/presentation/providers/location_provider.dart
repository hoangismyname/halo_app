import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/location_repository.dart';

part 'location_provider.g.dart';

/// Friend locations map: userId -> {lat, lng, timestamp}
@riverpod
class FriendLocations extends _$FriendLocations {
  @override
  Map<String, Map<String, dynamic>> build() {
    // Subscribe to location broadcasts
    final repo = ref.watch(locationRepositoryProvider);
    repo.subscribeToLocations((payload) {
      final userId = payload['user_id'] as String?;
      if (userId != null) {
        state = {
          ...state,
          userId: payload,
        };
      }
    });
    return {};
  }
}

/// Location sharing toggle
@riverpod
class LocationSharing extends _$LocationSharing {
  @override
  bool build() => false;

  void toggle() {
    final repo = ref.read(locationRepositoryProvider);
    if (state) {
      repo.stopLocationSharing();
    } else {
      repo.startLocationSharing();
    }
    state = !state;
  }

  void start() {
    if (!state) {
      ref.read(locationRepositoryProvider).startLocationSharing();
      state = true;
    }
  }

  void stop() {
    if (state) {
      ref.read(locationRepositoryProvider).stopLocationSharing();
      state = false;
    }
  }
}
