import 'package:weather/weather.dart';

/// Represents the possible states of real-time weather tracking.
sealed class WeatherState {
  const WeatherState();
}

/// Initial state before any fetch is triggered.
class WeatherInitial extends WeatherState {
  const WeatherInitial();
}

/// In-flight fetch.
class WeatherLoading extends WeatherState {
  const WeatherLoading();
}

/// Successfully loaded weather data.
class WeatherLoaded extends WeatherState {
  const WeatherLoaded(this.weather);

  final Weather weather;
}

/// Fetch failed with an error message.
class WeatherError extends WeatherState {
  const WeatherError(this.message);

  final String message;
}
