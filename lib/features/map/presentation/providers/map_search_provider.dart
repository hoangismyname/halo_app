import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/constants/env.dart';
import '../../domain/map_search_result.dart';

part 'map_search_provider.g.dart';

@riverpod
class MapSearch extends _$MapSearch {
  final _dio = Dio();
  Timer? _debounceTimer;

  @override
  FutureOr<List<MapSearchResult>> build() {
    ref.onDispose(() {
      _debounceTimer?.cancel();
    });
    return [];
  }

  void search(String query) {
    if (query.isEmpty) {
      _debounceTimer?.cancel();
      state = const AsyncData([]);
      return;
    }

    // Set loading state
    state = const AsyncLoading();

    // Cancel previous timer
    _debounceTimer?.cancel();

    // Start a new timer for 500ms debounce
    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      try {
        final results = await _fetchResults(query);
        state = AsyncData(results);
      } catch (e, st) {
        debugPrint('MapSearch error: $e');
        state = AsyncError(e, st);
      }
    });
  }

  void clear() {
    _debounceTimer?.cancel();
    state = const AsyncData([]);
  }

  Future<List<MapSearchResult>> _fetchResults(String query) async {
    final apiKey = Env.get('GEOAPIFY_API_KEY');
    if (apiKey.isEmpty) {
      throw Exception('Geoapify API key is missing');
    }

    final url = 'https://api.geoapify.com/v1/geocode/autocomplete';
    final response = await _dio.get(
      url,
      queryParameters: {
        'text': query,
        'format': 'json',
        'limit': 10,
        'apiKey': apiKey,
      },
    );

    if (response.statusCode == 200) {
      final data = response.data as Map<String, dynamic>;
      final results = data['results'] as List?;
      if (results != null) {
        return results
            .map((json) => MapSearchResult.fromJson(json as Map<String, dynamic>))
            .toList();
      }
    } else {
      throw Exception('Failed to fetch autocomplete suggestions');
    }
    return [];
  }
}
