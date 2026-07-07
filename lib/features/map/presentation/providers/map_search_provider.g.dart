// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_search_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MapSearch)
final mapSearchProvider = MapSearchProvider._();

final class MapSearchProvider
    extends $AsyncNotifierProvider<MapSearch, List<MapSearchResult>> {
  MapSearchProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mapSearchProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mapSearchHash();

  @$internal
  @override
  MapSearch create() => MapSearch();
}

String _$mapSearchHash() => r'da4e3a9dab182cea63f2b33ed896f4cbfeac659e';

abstract class _$MapSearch extends $AsyncNotifier<List<MapSearchResult>> {
  FutureOr<List<MapSearchResult>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<List<MapSearchResult>>, List<MapSearchResult>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<MapSearchResult>>,
                List<MapSearchResult>
              >,
              AsyncValue<List<MapSearchResult>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
