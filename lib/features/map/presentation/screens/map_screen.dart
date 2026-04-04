import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/location_repository.dart';
import '../providers/location_provider.dart';
import '../../../friends/presentation/providers/friends_provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/halo_avatar.dart';
import '../../widgets/friend_bottom_sheet.dart';
import '../../widgets/map_controls.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen>
    with TickerProviderStateMixin {
  final MapController _mapController = MapController();
  LatLng _center = const LatLng(10.8231, 106.6297); // Default: Ho Chi Minh City
  LatLng? _myLocation;
  StreamSubscription<Position>? _positionStream;

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  Future<void> _initLocation() async {
    // Load last known location from cache
    final prefs = await SharedPreferences.getInstance();
    final lat = prefs.getDouble('last_lat');
    final lng = prefs.getDouble('last_lng');
    
    if (lat != null && lng != null && mounted) {
      setState(() {
        _myLocation = LatLng(lat, lng);
        _center = _myLocation!;
      });
    }

    if (!kIsWeb) {
      ref.read(locationSharingProvider.notifier).start();
      
      final repo = ref.read(locationRepositoryProvider);
      final hasPerm = await repo.checkPermissions();
      
      if (hasPerm) {
        // Fallback to geolocator's last known if cache is empty
        if (lat == null) {
          final lastKnown = await Geolocator.getLastKnownPosition();
          if (lastKnown != null && mounted) {
            setState(() {
              _myLocation = LatLng(lastKnown.latitude, lastKnown.longitude);
              _center = _myLocation!;
            });
            _mapController.move(_center, 15);
          }
        }
        
        // Listen to real-time updates
        _positionStream = Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high, 
            distanceFilter: 10,
          ),
        ).listen((pos) {
          if (mounted) {
            setState(() {
              _myLocation = LatLng(pos.latitude, pos.longitude);
            });
            prefs.setDouble('last_lat', pos.latitude);
            prefs.setDouble('last_lng', pos.longitude);
          }
        });
      }
    }
  }

  void _centerOnMe() {
    if (_myLocation != null) {
      _mapController.move(_myLocation!, 15);
    } else {
      _mapController.move(_center, 15);
    }
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final friendLocations = ref.watch(friendLocationsProvider);
    final friends = ref.watch(friendsListProvider);
    final isSharing = ref.watch(locationSharingProvider);

    return Scaffold(
      body: Stack(
        children: [
          // Map
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _center,
              initialZoom: 13,
              minZoom: 3,
              maxZoom: 18,
              backgroundColor: AppColors.background,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png',
                subdomains: const ['a', 'b', 'c', 'd'],
                userAgentPackageName: 'com.halo.app',
                retinaMode: true,
              ),

              // Friend markers
              MarkerLayer(
                markers: _buildFriendMarkers(friendLocations, friends),
              ),

              // My location marker
              if (!kIsWeb && _myLocation != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _myLocation!,
                      width: AppSizes.markerSize + 16,
                      height: AppSizes.markerSize + 16,
                      child: _buildMyMarker(),
                    ),
                  ],
                ),
            ],
          ),

          // Top gradient overlay
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.background.withValues(alpha: 0.8),
                    AppColors.background.withValues(alpha: 0),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          // Top bar
          Positioned(
            top: MediaQuery.paddingOf(context).top + 8,
            left: AppSizes.md,
            right: AppSizes.md,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // App title
                ShaderMask(
                  shaderCallback: (bounds) =>
                      AppColors.primaryGradient.createShader(bounds),
                  child: const Text(
                    'Halo',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),

                // Location sharing toggle
                if (!kIsWeb)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isSharing
                          ? AppColors.online.withValues(alpha: 0.15)
                          : AppColors.surfaceLight,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSharing
                            ? AppColors.online.withValues(alpha: 0.3)
                            : AppColors.border,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isSharing ? Icons.location_on : Icons.location_off,
                          size: 16,
                          color: isSharing
                              ? AppColors.online
                              : AppColors.textTertiary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isSharing ? 'Đang chia sẻ' : 'Tắt',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isSharing
                                ? AppColors.online
                                : AppColors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          // Map controls
          Positioned(
            right: AppSizes.md,
            bottom: AppSizes.xxl + 80,
            child: MapControls(
              onMyLocation: _centerOnMe,
              onZoomIn: () => _mapController.move(
                _mapController.camera.center,
                _mapController.camera.zoom + 1,
              ),
              onZoomOut: () => _mapController.move(
                _mapController.camera.center,
                _mapController.camera.zoom - 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Marker> _buildFriendMarkers(
    Map<String, Map<String, dynamic>> locations,
    AsyncValue<List<dynamic>> friends,
  ) {
    final markers = <Marker>[];

    locations.forEach((userId, data) {
      final lat = data['latitude'] as double?;
      final lng = data['longitude'] as double?;

      if (lat != null && lng != null) {
        markers.add(
          Marker(
            point: LatLng(lat, lng),
            width: AppSizes.markerSize + 8,
            height: AppSizes.markerSize + 8,
            child: GestureDetector(
              onTap: () => _showFriendSheet(userId, data),
              child: _buildFriendMarkerWidget(data),
            ),
          ),
        );
      }
    });

    return markers;
  }

  Widget _buildFriendMarkerWidget(Map<String, dynamic> data) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.primary, width: 3),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.4),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: const HaloAvatar(size: AppSizes.markerSize),
    );
  }

  Widget _buildMyMarker() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.mapMarkerSelf,
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [
          BoxShadow(
            color: AppColors.mapMarkerSelf.withValues(alpha: 0.5),
            blurRadius: 12,
            spreadRadius: 3,
          ),
        ],
      ),
      child: const Icon(Icons.person, color: Colors.white, size: 24),
    );
  }

  void _showFriendSheet(String userId, Map<String, dynamic> data) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          FriendBottomSheet(userId: userId, locationData: data),
    );
  }
}
