import 'env.dart';

/// Mapbox configuration - loads access token from shared Env singleton
class MapboxConstants {
  MapboxConstants._();

  static String get accessToken => Env.get('MAPBOX_API_KEY');

  // Map style
  static const String darkStyleUrl = 'mapbox://styles/mapbox/dark-v11';
  static const String streetsStyleUrl = 'mapbox://styles/mapbox/streets-v12';
  static const String satelliteStyleUrl =
      'mapbox://styles/mapbox/satellite-streets-v12';

  // Camera options
  static const double cameraVerticalPadding = 100.0;
  static const double cameraHorizontalPadding = 50.0;
  static const double defaultBearing = 0.0;
  static const double defaultPitch = 0.0;
}
