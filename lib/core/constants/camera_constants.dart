abstract class NavigationCameraConstants {
  // Camera perspective khi dẫn đường
  static const double navigationPitch = 60.0; // độ nghiêng 3D
  static const double navigationZoom = 17.5; // zoom gần, đủ thấy đường
  static const double overviewPitch = 0.0; // nhìn từ trên xuống
  static const double overviewZoom = 14.0; // zoom xa để thấy toàn tuyến

  // Animation timing
  static const int startNavDuration = 1500; // ms – flyTo khi bắt đầu
  static const int trackingDuration = 300; // ms – easeTo theo vị trí
  static const int recenterDuration = 800; // ms – khi nhấn nút recenter

  // Throttle: chỉ update camera khi user di chuyển đủ xa
  static const double minDistanceMeters = 2.0;
}
