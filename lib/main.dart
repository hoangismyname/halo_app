import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app.dart';
import 'core/constants/mapbox_constants.dart';
import 'core/constants/supabase_constants.dart';
import 'core/constants/env.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load .env from Flutter assets (works on mobile, desktop, web)
  await loadEnv();

  // Initialize Mapbox access token
  MapboxOptions.setAccessToken(MapboxConstants.accessToken);
  log('Mapbox token length: ${MapboxConstants.accessToken.length}');

  // Initialize Supabase safely
  try {
    final supabaseUrl = SupabaseConstants.url;
    final supabaseKey = SupabaseConstants.anonKey;

    if (supabaseUrl.isEmpty || supabaseKey.isEmpty) {
      debugPrint(
        'Supabase credentials not found in .env. Running in guest/local mode.',
      );
    } else {
      await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);
      log('Supabase URL: $supabaseUrl');
    }
  } catch (e) {
    debugPrint('Supabase init failed. Running in guest/local mode. Error: $e');
  }

  runApp(const ProviderScope(child: HaloApp()));
}
