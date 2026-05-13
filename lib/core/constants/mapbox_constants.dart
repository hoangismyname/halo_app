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
}
