import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather/weather.dart';

/// Provides a singleton [WeatherFactory] configured with the API key.
final weatherFactoryProvider = Provider<WeatherFactory>((ref) {
  const apiKey = String.fromEnvironment(
    'OPEN_WEATHER_API_KEY',
    defaultValue: 'bd127628cec8764d8d5cc6eebe3dd1a6',
  );
  return WeatherFactory(apiKey, language: Language.VIETNAMESE);
});

/// Repository that fetches current weather by coordinates.
class WeatherRepository {
  WeatherRepository(this._factory);

  final WeatherFactory _factory;

  /// Fetches current weather at the given [latitude] and [longitude].
  Future<Weather> fetchCurrentWeather({
    required double latitude,
    required double longitude,
  }) =>
      _factory.currentWeatherByLocation(latitude, longitude);
}

final weatherRepositoryProvider = Provider<WeatherRepository>(
  (ref) => WeatherRepository(ref.watch(weatherFactoryProvider)),
);
