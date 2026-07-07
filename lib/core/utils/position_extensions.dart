// extensions/position_extensions.dart
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

extension PositionListX on List<Position> {
  List<Point> toMapPoints() =>
      map((position) => Point(coordinates: position)).toList();
}
