import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app.dart';
import 'core/constants/mapbox_constants.dart';
import 'core/constants/supabase_constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Mapbox access token
  MapboxOptions.setAccessToken(MapboxConstants.accessToken);

  // Initialize Supabase safely
  try {
    await Supabase.initialize(
      url: SupabaseConstants.url,
      anonKey: SupabaseConstants.anonKey,
    );
  } catch (e) {
    debugPrint('Supabase init failed. Running in guest/local mode. Error: $e');
  }

  runApp(const ProviderScope(child: HaloApp()));
}
