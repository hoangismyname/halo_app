// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_search_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MapSearchResult _$MapSearchResultFromJson(Map<String, dynamic> json) =>
    _MapSearchResult(
      placeId: json['place_id'] as String,
      formatted: json['formatted'] as String,
      addressLine1: json['address_line1'] as String?,
      addressLine2: json['address_line2'] as String?,
      lat: (json['lat'] as num).toDouble(),
      lon: (json['lon'] as num).toDouble(),
    );

Map<String, dynamic> _$MapSearchResultToJson(_MapSearchResult instance) =>
    <String, dynamic>{
      'place_id': instance.placeId,
      'formatted': instance.formatted,
      'address_line1': instance.addressLine1,
      'address_line2': instance.addressLine2,
      'lat': instance.lat,
      'lon': instance.lon,
    };
