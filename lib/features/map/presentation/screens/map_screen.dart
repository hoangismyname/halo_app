import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:halo/core/utils/position_extensions.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart'
    hide Position, LocationSettings;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as geo;
import '../../../friends/presentation/providers/friends_provider.dart';
import '../../../auth/domain/user_model.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/mapbox_constants.dart';
import '../providers/location_provider.dart';
import '../providers/location_tracker.dart';
import '../providers/map_navigation_provider.dart';
import '../../widgets/destination_bottom_sheet.dart';
import '../../widgets/friend_bottom_sheet.dart';
import '../../widgets/map_search_bar.dart';
import '../../widgets/map_3d_toggle_button.dart';
import '../../../weather/presentation/widgets/weather_overlay.dart';

/// Map camera follow mode (Google Maps style).
enum FollowMode {
  /// Not following — user can pan/rotate freely.
  none,

  /// Fly to user's location once (GPS dot).
  gps,

  /// Continuously follow user's position (map centers on user).
  follow,

  /// Follow + rotate map to user's heading (compass mode).
  compass,
}

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen>
    with TickerProviderStateMixin {
  MapboxMap? _mapboxMap;
  PointAnnotationManager? _annotationManager;
  PolylineAnnotationManager? _polylineManager;
  PolylineAnnotation? _routePolyline;
  PointAnnotation? _destinationAnnotation;
  PointAnnotation? _myLocationAnnotation;
  geo.Point? _myLocationPoint;
  Uint8List? _myLocationIconBytes;
  Uint8List? _destinationIconBytes;
  String? _lastAvatarUrl;
  String? _lastName;
  bool _isCreatingAnnotation = false;
  bool _imageNeedsRecreate = false;
  final Map<String, Uint8List> _friendIconBytes = {};
  final Map<String, PointAnnotation> _friendAnnotations = {};
  PolygonAnnotationManager? _polygonManager;
  final Map<String, PolygonAnnotation> _friendPolygons = {};
  double _currentZoom = 13;
  Cancelable? _tapCancelable;
  Timer? _compassSyncTimer;
  bool _is3DEnabled = false;

  Future<void> _toggle3D() async {
    if (_mapboxMap == null) return;
    setState(() {
      _is3DEnabled = !_is3DEnabled;
    });

    if (_is3DEnabled) {
      try {
        if (!(await _mapboxMap!.style.styleSourceExists('mapbox-dem'))) {
          await _mapboxMap!.style.addSource(
            RasterDemSource(
              id: 'mapbox-dem',
              url: 'mapbox://mapbox.mapbox-terrain-dem-v1',
              tileSize: 512,
              maxzoom: 14.0,
            ),
          );
        }
        await _mapboxMap!.style.setStyleTerrain(
          '{"source": "mapbox-dem", "exaggeration": 1.5}',
        );
      } catch (e) {
        debugPrint('Error enabling terrain: $e');
      }

      try {
        final existing = await _mapboxMap!.style.styleLayerExists(
          '3d-buildings',
        );
        if (!existing) {
          final layer = FillExtrusionLayer(
            id: '3d-buildings',
            sourceId: 'composite',
            sourceLayer: 'building',
            minZoom: 12.0,
            filter: ['==', 'extrude', 'true'],
            fillExtrusionHeightExpression: [
              'interpolate',
              ['linear'],
              ['zoom'],
              12,
              0,
              13,
              ['get', 'height'],
            ],
            fillExtrusionBaseExpression: [
              'interpolate',
              ['linear'],
              ['zoom'],
              12,
              0,
              13,
              ['get', 'min_height'],
            ],
            fillExtrusionColor: 0xFFAAC6D4,
            fillExtrusionOpacity: 0.8,
            fillExtrusionAmbientOcclusionIntensity: 0.3,
            fillExtrusionAmbientOcclusionRadius: 3.0,
          );

          if (_annotationManager != null) {
            await _mapboxMap!.style.addLayerAt(
              layer,
              LayerPosition(below: _annotationManager!.id),
            );
          } else {
            await _mapboxMap!.style.addLayer(layer);
          }
        }
      } catch (e) {
        debugPrint('Error enabling 3D buildings: $e');
      }

      try {
        final existing = await _mapboxMap!.style.styleLayerExists('sky-layer');
        if (!existing) {
          await _mapboxMap!.style.addLayer(
            SkyLayer(
              id: 'sky-layer',
              skyType: SkyType.ATMOSPHERE,
              skyAtmosphereSun: [0.0, 90.0],
              skyAtmosphereSunIntensity: 15.0,
            ),
          );
        }
      } catch (e) {
        debugPrint('Error enabling sky layer: $e');
      }

      _mapboxMap!.flyTo(
        CameraOptions(pitch: 60.0),
        MapAnimationOptions(duration: 1000),
      );
    } else {
      try {
        await _mapboxMap!.style.setStyleTerrain('{}');
      } catch (e) {
        // TODO: handle error
      }

      try {
        if (await _mapboxMap!.style.styleLayerExists('3d-buildings')) {
          await _mapboxMap!.style.removeStyleLayer('3d-buildings');
        }
      } catch (e) {
        // TODO: handle error
      }

      try {
        if (await _mapboxMap!.style.styleLayerExists('sky-layer')) {
          await _mapboxMap!.style.removeStyleLayer('sky-layer');
        }
      } catch (e) {
        // TODO: handle error
      }

      _mapboxMap!.flyTo(
        CameraOptions(pitch: 0.0),
        MapAnimationOptions(duration: 1000),
      );
    }
  }

  // Animation for smooth user avatar movement
  AnimationController? _myLocationAnimController;
  geo.Point? _myLocationStartPoint;
  geo.Point? _myLocationTargetPoint;

  /// Completer that fires once the map is created.
  final Completer<void> _mapCreated = Completer<void>();

  /// True once the map has flown to the user's location on this mount.
  /// Reset on every re-entry so the user always sees their position.
  bool _hasFlownToUser = false;

  /// Tracks the last synced position from the tracker to avoid redundant
  /// annotation updates on every build frame.
  geolocator.Position? _lastSyncedPosition;

  // ────────────────────────── follow mode & compass ──

  /// Map camera follow mode (Google Maps style).
  FollowMode _followMode = FollowMode.none;

  /// Current map bearing (degrees clockwise from north).
  double _currentBearing = 0;

  /// Last known heading from the location tracker (degrees clockwise from
  /// north). Updated as new positions arrive from the background tracker.
  double? _lastHeading;

  /// When true, the compass button is visible because the map has been
  /// rotated away from north (bearing != 0).
  bool _showCompass = false;

  /// Viewport state for driving / follow navigation mode (Google Maps style)
  ViewportState _currentViewport = const IdleViewportState();
  bool _isCameraFollowing = false;

  @override
  void initState() {
    super.initState();

    _myLocationAnimController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 1000,
      ), // Match standard GPS update interval
    );
    _myLocationAnimController!.addListener(_onMyLocationAnimTick);

    // The background LocationTracker provider is already running independently.
    // We just listen for position updates and update the map UI.
    _maybeFlyToUserFromTracker();
  }

  void _onMyLocationAnimTick() {
    if (_myLocationStartPoint == null ||
        _myLocationTargetPoint == null ||
        !mounted)
      return;

    final value = _myLocationAnimController!.value;
    final startLat = _myLocationStartPoint!.coordinates.lat as double;
    final startLng = _myLocationStartPoint!.coordinates.lng as double;
    final targetLat = _myLocationTargetPoint!.coordinates.lat as double;
    final targetLng = _myLocationTargetPoint!.coordinates.lng as double;

    final currentLat = ui.lerpDouble(startLat, targetLat, value)!;
    final currentLng = ui.lerpDouble(startLng, targetLng, value)!;

    // Do NOT call setState here to avoid rebuilding the widget tree 60fps!
    _myLocationPoint = geo.Point(
      coordinates: geo.Position(currentLng, currentLat),
    );

    _updateMyLocationAnnotation();

    // Also smoothly pan the camera if we are following
    if (_hasFlownToUser) {
      _maybeFollowUpdate();
    }
  }

  /// Fly to the user's position on first build (re-entry).
  /// The LocationTracker keeps the stream alive in the background, so we
  /// always have a fresh position even when returning from other screens.
  void _maybeFlyToUserFromTracker() {
    final position = ref.read(locationTrackerProvider);
    if (position != null && !_hasFlownToUser) {
      _onPositionUpdate(position);
    }
  }

  /// Called when a new position arrives from the background tracker.
  void _onPositionUpdate(geolocator.Position pos) {
    if (!mounted) return;

    final targetPoint = geo.Point(
      coordinates: geo.Position(pos.longitude, pos.latitude),
    );

    // Update heading for compass / bearing tracking
    _lastHeading = pos.heading > 0 ? pos.heading : null;

    if (_myLocationPoint == null) {
      // First update: set immediately and update annotation
      _myLocationPoint = targetPoint;
      _updateMyLocationAnnotation();
    } else {
      // Subsequent updates: smoothly animate from current point to new point
      _myLocationStartPoint = _myLocationPoint;
      _myLocationTargetPoint = targetPoint;
      _myLocationAnimController?.forward(from: 0.0);
    }

    if (!_hasFlownToUser) {
      _hasFlownToUser = true;
      // Wait for the map to be ready, then fly to the user
      if (_mapCreated.isCompleted) {
        _flyToMyLocation();
      } else {
        _mapCreated.future.then((_) {
          if (mounted) _flyToMyLocation();
        });
      }
    } else if (_myLocationPoint == null) {
      // Only do follow directly if we aren't animating.
      // If we are animating, _onMyLocationAnimTick handles the follow.
      _maybeFollowUpdate();
    }
  }

  /// If in FOLLOW or COMPASS mode, move the map camera to center on the user.
  void _maybeFollowUpdate() {
    if (_mapboxMap == null) return;
    final mode = _followMode;
    if (mode != FollowMode.follow && mode != FollowMode.compass) return;
    final point = _myLocationPoint;
    if (point == null) return;
    _mapboxMap!.setCamera(
      CameraOptions(
        center: point,
        zoom: _currentZoom,
        bearing: mode == FollowMode.compass
            ? (_lastHeading ?? _currentBearing)
            : 0,
      ),
    );
  }

  /// Cycle through follow modes: none → fly-to → follow → compass → none.
  void _toggleFollowMode() {
    switch (_followMode) {
      case FollowMode.none:
        _followMode = FollowMode.gps;
        _flyToMyLocation();
        break;
      case FollowMode.gps:
        _followMode = FollowMode.follow;
        // Keep centered, no bearing
        _centerOnUser();
        break;
      case FollowMode.follow:
        _followMode = FollowMode.compass;
        // Center + rotate to heading
        _centerOnUser();
        _updateMapBearing();
        break;
      case FollowMode.compass:
        _followMode = FollowMode.none;
        _updateMapBearing();
        break;
    }
    setState(() {});
  }

  /// Fly to user's location with animation. Used for initial GPS mode entry.
  void _flyToMyLocation() {
    if (_mapboxMap == null || _myLocationPoint == null) return;
    _mapboxMap!.flyTo(
      CameraOptions(
        center: _myLocationPoint,
        zoom: 15,
        bearing: _followMode == FollowMode.compass ? (_lastHeading ?? 0) : 0,
      ),
      MapAnimationOptions(duration: 2000),
    );
  }

  /// Instantly center the map on the user (no animation, for follow mode).
  void _centerOnUser() {
    if (_mapboxMap == null || _myLocationPoint == null) return;
    _mapboxMap!.flyTo(
      CameraOptions(
        center: _myLocationPoint,
        zoom: _currentZoom,
        bearing: _followMode == FollowMode.compass ? (_lastHeading ?? 0) : 0,
      ),
      MapAnimationOptions(duration: 1500),
    );
    // _mapboxMap!.setCamera(
    //   CameraOptions(
    //     center: _myLocationPoint,
    //     zoom: _currentZoom,
    //     bearing: _followMode == FollowMode.compass ? (_lastHeading ?? 0) : 0,
    //   ),
    // );
  }

  /// Rotate the map to the given bearing.
  void _updateMapBearing([double? bearing]) {
    if (_mapboxMap == null || _myLocationPoint == null) return;
    final b = bearing ?? (_followMode == FollowMode.compass ? _lastHeading : 0);
    _mapboxMap!.flyTo(
      CameraOptions(center: _myLocationPoint, bearing: b ?? 0),
      MapAnimationOptions(duration: 1500),
    );
  }

  /// Reset the compass to north (bearing = 0).
  void _resetCompass() {
    _followMode = FollowMode.none;
    _updateMapBearing(0);
    setState(() => _showCompass = false);
  }

  /// Listen to camera changes to detect manual rotation (compass visibility).
  void _onCameraChanged() {
    if (_mapboxMap == null) return;
    // Get current camera bearing to show/hide compass
    _mapboxMap!.getCameraState().then((state) {
      if (!mounted) return;
      final bearing = state.bearing;
      setState(() {
        _currentBearing = bearing;
        // Show compass when map is rotated more than 5 degrees from north
        _showCompass = bearing.abs() > 5;
        // If user manually rotates the map, exit follow mode
        if (_showCompass && _followMode != FollowMode.compass) {
          _followMode = FollowMode.none;
        }
      });
    });
  }

  /// Periodically sync the compass bearing from the map camera.
  void _startCompassSync() {
    _compassSyncTimer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      if (!mounted) return;
      _onCameraChanged();
    });
  }

  void _zoomIn() {
    if (_mapboxMap == null) return;
    _mapboxMap!.setCamera(CameraOptions(zoom: _currentZoom + 1));
    _currentZoom += 1;
  }

  void _zoomOut() {
    if (_mapboxMap == null) return;
    _mapboxMap!.setCamera(CameraOptions(zoom: _currentZoom - 1));
    _currentZoom -= 1;
  }

  @override
  void dispose() {
    _tapCancelable?.cancel();
    _compassSyncTimer?.cancel();
    _myLocationAnimController?.dispose();
    _removeDestinationMarker();
    _mapboxMap?.location.updateSettings(
      LocationComponentSettings(enabled: false),
    );
    _mapboxMap = null;
    _annotationManager = null;
    _polylineManager = null;
    _polygonManager = null;
    super.dispose();
  }

  // ────────────────────────────── route polyline ──

  // Helper method
  CameraOptions _buildRouteCameraOptions() {
    return CameraOptions(
      padding: MbxEdgeInsets(
        top: MapboxConstants.cameraVerticalPadding,
        left: MapboxConstants.cameraHorizontalPadding,
        bottom: MapboxConstants.cameraVerticalPadding,
        right: MapboxConstants.cameraHorizontalPadding,
      ),
      bearing: MapboxConstants.defaultBearing,
      pitch: MapboxConstants.defaultPitch,
    );
  }

  Future<void> flyToFitRoute(List<geo.Position> coords) async {
    if (_mapboxMap == null || coords.isEmpty) return;

    try {
      final camera = await _mapboxMap!.cameraForCoordinatesPadding(
        coords.toMapPoints(),
        _buildRouteCameraOptions(),
        null,
        null,
        null,
      );

      await _mapboxMap!.flyTo(camera, MapAnimationOptions(duration: 1500));
    } catch (e, stackTrace) {
      debugPrint('❌ flyToFitRoute failed: $e\n$stackTrace');
      // Tuỳ app: có thể emit error state nếu dùng Bloc/Riverpod
    }
  }

  /// Draws (or updates) the navigation polyline on the map.
  /// Styled to look like Google Maps: thick route body + thin casing.
  Future<void> _drawRoute(List<geo.Position> coords) async {
    if (!mounted || _polylineManager == null || coords.length < 2) return;

    // Convert to LineString geometry
    final geometry = geo.LineString(coordinates: coords);

    // secondaryDark = 0xFF651FFF — pass as ARGB int
    const routeColor = AppColors.secondaryDark;

    try {
      if (_routePolyline != null) {
        // Update existing polyline
        _routePolyline!.geometry = geometry;
        _routePolyline!.lineWidth = 6.0;
        _routePolyline!.lineColor = routeColor.toARGB32();
        await _polylineManager!.update(_routePolyline!);
      } else {
        // Create the route polyline
        _routePolyline = await _polylineManager!.create(
          PolylineAnnotationOptions(
            geometry: geometry,
            lineWidth: 6.0,
            lineColor: routeColor.toARGB32(),
            lineOpacity: 0.92,
            lineJoin: LineJoin.ROUND,
          ),
        );
        // lineCap is a manager-level style property
        await _polylineManager!.setLineCap(LineCap.ROUND);
      }

      // Fly camera to fit the route
      await flyToFitRoute(coords);
    } catch (e) {
      debugPrint('❌ _drawRoute failed: $e');
    }
  }

  /// Removes the polyline from the map.
  Future<void> _clearRoute() async {
    if (_polylineManager != null && _routePolyline != null) {
      final polyline = _routePolyline!;
      _routePolyline = null;
      try {
        await _polylineManager!.delete(polyline);
      } catch (e) {
        debugPrint('❌ _clearRoute failed: $e');
      }
    }
  }

  // ────────────────────────── destination marker (long-tap) ──

  /// Places a destination pin at the given [point] on the map.
  Future<void> _addDestinationMarker(geo.Point point) async {
    await _removeDestinationMarker();
    if (!mounted || _annotationManager == null) return;

    if (_destinationIconBytes == null) {
      try {
        final ByteData data = await rootBundle.load(
          'assets/icons/icons_location.png',
        );
        _destinationIconBytes = data.buffer.asUint8List(
          data.offsetInBytes,
          data.lengthInBytes,
        );
      } catch (e) {
        debugPrint('Error loading destination icon asset: $e');
      }
    }

    try {
      _destinationAnnotation = await _annotationManager!.create(
        PointAnnotationOptions(
          geometry: point,
          image: _destinationIconBytes,
          iconSize: 1.5,
          iconAnchor: IconAnchor.BOTTOM,
        ),
      );
    } catch (e) {
      debugPrint('Error creating destination marker: $e');
    }
  }

  /// Removes the destination marker from the map.
  Future<void> _removeDestinationMarker() async {
    if (_annotationManager != null && _destinationAnnotation != null) {
      try {
        await _annotationManager!.delete(_destinationAnnotation!);
      } catch (_) {
        // Marker may already have been removed.
      } finally {
        _destinationAnnotation = null;
      }
    }
  }

  /// Called when the user long-taps on the map.
  /// Extracts the coordinate and shows a bottom sheet to start navigation.
  void _onMapLongTap(MapContentGestureContext gestureContext) {
    final point = gestureContext.point;
    final lat = point.coordinates.lat;
    final lng = point.coordinates.lng;

    // Place a destination marker
    _addDestinationMarker(point);

    // Show destination bottom sheet
    if (!mounted) return;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => BackButtonListener(
        onBackButtonPressed: () async {
          // Bắt buộc đóng BottomSheet bằng đúng context của chính nó
          Navigator.of(context).pop();
          return true; // báo cho Flutter đã xử lý nút back
        },
        child: DestinationBottomSheet(
          latitude: lat.toDouble(),
          longitude: lng.toDouble(),
        ),
      ),
    ).whenComplete(() {
      // If user dismissed without navigating, remove the marker
      final navState = ref.read(mapNavigationProvider);
      if (navState.routeCoordinates == null) {
        _removeDestinationMarker();
      }
    });
  }

  Future<void> _closeAndClearRoute(bool isNavigating) async {
    if (!mounted) return;
    if (isNavigating) {
      await _exitNavigationMode();
    } else {
      ref.read(mapNavigationProvider.notifier).clearRoute();
      await _clearRoute();
      await _removeDestinationMarker();
    }
  }

  Future<void> _enterNavigationMode() async {
    ref.read(mapNavigationProvider.notifier).startNavigation();

    // Hide custom avatar annotation
    _updateMyLocationAnnotation();

    // Enable Mapbox location puck with heading bearing
    await _mapboxMap?.location.updateSettings(
      LocationComponentSettings(
        enabled: true,
        puckBearingEnabled: true,
        pulsingEnabled: true,
        showAccuracyRing: false,
      ),
    );

    setStateWithViewportAnimation(() {
      _isCameraFollowing = true;
      _currentViewport = FollowPuckViewportState(
        zoom: MapboxConstants.navigationZoom,
        bearing: const FollowPuckViewportStateBearingHeading(),
        pitch: MapboxConstants.navigationPitch,
        padding: MbxEdgeInsets(
          top: MapboxConstants.navigationPaddingTop,
          left: 0.0,
          bottom: 0.0,
          right: 0.0,
        ),
      );
    }, transition: const DefaultViewportTransition());
  }

  Future<void> _exitNavigationMode() async {
    ref.read(mapNavigationProvider.notifier).stopNavigation();
    _clearRoute();
    _removeDestinationMarker();

    // Disable Mapbox location puck
    await _mapboxMap?.location.updateSettings(
      LocationComponentSettings(enabled: false),
    );

    // Recreate custom avatar annotation
    _updateMyLocationAnnotation();

    setState(() {
      _isCameraFollowing = false;
      _currentViewport = const IdleViewportState();
    });

    _mapboxMap!.flyTo(
      CameraOptions(center: _myLocationPoint, zoom: 15, pitch: 0),
      MapAnimationOptions(duration: 1500),
    );
  }

  void _reCenterCamera() {
    setStateWithViewportAnimation(() {
      _isCameraFollowing = true;
      _currentViewport = FollowPuckViewportState(
        zoom: MapboxConstants.navigationZoom,
        bearing: const FollowPuckViewportStateBearingHeading(),
        pitch: MapboxConstants.navigationPitch,
        padding: MbxEdgeInsets(
          top: MapboxConstants.navigationPaddingTop,
          left: 0.0,
          bottom: 0.0,
          right: 0.0,
        ),
      );
    }, transition: const DefaultViewportTransition());
  }

  void _onMapScroll(MapContentGestureContext context) {
    final navState = ref.read(mapNavigationProvider);
    if (navState.isNavigating && _isCameraFollowing) {
      setState(() {
        _isCameraFollowing = false;
        _currentViewport = const IdleViewportState();
      });
    }
  }

  UserModel? _findFriend(String userId, List<UserModel> friendsList) {
    try {
      return friendsList.firstWhere((f) => f.id == userId);
    } catch (_) {
      return null;
    }
  }

  // ──────────────────────────── avatar icon rendering ──

  /// Renders a circular avatar icon with optional image, initials fallback,
  /// online indicator, and colored ring. Returns PNG bytes for Mapbox
  /// annotations.
  ///
  /// [avatarUrl] — optional network image URL for the avatar photo.
  /// [name] — display name used for the initial letter fallback.
  /// [accentColor] — ring/border color (cyan for self, primary for friends).
  /// [isSelf] — if true, draws a solid ring with person icon; otherwise
  ///   draws an outlined ring with initials inside.
  /// [showOnlineIndicator] — whether to draw a green dot at top-right.
  Future<Uint8List> _renderAvatarIcon({
    String? avatarUrl,
    required String name,
    required Color accentColor,
    bool isSelf = false,
    bool showOnlineIndicator = false,
  }) async {
    const size = 128;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final center = Offset(size / 2, size / 2);
    final radius = isSelf ? size / 2 - 8 : size / 2 - 10;

    // Outer glow ring
    canvas.drawCircle(
      center,
      radius + (isSelf ? 10 : 8),
      Paint()
        ..isAntiAlias = true
        ..color = accentColor.withValues(alpha: 0.3)
        ..style = PaintingStyle.fill,
    );

    // Solid ring
    canvas.drawCircle(
      center,
      radius + (isSelf ? 6 : 4),
      Paint()
        ..isAntiAlias = true
        ..color = accentColor
        ..style = PaintingStyle.fill,
    );

    // Inner white border
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..isAntiAlias = true
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );

    // Try to draw avatar image
    bool drewImage = false;
    if (avatarUrl != null && avatarUrl.isNotEmpty) {
      ui.Image? uiImage;
      try {
        // NEW CODE
        final imageProvider = NetworkImage(avatarUrl);
        final completer = Completer<ImageInfo>();
        final stream = imageProvider.resolve(ImageConfiguration.empty);

        final ImageStreamListener listener = ImageStreamListener(
          (info, _) {
            if (!completer.isCompleted) completer.complete(info);
          },
          onError: (error, stackTrace) {
            if (!completer.isCompleted) completer.completeError(error);
          },
        );

        stream.addListener(listener);

        final imageInfo = await completer.future
            .timeout(
              const Duration(seconds: 3),
              onTimeout: () => throw TimeoutException('Image load timeout'),
            )
            .whenComplete(
              () => stream.removeListener(listener),
            ); // Hủy listener tránh leak

        uiImage = imageInfo.image.clone();

        // Clip to circle
        canvas.save();
        canvas.clipPath(
          Path()..addOval(Rect.fromCircle(center: center, radius: radius)),
          doAntiAlias: true,
        );

        canvas.drawImageRect(
          uiImage,
          Rect.fromLTWH(
            0,
            0,
            uiImage.width.toDouble(),
            uiImage.height.toDouble(),
          ),
          Rect.fromCircle(center: center, radius: radius),
          Paint()
            ..isAntiAlias = true
            ..filterQuality = FilterQuality.high,
        );
        canvas.restore();
        drewImage = true;
      } catch (_) {
        // Fall through to initials
      } finally {
        uiImage?.dispose(); // Giải phóng bộ nhớ
      }
    }

    // Xử lý Fallback khi KHÔNG vẽ được ảnh (drewImage == false)
    if (!drewImage) {
      if (isSelf) {
        // Draw person icon avatar (self marker)
        final iconPainter = TextPainter(
          text: TextSpan(
            text: String.fromCharCode(Icons.person.codePoint),
            style: const TextStyle(
              fontFamily: 'MaterialIcons',
              fontSize: 36,
              color: Colors.white,
              shadows: [Shadow(color: Colors.black54, blurRadius: 4)],
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        iconPainter.layout();
        iconPainter.paint(
          canvas,
          Offset(
            center.dx - iconPainter.width / 2,
            center.dy - iconPainter.height / 2,
          ),
        );
      } else {
        final initial = (name.isNotEmpty ? name : '?')
            .substring(0, 1)
            .toUpperCase();

        // Nếu không phải user, vẽ một nền surface xám nhẹ
        canvas.drawCircle(
          center,
          radius,
          Paint()
            ..isAntiAlias = true
            ..color = AppColors.surface
            ..style = PaintingStyle.fill,
        );

        // Vẽ chữ cái đầu
        final textPainter = TextPainter(
          text: TextSpan(
            text: initial,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: accentColor,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();

        textPainter.paint(
          canvas,
          Offset(
            center.dx - textPainter.width / 2,
            center.dy - textPainter.height / 2,
          ),
        );
      }
    }

    // Online indicator
    if (showOnlineIndicator) {
      final indicatorPos = Offset(
        center.dx + radius - 2,
        center.dy - radius + 2,
      );
      canvas.drawCircle(
        indicatorPos,
        7,
        Paint()
          ..isAntiAlias = true
          ..color = AppColors.online
          ..style = PaintingStyle.fill,
      );
      canvas.drawCircle(
        indicatorPos,
        7,
        Paint()
          ..isAntiAlias = true
          ..color = AppColors.background
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
    }

    // Xuất hình ảnh dạng Byte
    final picture = recorder.endRecording();
    final image = await picture.toImage(size, size);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    // Giải phóng bộ nhớ
    picture.dispose();
    image.dispose();

    if (byteData == null) {
      throw StateError('Không thể render Canvas thành ByteData');
    }

    return byteData.buffer.asUint8List();
  }

  /// Creates the user's own location marker icon.
  /// If the user has an avatar, it's rendered; otherwise a person icon.
  Future<Uint8List> _createMyLocationIconBytes(UserModel? profile) async {
    return _renderAvatarIcon(
      avatarUrl: profile?.avatarUrl,
      name: profile?.displayName.isNotEmpty == true
          ? profile!.displayName
          : profile?.username ?? 'Me',
      accentColor: AppColors.mapMarkerSelf,
      isSelf: true,
    );
  }

  /// Creates a friend's location marker icon with avatar if available.
  Future<Uint8List> _createFriendIconBytes(
    UserModel? friend, {
    bool showOnline = false,
  }) async {
    final name = friend?.displayName.isNotEmpty == true
        ? friend!.displayName
        : friend?.username ?? '?';
    return _renderAvatarIcon(
      avatarUrl: friend?.avatarUrl,
      name: name,
      accentColor: AppColors.primary,
      showOnlineIndicator: showOnline,
    );
  }

  Future<Uint8List> _getMyLocationIconBytes(UserModel? profile) async {
    final avatarUrl = profile?.avatarUrl;
    final name = profile?.displayName.isNotEmpty == true
        ? profile!.displayName
        : profile?.username ?? 'Me';

    if (_myLocationIconBytes != null &&
        _lastAvatarUrl == avatarUrl &&
        _lastName == name) {
      return _myLocationIconBytes!;
    }

    _lastAvatarUrl = avatarUrl;
    _lastName = name;
    _myLocationIconBytes = await _createMyLocationIconBytes(profile);
    // Signal that the annotation image must be recreated
    _imageNeedsRecreate = true;
    return _myLocationIconBytes!;
  }

  Future<void> _onMapCreated(MapboxMap mapboxMap) async {
    _mapboxMap = mapboxMap;
    _annotationManager = await mapboxMap.annotations
        .createPointAnnotationManager();

    // Create a separate polyline manager for routing (below point markers)
    _polylineManager = await mapboxMap.annotations
        .createPolylineAnnotationManager(below: _annotationManager!.id);

    _polygonManager = await mapboxMap.annotations
        .createPolygonAnnotationManager(below: _annotationManager!.id);

    // Signal that the map is ready
    if (!_mapCreated.isCompleted) {
      _mapCreated.complete();
    }

    // Set up tap listener for friend annotations
    _tapCancelable = _annotationManager!.tapEvents(onTap: _onAnnotationTap);

    // Start periodic compass bearing sync
    _startCompassSync();

    // Initialize my location annotation
    _updateMyLocationAnnotation();
  }

  void _onAnnotationTap(PointAnnotation annotation) {
    final textField = annotation.textField;
    if (textField != null && textField.startsWith('friend_')) {
      final userId = textField.replaceFirst('friend_', '');
      final friendLocations = ref.read(friendLocationsProvider);
      final locationData = friendLocations[userId];
      final friendsAsync = ref.read(friendsListProvider);
      final friendsList = friendsAsync.value ?? [];
      final friend = _findFriend(userId, friendsList);
      if (locationData != null) {
        _showFriendSheet(userId, locationData, friend);
      }
    }
  }

  Future<void> _updateMyLocationAnnotation() async {
    if (!mounted || _myLocationPoint == null || _annotationManager == null) {
      return;
    }

    final isNavigating = ref.read(mapNavigationProvider).isNavigating;
    if (isNavigating) {
      if (_myLocationAnnotation != null) {
        try {
          await _annotationManager!.delete(_myLocationAnnotation!);
        } catch (e) {
          debugPrint('Error deleting myLocationAnnotation on navigation: $e');
        } finally {
          _myLocationAnnotation = null;
        }
      }
      return;
    }

    final profile = ref.read(currentProfileProvider).value;
    final iconBytes = await _getMyLocationIconBytes(profile);

    if (!mounted) return;

    if (_myLocationAnnotation != null) {
      if (_imageNeedsRecreate) {
        // Avatar image logically changed (URL or name changed):
        // delete and recreate the annotation with the new icon.
        _imageNeedsRecreate = false;
        try {
          await _annotationManager!.delete(_myLocationAnnotation!);
        } catch (e) {
          debugPrint('Error deleting myLocationAnnotation: $e');
        } finally {
          _myLocationAnnotation = null;
        }
      } else {
        // Only position changed — update geometry in-place.
        _myLocationAnnotation!.geometry = _myLocationPoint!;
        try {
          await _annotationManager!.update(_myLocationAnnotation!);
        } catch (e) {
          debugPrint('Error updating myLocationAnnotation: $e');
          _myLocationAnnotation = null;
        }
        if (_myLocationAnnotation != null) return;
      }
    }

    if (_isCreatingAnnotation) return;
    _isCreatingAnnotation = true;
    try {
      _myLocationAnnotation = await _annotationManager!.create(
        PointAnnotationOptions(
          geometry: _myLocationPoint!,
          image: iconBytes,
          iconSize: 1.0,
          iconAnchor: IconAnchor.CENTER,
        ),
      );
    } catch (e) {
      debugPrint('Error creating myLocationAnnotation: $e');
    } finally {
      _isCreatingAnnotation = false;
      // Re-sync if the point moved during creation
      if (mounted &&
          _myLocationAnnotation != null &&
          _myLocationAnnotation!.geometry != _myLocationPoint) {
        _myLocationAnnotation!.geometry = _myLocationPoint!;
        try {
          await _annotationManager!.update(_myLocationAnnotation!);
        } catch (e) {
          debugPrint('Error updating myLocationAnnotation after create: $e');
        }
      }
    }
  }

  List<geo.Position> _createCirclePolygon(
    double lat,
    double lng,
    double radiusMeters,
  ) {
    final List<geo.Position> coords = [];
    const double earthRadius = 6371000;
    final double d = radiusMeters / earthRadius;
    final double latR = lat * math.pi / 180.0;
    final double lngR = lng * math.pi / 180.0;

    for (int i = 0; i <= 36; i++) {
      final double bearing = i * 10 * math.pi / 180.0;
      final double lat2 = math.asin(
        math.sin(latR) * math.cos(d) +
            math.cos(latR) * math.sin(d) * math.cos(bearing),
      );
      final double lng2 =
          lngR +
          math.atan2(
            math.sin(bearing) * math.sin(d) * math.cos(latR),
            math.cos(d) - math.sin(latR) * math.sin(lat2),
          );
      coords.add(geo.Position(lng2 * 180.0 / math.pi, lat2 * 180.0 / math.pi));
    }
    return coords;
  }

  Future<void> _reloadFriendAnnotations() async {
    if (!mounted || _annotationManager == null || _polygonManager == null)
      return;

    final friendLocations = ref.read(friendLocationsProvider);
    final friendsAsync = ref.read(friendsListProvider);
    final friendsList = friendsAsync.value ?? [];

    try {
      // Delete existing friend annotations
      final existing = await _annotationManager!.getAnnotations();
      for (final annotation in existing) {
        final textField = annotation.textField;
        if (textField != null && textField.startsWith('friend_')) {
          await _annotationManager!.delete(annotation);
        }
      }
      for (final poly in _friendPolygons.values) {
        await _polygonManager!.delete(poly);
      }
    } catch (e) {
      debugPrint('Error clearing friend annotations: $e');
    }
    _friendAnnotations.clear();
    _friendPolygons.clear();

    // Create new friend annotations
    final optionsList = <PointAnnotationOptions>[];
    final polygonOptionsList = <PolygonAnnotationOptions>[];
    final userIds = <String>[];
    final polygonUserIds = <String>[];

    for (final entry in friendLocations.entries) {
      final userId = entry.key;
      final data = entry.value;
      final lat = data['latitude'] as double?;
      final lng = data['longitude'] as double?;
      final precision = data['precision'] as String?;

      if (lat != null && lng != null) {
        final friend = _findFriend(userId, friendsList);
        final isOnline = friend?.isOnline ?? false;
        final iconBytes =
            _friendIconBytes[userId] ??
            await _createFriendIconBytes(friend, showOnline: isOnline);
        _friendIconBytes[userId] = iconBytes;

        optionsList.add(
          PointAnnotationOptions(
            geometry: geo.Point(coordinates: geo.Position(lng, lat)),
            image: iconBytes,
            textField: 'friend_$userId',
            iconSize: 1.0,
            iconAnchor: IconAnchor.CENTER,
            iconOpacity: precision == 'relative' ? 0.6 : 1.0,
          ),
        );
        userIds.add(userId);

        if (precision == 'relative') {
          // Draw a 1km radius polygon (approximating the 500m-1km fuzzing)
          final coords = _createCirclePolygon(lat, lng, 1000);
          polygonOptionsList.add(
            PolygonAnnotationOptions(
              geometry: geo.Polygon(coordinates: [coords]),
              fillColor: AppColors.primary.toARGB32(),
              fillOpacity: 0.15,
              fillOutlineColor: AppColors.primary.toARGB32(),
            ),
          );
          polygonUserIds.add(userId);
        }
      }
    }

    if (!mounted) return;

    if (optionsList.isNotEmpty) {
      try {
        final annotations = await _annotationManager!.createMulti(optionsList);
        for (int i = 0; i < userIds.length; i++) {
          if (i < annotations.length && annotations[i] != null) {
            _friendAnnotations[userIds[i]] = annotations[i]!;
          }
        }
      } catch (e) {
        debugPrint('Error creating friend multi annotations: $e');
      }
    }

    if (polygonOptionsList.isNotEmpty) {
      try {
        final polygons = await _polygonManager!.createMulti(polygonOptionsList);
        for (int i = 0; i < polygonUserIds.length; i++) {
          if (i < polygons.length && polygons[i] != null) {
            _friendPolygons[polygonUserIds[i]] = polygons[i]!;
          }
        }
      } catch (e) {
        debugPrint('Error creating friend multi polygons: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSharing = ref.watch(locationSharingProvider);
    final locationPos = ref.watch(locationTrackerProvider);
    final profile = ref.watch(currentProfileProvider).value;
    final navState = ref.watch(mapNavigationProvider);

    // Trigger an annotation update if profile avatar or name changes
    final currentAvatarUrl = profile?.avatarUrl;
    final currentName = profile?.displayName.isNotEmpty == true
        ? profile!.displayName
        : profile?.username ?? 'Me';

    if (currentAvatarUrl != _lastAvatarUrl || currentName != _lastName) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _updateMyLocationAnnotation();
      });
    }

    // Sync position from the background tracker after the frame is built.
    // This avoids calling setState() during build.
    // Guarded by _lastSyncedPosition to avoid redundant annotation updates.
    if (locationPos != null && locationPos != _lastSyncedPosition) {
      _lastSyncedPosition = locationPos;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _onPositionUpdate(locationPos);
      });
    }

    ref.listen<Map<String, Map<String, dynamic>>>(friendLocationsProvider, (
      previous,
      next,
    ) {
      if (previous != next) {
        _reloadFriendAnnotations();
      }
    });

    // Listen to navigation state — draw / clear route polyline.
    ref.listen<MapNavigationState>(mapNavigationProvider, (previous, next) {
      final coords = next.routeCoordinates;
      final prevCoords = previous?.routeCoordinates;
      if (coords != null && coords != prevCoords) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _drawRoute(coords);
        });
      } else if (coords == null && prevCoords != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _clearRoute();
        });
      }
    });

    return Scaffold(
      body: Stack(
        children: [
          MapWidget(
            key: const ValueKey('halo_map'),
            onMapCreated: _onMapCreated,
            styleUri: MapboxConstants.darkStyleUrl,
            onLongTapListener: _onMapLongTap,
            viewport: _currentViewport,
            onScrollListener: _onMapScroll,
          ),

          // Top gradient overlay
          if (!navState.isNavigating)
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
          if (!navState.isNavigating)
            Positioned(
              top: MediaQuery.paddingOf(context).top + 8,
              left: AppSizes.md,
              right: AppSizes.md,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
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
                  const Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: MapSearchBar(),
                    ),
                  ),
                  if (!kIsWeb)
                    GestureDetector(
                      onTap: () =>
                          ref.read(locationSharingProvider.notifier).toggle(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
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
                              isSharing
                                  ? Icons.location_on
                                  : Icons.location_off,
                              size: 16,
                              color: isSharing
                                  ? AppColors.online
                                  : AppColors.textTertiary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              isSharing ? 'Bật' : 'Tắt',
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
                    ),
                ],
              ),
            ),

          // Weather chip — top-right below the search bar
          if (!navState.isNavigating)
            Positioned(
              right: AppSizes.md,
              top: MediaQuery.paddingOf(context).top + 68,
              child: const WeatherOverlay(),
            ),

          // Map controls — right side
          if (!navState.isNavigating)
            Positioned(
              right: AppSizes.md,
              bottom: AppSizes.xxl,
              child: Column(
                children: [
                  // Follow mode / location button
                  _FollowButton(mode: _followMode, onTap: _toggleFollowMode),
                  const SizedBox(height: 8),

                  // Zoom controls
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface.withValues(alpha: 0.95),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _MapControlButton(
                          icon: Icons.add,
                          onTap: _zoomIn,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                        ),
                        Container(height: 1, color: AppColors.divider),
                        _MapControlButton(icon: Icons.remove, onTap: _zoomOut),
                        Container(height: 1, color: AppColors.divider),
                        Map3DToggleButton(
                          is3DEnabled: _is3DEnabled,
                          onTap: _toggle3D,
                          borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          // Re-center button — shown when navigating and map is panned away
          if (navState.isNavigating && !_isCameraFollowing)
            Positioned(
              bottom: AppSizes.xxl + 100,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTap: _reCenterCamera,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.4),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.navigation, color: Colors.white, size: 16),
                        SizedBox(width: 6),
                        Text(
                          'Căn giữa',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          // Navigation HUD — shown at bottom when a route is active
          if (navState.routeCoordinates != null)
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                padding: const EdgeInsets.only(
                  left: AppSizes.md + 10,
                  bottom: AppSizes.xxl + 10,
                ),
                width: 300,
                child: _NavigationHUD(
                  distance: navState.distance,
                  duration: navState.duration,
                  isNavigating: navState.isNavigating,
                  onStart: _enterNavigationMode,
                  onClose: () => _closeAndClearRoute(navState.isNavigating),
                ),
              ),
            ),

          // Compass button — appears when map is rotated from north
          if (!navState.isNavigating &&
              (_showCompass || _followMode == FollowMode.compass))
            Positioned(
              right: AppSizes.md + 8,
              top: MediaQuery.paddingOf(context).top + 136,
              child: _CompassButton(
                bearing: _currentBearing,
                onTap: _resetCompass,
              ),
            ),
        ],
      ),
    );
  }

  void _showFriendSheet(
    String userId,
    Map<String, dynamic> data,
    UserModel? friend,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          FriendBottomSheet(userId: userId, locationData: data, friend: friend),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Follow mode button (Google Maps style location button)
// ─────────────────────────────────────────────────────────────────────────────

class _FollowButton extends StatelessWidget {
  final FollowMode mode;
  final VoidCallback onTap;

  const _FollowButton({required this.mode, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isActive = mode != FollowMode.none;
    final icon = _iconForMode();

    return Material(
      color: AppColors.surface.withValues(alpha: 0.9),
      borderRadius: BorderRadius.circular(12),
      elevation: isActive ? 2 : 0,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.primary.withValues(alpha: 0.15)
                : AppColors.surface.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 8,
              ),
            ],
          ),
          child: Icon(
            icon,
            color: isActive ? AppColors.primary : AppColors.textPrimary,
            size: 22,
          ),
        ),
      ),
    );
  }

  IconData _iconForMode() {
    switch (mode) {
      case FollowMode.none:
        return Icons.my_location_outlined;
      case FollowMode.gps:
        return Icons.my_location;
      case FollowMode.follow:
        return Icons.explore;
      case FollowMode.compass:
        return Icons.explore;
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Compass button — rotates with map bearing, tap to reset to north
// ─────────────────────────────────────────────────────────────────────────────

class _CompassButton extends StatelessWidget {
  final double bearing;
  final VoidCallback onTap;

  const _CompassButton({required this.bearing, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface.withValues(alpha: 0.9),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 8,
              ),
            ],
          ),
          child: Transform.rotate(
            angle: bearing * (3.14159 / 180),
            child: const Icon(
              Icons.explore,
              color: AppColors.textPrimary,
              size: 22,
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Generic map control button (zoom, etc.)
// ─────────────────────────────────────────────────────────────────────────────

class _MapControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final BorderRadius? borderRadius;

  const _MapControlButton({
    required this.icon,
    required this.onTap,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: borderRadius ?? BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(icon, color: AppColors.textPrimary, size: 22),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Navigation HUD — shown at the bottom of the map while a route is active.
// Styled to match the Halo dark/neon theme with secondaryDark accent.
// ─────────────────────────────────────────────────────────────────────────────

class _NavigationHUD extends StatelessWidget {
  final double? distance;
  final double? duration;
  final Future<void> Function() onStart;
  final Future<void> Function() onClose;
  final bool isNavigating;

  const _NavigationHUD({
    required this.onClose,
    required this.onStart,
    this.distance,
    this.duration,
    this.isNavigating = false,
  });

  String _formatDistance(double? meters) {
    if (meters == null) return '—';
    if (meters >= 1000) {
      return '${(meters / 1000).toStringAsFixed(1)} km';
    }
    return '${meters.round()} m';
  }

  String _formatDuration(double? seconds) {
    if (seconds == null) return '—';
    final mins = (seconds / 60).round();
    if (mins < 60) return '$mins phút';
    final hours = mins ~/ 60;
    final rem = mins % 60;
    return rem == 0 ? '$hours giờ' : '$hours giờ $rem phút';
  }

  @override
  Widget build(BuildContext context) {
    return BackButtonListener(
      onBackButtonPressed: () async {
        await onClose();
        return true;
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surface.withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.secondaryDark.withValues(alpha: 0.6),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.secondaryDark.withValues(alpha: 0.25),
              blurRadius: 20,
              spreadRadius: 2,
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 12,
            ),
          ],
        ),
        child: Row(
          children: [
            // Route icon with secondaryDark accent
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.secondaryDark.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.secondaryDark.withValues(alpha: 0.4),
                ),
              ),
              child: const Icon(
                Icons.directions,
                color: AppColors.secondaryDark,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),

            // Distance & duration
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _formatDistance(distance),
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time_rounded,
                        size: 13,
                        color: AppColors.secondaryDark,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatDuration(duration),
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Start / Exit navigation button
            if (!isNavigating) ...[
              GestureDetector(
                onTap: onStart,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.navigation,
                    color: AppColors.primary,
                    size: 18,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: onClose,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.close,
                    color: AppColors.textSecondary,
                    size: 18,
                  ),
                ),
              ),
            ] else
              GestureDetector(
                onTap: onClose,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'Thoát',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
