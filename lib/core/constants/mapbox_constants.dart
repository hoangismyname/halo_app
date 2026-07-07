import 'env.dart';

/// Mapbox configuration - loads access token from shared Env singleton
class MapboxConstants {
  MapboxConstants._();

  static String get accessToken => Env.get('MAPBOX_API_KEY');

  // Light presets
  static const String dawnLightPreset = 'dawn';
  static const String dayLightPreset = 'day';
  static const String duskLightPreset = 'dusk';
  static const String nightLightPreset = 'night';

  // Camera options
  static const double cameraVerticalPadding = 100.0;
  static const double cameraHorizontalPadding = 50.0;
  static const double defaultBearing = 0.0;
  static const double defaultPitch = 0.0;

  // Navigation mode camera
  static const double navigationZoom = 18;
  static const double navigationPitch = 45.0;
  static const double navigationPaddingTop = 200.0;
}
