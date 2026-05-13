import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart'
    hide Position, LocationSettings;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as geo;
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/location_repository.dart';
import '../providers/location_provider.dart';
import '../../../friends/presentation/providers/friends_provider.dart';
import '../../../auth/domain/user_model.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/mapbox_constants.dart';
import '../../widgets/friend_bottom_sheet.dart';
import '../../widgets/map_controls.dart';
import '../../../weather/presentation/widgets/weather_overlay.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  MapboxMap? _mapboxMap;
  PointAnnotationManager? _annotationManager;
  PointAnnotation? _myLocationAnnotation;
  geo.Point? _myLocationPoint;
  Uint8List? _myLocationIconBytes;
  final Map<String, Uint8List> _friendIconBytes = {};
  final Map<String, PointAnnotation> _friendAnnotations = {};
  double _currentZoom = 13;
  StreamSubscription<geolocator.Position>? _positionStream;
  Cancelable? _tapCancelable;

  geo.Point _defaultCenter() =>
      geo.Point(coordinates: geo.Position(106.6297, 10.8231));

  @override
  void initState() {
    super.initState();
    // Defer location setup to avoid blocking the build phase with permission
    // requests. This prevents the app from hanging/crashing on first launch.
    Future.microtask(() => _initLocation());
  }

  Future<void> _initLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final lat = prefs.getDouble('last_lat');
    final lng = prefs.getDouble('last_lng');

    if (lat != null && lng != null && mounted) {
      setState(() {
        _myLocationPoint = geo.Point(coordinates: geo.Position(lng, lat));
      });
    }

    if (!kIsWeb) {
      try {
        ref.read(locationSharingProvider.notifier).start();

        final repo = ref.read(locationRepositoryProvider);
        final hasPerm = await repo.checkPermissions();

        if (hasPerm) {
          if (lat == null) {
            final lastKnown =
                await geolocator.Geolocator.getLastKnownPosition();
            if (lastKnown != null && mounted) {
              setState(() {
                _myLocationPoint = geo.Point(
                  coordinates: geo.Position(
                    lastKnown.longitude,
                    lastKnown.latitude,
                  ),
                );
              });
              if (_mapboxMap != null) _flyToMyLocation();
            }
          }

          _positionStream =
              geolocator.Geolocator.getPositionStream(
                locationSettings: const geolocator.LocationSettings(
                  accuracy: geolocator.LocationAccuracy.high,
                  distanceFilter: 10,
                ),
              ).listen((pos) {
                if (mounted) {
                  setState(() {
                    _myLocationPoint = geo.Point(
                      coordinates: geo.Position(pos.longitude, pos.latitude),
                    );
                  });
                  prefs.setDouble('last_lat', pos.latitude);
                  prefs.setDouble('last_lng', pos.longitude);
                  _updateMyLocationAnnotation();
                }
              });
        }
      } catch (e) {
        debugPrint('Location init failed: $e');
      }
    }
  }

  void _flyToMyLocation() {
    if (_mapboxMap == null) return;
    final target = _myLocationPoint ?? _defaultCenter();
    _mapboxMap!.flyTo(
      CameraOptions(center: target, zoom: 15),
      MapAnimationOptions(duration: 1000),
    );
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
    _positionStream?.cancel();
    _tapCancelable?.cancel();
    super.dispose();
  }

  UserModel? _findFriend(String userId, List<UserModel> friendsList) {
    try {
      return friendsList.firstWhere((f) => f.id == userId);
    } catch (_) {
      return null;
    }
  }

  Future<Uint8List> _createMyLocationIconBytes() async {
    const size = 96;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final center = Offset(size / 2, size / 2);
    final radius = size / 2 - 8;

    canvas.drawCircle(
      center,
      radius + 10,
      Paint()
        ..color = AppColors.mapMarkerSelf.withValues(alpha: 0.3)
        ..style = PaintingStyle.fill,
    );

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = AppColors.mapMarkerSelf
        ..style = PaintingStyle.fill,
    );

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4,
    );

    final iconPainter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(Icons.person.codePoint),
        style: const TextStyle(
          fontFamily: 'MaterialIcons',
          fontSize: 32,
          color: Colors.white,
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

    final picture = recorder.endRecording();
    final image = await picture.toImage(size, size);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  Future<Uint8List> _createFriendIconBytes(UserModel? friend) async {
    const size = 112;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final center = Offset(size / 2, size / 2);
    final radius = size / 2 - 8;

    canvas.drawCircle(
      center,
      radius + 8,
      Paint()
        ..color = AppColors.primary.withValues(alpha: 0.3)
        ..style = PaintingStyle.fill,
    );

    canvas.drawCircle(
      center,
      radius + 4,
      Paint()
        ..color = AppColors.primary
        ..style = PaintingStyle.fill,
    );

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = AppColors.surface
        ..style = PaintingStyle.fill,
    );

    canvas.save();
    canvas.clipPath(
      Path()..addOval(Rect.fromCircle(center: center, radius: radius)),
    );

    final imageUrl = friend?.avatarUrl;
    bool drewImage = false;
    if (imageUrl != null && imageUrl.isNotEmpty) {
      try {
        final imageProvider = NetworkImage(imageUrl);
        final completer = Completer<ImageInfo>();
        imageProvider
            .resolve(ImageConfiguration.empty)
            .addListener(
              ImageStreamListener((info, _) {
                if (!completer.isCompleted) completer.complete(info);
              }),
            );
        final imageInfo = await completer.future.timeout(
          const Duration(seconds: 2),
          onTimeout: () => throw TimeoutException('Image load timeout'),
        );

        canvas.drawImageRect(
          imageInfo.image,
          Rect.fromLTWH(
            0,
            0,
            imageInfo.image.width.toDouble(),
            imageInfo.image.height.toDouble(),
          ),
          Rect.fromCircle(center: center, radius: radius),
          Paint(),
        );
        drewImage = true;
      } catch (_) {
        // Fallback to initial
      }
    }

    if (!drewImage) {
      final initial =
          (friend?.displayName.isNotEmpty == true
                  ? friend!.displayName
                  : friend?.username ?? '?')
              .substring(0, 1)
              .toUpperCase();

      final textPainter = TextPainter(
        text: TextSpan(
          text: initial,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          center.dx - textPainter.width / 2,
          center.dy - textPainter.height / 2,
        ),
      );
    }

    canvas.restore();

    if (friend?.isOnline ?? false) {
      final indicatorPos = Offset(
        center.dx + radius - 2,
        center.dy - radius + 2,
      );
      canvas.drawCircle(
        indicatorPos,
        7,
        Paint()
          ..color = AppColors.online
          ..style = PaintingStyle.fill,
      );
      canvas.drawCircle(
        indicatorPos,
        7,
        Paint()
          ..color = AppColors.surface
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
    }

    final picture = recorder.endRecording();
    final image = await picture.toImage(size, size);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  Future<void> _onMapCreated(MapboxMap mapboxMap) async {
    _mapboxMap = mapboxMap;
    _annotationManager = await mapboxMap.annotations
        .createPointAnnotationManager();

    // Set up tap listener for friend annotations
    _tapCancelable = _annotationManager!.tapEvents(onTap: _onAnnotationTap);

    // Create my location icon and annotation
    if (!kIsWeb) {
      _myLocationIconBytes ??= await _createMyLocationIconBytes();
      if (_myLocationPoint != null) {
        _myLocationAnnotation = await _annotationManager!.create(
          PointAnnotationOptions(
            geometry: _myLocationPoint!,
            image: _myLocationIconBytes,
            iconSize: 1.0,
            iconAnchor: IconAnchor.CENTER,
          ),
        );
      }
    }
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
    if (_myLocationPoint == null || _annotationManager == null) {
      return;
    }

    _myLocationIconBytes ??= await _createMyLocationIconBytes();

    if (_myLocationAnnotation != null) {
      _myLocationAnnotation!.geometry = _myLocationPoint!;
      await _annotationManager!.update(_myLocationAnnotation!);
    } else {
      _myLocationAnnotation = await _annotationManager!.create(
        PointAnnotationOptions(
          geometry: _myLocationPoint!,
          image: _myLocationIconBytes,
          iconSize: 1.0,
          iconAnchor: IconAnchor.CENTER,
        ),
      );
    }
  }

  Future<void> _reloadFriendAnnotations() async {
    if (_annotationManager == null) return;

    final friendLocations = ref.read(friendLocationsProvider);
    final friendsAsync = ref.read(friendsListProvider);
    final friendsList = friendsAsync.value ?? [];

    // Delete existing friend annotations
    final existing = await _annotationManager!.getAnnotations();
    for (final annotation in existing) {
      final textField = annotation.textField;
      if (textField != null && textField.startsWith('friend_')) {
        await _annotationManager!.delete(annotation);
      }
    }
    _friendAnnotations.clear();

    // Create new friend annotations
    final optionsList = <PointAnnotationOptions>[];
    final userIds = <String>[];

    for (final entry in friendLocations.entries) {
      final userId = entry.key;
      final data = entry.value;
      final lat = data['latitude'] as double?;
      final lng = data['longitude'] as double?;
      if (lat != null && lng != null) {
        final friend = _findFriend(userId, friendsList);
        final iconBytes =
            _friendIconBytes[userId] ?? await _createFriendIconBytes(friend);
        _friendIconBytes[userId] = iconBytes;

        optionsList.add(
          PointAnnotationOptions(
            geometry: geo.Point(coordinates: geo.Position(lng, lat)),
            image: iconBytes,
            textField: 'friend_$userId',
            iconSize: 1.0,
            iconAnchor: IconAnchor.CENTER,
          ),
        );
        userIds.add(userId);
      }
    }

    if (optionsList.isNotEmpty) {
      final annotations = await _annotationManager!.createMulti(optionsList);
      for (int i = 0; i < userIds.length; i++) {
        if (i < annotations.length && annotations[i] != null) {
          _friendAnnotations[userIds[i]] = annotations[i]!;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSharing = ref.watch(locationSharingProvider);

    ref.listen<Map<String, Map<String, dynamic>>>(friendLocationsProvider, (
      previous,
      next,
    ) {
      if (previous != next) {
        _reloadFriendAnnotations();
      }
    });

    return Scaffold(
      body: Stack(
        children: [
          MapWidget(
            key: const ValueKey('halo_map'),
            onMapCreated: _onMapCreated,
            styleUri: MapboxConstants.darkStyleUrl,
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

                if (!kIsWeb)
                  GestureDetector(
                    onTap: () =>
                        ref.read(locationSharingProvider.notifier).toggle(),
                    child: Container(
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
                  ),
              ],
            ),
          ),

          // Weather chip — top-right below the top bar
          Positioned(
            right: AppSizes.md,
            top: MediaQuery.paddingOf(context).top + 60,
            child: const WeatherOverlay(),
          ),

          Positioned(
            right: AppSizes.md,
            bottom: AppSizes.xxl + 80,
            child: MapControls(
              onMyLocation: _flyToMyLocation,
              onZoomIn: _zoomIn,
              onZoomOut: _zoomOut,
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
