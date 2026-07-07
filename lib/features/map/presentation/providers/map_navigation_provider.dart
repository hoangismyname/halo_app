import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as geo;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/constants/env.dart';

part 'map_navigation_provider.g.dart';

class MapNavigationState {
  final bool isLoading;
  final bool isNavigating;
  final String? errorMessage;
  final List<geo.Position>? routeCoordinates;
  final double? distance;
  final double? duration;
  final String? targetUserId;

  MapNavigationState({
    this.isLoading = false,
    this.isNavigating = false,
    this.errorMessage,
    this.routeCoordinates,
    this.distance,
    this.duration,
    this.targetUserId,
  });

  MapNavigationState copyWith({
    bool? isLoading,
    bool? isNavigating,
    Object? errorMessage = _unset,
    List<geo.Position>? routeCoordinates,
    double? distance,
    double? duration,
    String? targetUserId,
  }) {
    return MapNavigationState(
      isLoading: isLoading ?? this.isLoading,
      isNavigating: isNavigating ?? this.isNavigating,
      errorMessage:
          errorMessage == _unset ? this.errorMessage : errorMessage as String?,
      routeCoordinates: routeCoordinates ?? this.routeCoordinates,
      distance: distance ?? this.distance,
      duration: duration ?? this.duration,
      targetUserId: targetUserId ?? this.targetUserId,
    );
  }
}

// Sentinel for copyWith — distinguishes "not provided" from explicit null.
const Object _unset = Object();

@riverpod
class MapNavigation extends _$MapNavigation {
  final _dio = Dio();

  @override
  MapNavigationState build() {
    return MapNavigationState();
  }

  void startNavigation() {
    if (state.routeCoordinates == null) return;
    state = state.copyWith(isNavigating: true);
  }

  void stopNavigation() {
    state = MapNavigationState();
  }

  Future<void> fetchRoute({
    required double startLat,
    required double startLng,
    required double endLat,
    required double endLng,
    String? friendId,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: _unset);

    try {
      final apiKey = Env.get('GEOAPIFY_API_KEY');
      if (apiKey.isEmpty) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'API Key không tồn tại.',
        );
        return;
      }

      // Geoapify waypoints format: lat,lng|lat,lng
      final url =
          'https://api.geoapify.com/v1/routing?waypoints=$startLat,$startLng|$endLat,$endLng&mode=drive&apiKey=$apiKey';

      final response = await _dio.get(url);

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final points = _parseCoordinates(data);

        if (points.isEmpty) {
          state = state.copyWith(
            isLoading: false,
            errorMessage: 'Không thể tìm thấy tuyến đường.',
          );
          return;
        }

        // Get properties
        double? distance;
        double? duration;
        final features = data['features'] as List?;
        if (features != null && features.isNotEmpty) {
          final properties = features[0]['properties'] as Map?;
          if (properties != null) {
            distance = (properties['distance'] as num?)?.toDouble();
            duration = (properties['time'] as num?)?.toDouble();
          }
        }

        state = MapNavigationState(
          isLoading: false,
          routeCoordinates: points,
          distance: distance,
          duration: duration,
          targetUserId: friendId,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Lỗi từ dịch vụ định vị: ${response.statusMessage}',
        );
      }
    } catch (e) {
      debugPrint('MapNavigationError: $e');
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Không thể kết nối đến máy chủ chỉ đường.',
      );
    }
  }

  void clearRoute() {
    state = MapNavigationState();
  }

  List<geo.Position> _parseCoordinates(Map<String, dynamic> responseJson) {
    final List<geo.Position> points = [];
    try {
      final features = responseJson['features'] as List?;
      if (features == null || features.isEmpty) return points;

      final firstFeature = features[0] as Map<String, dynamic>?;
      if (firstFeature == null) return points;

      final geometry = firstFeature['geometry'] as Map<String, dynamic>?;
      if (geometry == null) return points;

      final type = geometry['type'] as String?;
      final coordinates = geometry['coordinates'];

      if (type == 'LineString') {
        final coordsList = coordinates as List?;
        if (coordsList != null) {
          for (final coord in coordsList) {
            if (coord is List && coord.length >= 2) {
              final lng = (coord[0] as num).toDouble();
              final lat = (coord[1] as num).toDouble();
              points.add(geo.Position(lng, lat));
            }
          }
        }
      } else if (type == 'MultiLineString') {
        final lineStringsList = coordinates as List?;
        if (lineStringsList != null) {
          for (final lineString in lineStringsList) {
            if (lineString is List) {
              for (final coord in lineString) {
                if (coord is List && coord.length >= 2) {
                  final lng = (coord[0] as num).toDouble();
                  final lat = (coord[1] as num).toDouble();
                  points.add(geo.Position(lng, lat));
                }
              }
            }
          }
        }
      }
    } catch (e) {
      debugPrint('Error parsing Geoapify route geometry: $e');
    }
    return points;
  }
}
