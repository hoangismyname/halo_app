import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/constants/supabase_constants.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/location_repository.dart';

import '../../../friends/presentation/providers/friends_provider.dart';

part 'location_provider.g.dart';

/// Friend locations map: userId -> {lat, lng, timestamp}
@riverpod
class FriendLocations extends _$FriendLocations {
  @override
  Map<String, Map<String, dynamic>> build() {
    final isSharing = ref.watch(locationSharingProvider);
    if (!isSharing) return {};

    final Map<String, Map<String, dynamic>> initialState = {};
    
    // Load last known locations from database
    final friendsAsync = ref.watch(friendsListProvider);
    final friends = friendsAsync.value ?? [];
    
    for (final friend in friends) {
      if (friend.isLocationShared && friend.latitude != null && friend.longitude != null) {
        initialState[friend.id] = {
          'user_id': friend.id,
          'latitude': friend.latitude,
          'longitude': friend.longitude,
          'timestamp': friend.locationUpdatedAt?.toIso8601String() ?? DateTime.now().toIso8601String(),
          'precision': friend.locationPrecision,
        };
      }
    }

    // Subscribe to location broadcasts
    final repo = ref.watch(locationRepositoryProvider);
    final channel = repo.subscribeToLocations((payload) {
      final userId = payload['user_id'] as String?;
      if (userId != null) {
        state = {
          ...state,
          userId: payload,
        };
      }
    });

    ref.onDispose(() {
      channel.unsubscribe();
    });

    return initialState;
  }
}

/// Location sharing toggle
@riverpod
class LocationSharing extends _$LocationSharing {
  @override
  bool build() {
    // Use ref.read() instead of ref.watch() so that invalidating
    // currentProfileProvider does NOT cause this provider to rebuild
    // (which would reset the optimistic state and flicker the button).
    final profile = ref.read(currentProfileProvider).value;
    if (profile == null) return false;
    return profile.isLocationShared;
  }

  Future<void> toggle() async {
    final profile = ref.read(currentProfileProvider).value;
    if (profile == null) return;

    final newState = !state;
    // optimistic update
    state = newState;

    try {
      final supabase = Supabase.instance.client;
      await supabase
          .from(SupabaseConstants.profilesTable)
          .update({'is_location_shared': newState})
          .eq('id', profile.id);

      final repo = ref.read(locationRepositoryProvider);
      if (newState) {
        repo.startLocationSharing(precision: profile.locationPrecision);
      } else {
        repo.stopLocationSharing();
      }

      // Refresh the profile for other consumers (e.g. ProfileScreen)
      // but do NOT invalidate this provider — the optimistic state is correct.
      ref.invalidate(currentProfileProvider);
    } catch (e) {
      debugPrint('Error toggling location sharing: $e');
      state = !newState; // revert
    }
  }
  
  Future<void> updatePrecision(String newPrecision) async {
    final profile = ref.read(currentProfileProvider).value;
    if (profile == null) return;

    try {
      final supabase = Supabase.instance.client;
      await supabase
          .from(SupabaseConstants.profilesTable)
          .update({'location_precision': newPrecision})
          .eq('id', profile.id);
          
      if (state) {
        final repo = ref.read(locationRepositoryProvider);
        repo.stopLocationSharing();
        repo.startLocationSharing(precision: newPrecision);
      }
      ref.invalidate(currentProfileProvider);
    } catch (e) {
      debugPrint('Error updating precision: $e');
    }
  }

  void start() {
    if (state) {
      final profile = ref.read(currentProfileProvider).value;
      ref.read(locationRepositoryProvider).startLocationSharing(precision: profile?.locationPrecision ?? 'absolute');
    }
  }

  void stop() {
    ref.read(locationRepositoryProvider).stopLocationSharing();
  }
}
