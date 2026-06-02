import 'package:freezed_annotation/freezed_annotation.dart';

part 'map_search_result.freezed.dart';
part 'map_search_result.g.dart';

@freezed
abstract class MapSearchResult with _$MapSearchResult {
  const factory MapSearchResult({
    @JsonKey(name: 'place_id') required String placeId,
    required String formatted,
    @JsonKey(name: 'address_line1') String? addressLine1,
    @JsonKey(name: 'address_line2') String? addressLine2,
    required double lat,
    required double lon,
  }) = _MapSearchResult;

  factory MapSearchResult.fromJson(Map<String, dynamic> json) =>
      _$MapSearchResultFromJson(json);
}
