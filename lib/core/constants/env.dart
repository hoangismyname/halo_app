import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Shared env accessor. Load via [loadEnv] once in main(), then use everywhere.
class Env {
  Env._();

  static String get(String key, {String fallback = ''}) =>
      dotenv.get(key, fallback: fallback);

  static bool has(String key) =>
      dotenv.isInitialized && dotenv.get(key, fallback: '') != '';
}

/// Must be called once in main() before any code reads env values.
Future<void> loadEnv() async {
  await dotenv.load(fileName: '.env');
}
