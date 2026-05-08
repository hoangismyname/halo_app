# HALO APP - NAVIGATION & WEATHER FEATURES IMPLEMENTATION PLAN

Kế hoạch triển khai 2 tính năng mới: **Dẫn đường (OpenRouteService)** và **Thời tiết thực (OpenWeatherMap One Call 3.0)**.

---

## PHẦN 1: ĐÁNH GIÁ KIẾN TRÚC HIỆN TẠI

### 1.1 Implementation Plan (`docs/implementation_plan.md`)

**Ưu điểm:**
- ✅ Phân chia **Feature-First** rõ ràng: auth, map, friends, chat, profile, status
- ✅ Có 3 tầng cơ bản: `data/`, `domain/`, `presentation/`
- ✅ Sử dụng Riverpod v3 + GoRouter + Supabase - stack hiện đại
- ✅ Realtime strategy được thiết kế tốt (Broadcast vs Database Stream)

**Hạn chế so với Clean Architecture:**
- ❌ **Thiếu Abstract Interfaces** - Repositories là concrete class, coupling cao với Supabase
- ❌ **Thiếu Use Cases** - Business logic nằm trực tiếp trong Repository và Riverpod Provider
- ❌ **Domain layer quá mỏng** - Chỉ chứa Model (Freezed), không có nghiệp vụ thuần
- ❌ **Không có Error/Failure types** - Xử lý lỗi bằng try-catch trực tiếp trong UI

### 1.2 Optimized Architecture Plan (`docs/optimized_architecture_plan.md`)

**Đánh giá:**
- ✅ Nhận diện **đúng vấn đề**: vi phạm Dependency Inversion, thiếu Use Cases
- ✅ Đề xuất **đúng giải pháp**: tách Interface, UseCase, Data Source, RepositoryImpl
- ✅ Khuyên **chờ đến Phase 3** khi app lớn - hiện tại đủ tốt cho MVP
- ⚠️ **Chưa được triển khai** - vẫn là tài liệu kế hoạch

### 1.3 Kết luận

| Tiêu chí | Đánh giá |
|----------|----------|
| Feature-First Organization | ✅ Tốt |
| Layer Separation | ✅ Cơ bản đạt |
| Dependency Inversion | ❌ Chưa đạt |
| Use Cases / Interactors | ❌ Chưa có |
| Error Handling Pattern | ⚠️ Cần cải thiện |
| Phù hợp cho MVP | ✅ Đạt |
| Clean Architecture 100% | ❌ Chưa đạt |

**Khuyến nghị**: Giữ nguyên cấu trúc hiện tại cho MVP. Áp dụng Clean Architecture đầy đủ khi mở rộng tính năng (Navigation, Weather, Voice call...).

---

## PHẦN 2: NAVIGATION FEATURE (OPENROUTESERVICE)

### 2.1 Tổng quan

Cho phép người dùng xem chỉ đường từ vị trí hiện tại đến bạn bè trên bản đồ, bao gồm:
- **Driving directions** (ôtô)
- **Walking directions** (đi bộ)
- **Cycling directions** (xe đạp)
- **Estimated time of arrival (ETA)**
- **Turn-by-turn instructions**
- **Route polyline** hiển thị trên bản đồ

### 2.2 API: OpenRouteService Directions

**Base URL**: `https://api.openrouteservice.org/v2`

**Authentication**: API Key qua header `Authorization: {API_KEY}`

**Endpoint chính**:
```
POST /v2/directions/{profile}/{format}
Content-Type: application/json
Authorization: {API_KEY}

{
  "coordinates": [
    [start_lon, start_lat],
    [end_lon, end_lat]
  ],
  "profile": "driving-car|foot-walking|cycling-regular",
  "format": "geojson|json",
  "extra_info": ["steepness","suitability","surface"],
  "language": "vi"
}
```

**Response structure** (JSON format):
```json
{
  "type": "FeatureCollection",
  "features": [{
    "type": "Feature",
    "properties": {
      "segments": [{
        "steps": [
          {
            "instruction": "Rẽ trái vào Nguyễn Huệ",
            "distance": 150.5,
            "duration": 45.2,
            "type": 1,
            "modifier": -1
          }
        ],
        "distance": 2500.0,
        "duration": 420.0
      }],
      "summary": {
        "distance": 2500.0,
        "duration": 420.0
      }
    },
    "geometry": {
      "coordinates": [[lon1, lat1], [lon2, lat2], ...],
      "type": "LineString"
    }
  }],
  "metadata": {
    "query": { "coordinates": [...] },
    "engine": { "version": "7.1.0", "build_date": "2024-01-01" }
  }
}
```

**Free tier limits**: 2,000 requests/day, 40 req/min

### 2.3 Architecture Design

```
lib/features/navigation/
├── domain/
│   ├── entities/
│   │   ├── route_entity.dart          # RouteEntity (distance, duration, polyline, steps)
│   │   └── navigation_step.dart       # NavigationStep (instruction, distance, duration)
│   ├── repositories/
│   │   └── navigation_repository.dart # Abstract interface
│   └── usecases/
│       ├── get_route_usecase.dart     # GetRouteUseCase(start, end, profile)
│       └── get_eta_usecase.dart       # GetETAUseCase(start, end, profile)
│
├── data/
│   ├── models/
│   │   ├── route_model.dart           # extends RouteEntity, fromJson/toJson
│   │   └── navigation_step_model.dart # extends NavigationStep
│   ├── datasources/
│   │   └── navigation_remote_datasource.dart  # HTTP calls to OpenRouteService
│   └── repositories/
│       └── navigation_repository_impl.dart    # implements NavigationRepository
│
└── presentation/
    ├── providers/
    │   ├── navigation_providers.dart   # Riverpod providers for navigation state
    │   └── route_profile_provider.dart # Selected transport mode
    ├── screens/
    │   └── navigation_screen.dart      # Full-screen navigation UI
    └── widgets/
        ├── route_overlay.dart          # Route info overlay (ETA, distance)
        ├── turn_by_turn_panel.dart     # Turn-by-turn instructions panel
        └── profile_selector.dart       # Transport mode selector
```

### 2.4 Dependencies cần thêm

```yaml
dependencies:
  http: ^1.2.x                    # HTTP client cho API calls
  flutter_map_routing: ^1.0.x     # Routing layer cho flutter_map (optional)
  polyline: ^2.0.x                # Encode/decode polyline
```

---

## PHẦN 3: WEATHER FEATURE (OPENWEATHERMAP ONE CALL 3.0)

### 3.1 Tổng quan

Hiển thị thông tin thời tiết theo vị trí người dùng theo thời gian thực:
- **Current weather**: Nhiệt độ, độ ẩm, gió, áp suất, mô tả thời tiết
- **Hourly forecast**: Dự báo 48h tới
- **Daily forecast**: Dự báo 8 ngày
- **Weather alerts**: Cảnh báo thời tiết quốc gia
- **Minutely forecast**: Dự báo mưa 60 phút

### 3.2 API: OpenWeatherMap One Call 3.0

**Base URL**: `https://api.openweathermap.org/data/3.0/onecall`

**Authentication**: API Key qua query parameter `appid={API_KEY}`

**Endpoint chính**:
```
GET /data/3.0/onecall?lat={lat}&lon={lon}&exclude={exclude}&units={units}&lang={lang}&appid={API_KEY}
```

**Parameters**:
| Parameter | Required | Description |
|-----------|----------|-------------|
| `lat` | ✅ | Latitude (-90 to 90) |
| `lon` | ✅ | Longitude (-180 to 180) |
| `appid` | ✅ | API key |
| `exclude` | ❌ | Comma-separated: minutely,hourly,daily,alerts |
| `units` | ❌ | `standard`, `metric`, `imperial` (default: standard) |
| `lang` | ❌ | Language code (vi = Vietnamese) |

**Response structure**:
```json
{
  "lat": 10.7769,
  "lon": 106.7009,
  "timezone": "Asia/Ho_Chi_Minh",
  "timezone_offset": 25200,
  "current": {
    "dt": 1715000000,
    "sunrise": 1714953600,
    "sunset": 1715000400,
    "temp": 32.5,
    "feels_like": 36.2,
    "humidity": 75,
    "dew_point": 27.1,
    "uvi": 8.5,
    "clouds": 40,
    "visibility": 10000,
    "wind_speed": 3.6,
    "wind_deg": 180,
    "weather": [{
      "id": 802,
      "main": "Clouds",
      "description": "mây scattered",
      "icon": "03d"
    }]
  },
  "minutely": [{ "dt": 1715000000, "precipitation": 0 }],
  "hourly": [{
    "dt": 1715000400,
    "temp": 31.8,
    "feels_like": 35.4,
    "weather": [{ "id": 801, "main": "Clouds", "icon": "02d" }],
    "pop": 0.15
  }],
  "daily": [{
    "dt": 1715000400,
    "sunrise": 1714953600,
    "sunset": 1715000400,
    "temp": { "min": 26.5, "max": 33.2 },
    "weather": [{ "id": 500, "main": "Rain", "icon": "10d" }],
    "pop": 0.65
  }],
  "alerts": [{
    "sender_name": "VN NCHMF",
    "event": "Mưa lớn",
    "start": 1715000000,
    "end": 1715100000,
    "description": "Cảnh báo mưa lớn..."
  }]
}
```

**Free tier limits**: 1,000 calls/day

### 3.3 Architecture Design

```
lib/features/weather/
├── domain/
│   ├── entities/
│   │   ├── weather_entity.dart          # WeatherEntity (current, hourly, daily)
│   │   ├── weather_current_entity.dart  # Current weather data
│   │   ├── weather_hourly_entity.dart   # Hourly forecast
│   │   ├── weather_daily_entity.dart    # Daily forecast
│   │   └── weather_alert_entity.dart    # Weather alerts
│   ├── repositories/
│   │   └── weather_repository.dart      # Abstract interface
│   └── usecases/
│       ├── get_current_weather_usecase.dart
│       └── get_weather_forecast_usecase.dart
│
├── data/
│   ├── models/
│   │   ├── weather_model.dart           # extends WeatherEntity
│   │   ├── weather_current_model.dart
│   │   ├── weather_hourly_model.dart
│   │   ├── weather_daily_model.dart
│   │   └── weather_alert_model.dart
│   ├── datasources/
│   │   └── weather_remote_datasource.dart  # HTTP calls to OpenWeatherMap
│   └── repositories/
│       └── weather_repository_impl.dart    # implements WeatherRepository
│
└── presentation/
    ├── providers/
    │   ├── weather_providers.dart       # Riverpod providers
    │   └── weather_settings_provider.dart # Units, language settings
    ├── screens/
    │   └── weather_screen.dart          # Full-screen weather UI
    └── widgets/
        ├── current_weather_card.dart    # Current weather display
        ├── hourly_forecast_list.dart    # Horizontal hourly list
        ├── daily_forecast_list.dart     # Daily forecast list
        └── weather_alert_banner.dart    # Alert banner widget
```

### 3.4 Integration với Map Feature

Weather widget sẽ được tích hợp vào Map Screen:
- Hiển thị **weather icon** trên marker của bạn bè
- Tap marker → hiện **weather card** của vị trí bạn bè
- Nút toggle để bật/tắt weather overlay trên bản đồ

```
lib/features/map/
└── widgets/
    ├── weather_marker.dart            # Weather icon trên friend marker
    └── weather_bottom_sheet.dart      # Weather info trong bottom sheet
```

---

## PHẦN 4: TASK BREAKDOWN & THỨ TỰ TRIỂN KHAI

### Phase 1: Infrastructure Setup (1-2 days)

| # | Task | Files | Priority |
|---|------|-------|----------|
| 1.1 | Thêm dependencies mới vào `pubspec.yaml` | `pubspec.yaml` | P0 |
| 1.2 | Tạo `lib/core/constants/api_constants.dart` | `api_constants.dart` | P0 |
| 1.3 | Tạo `lib/core/network/http_client.dart` (base HTTP client) | `http_client.dart` | P0 |
| 1.4 | Thêm placeholder API keys vào `.env` hoặc constants | `.env` | P0 |
| 1.5 | Chạy `flutter pub get` + `build_runner` | terminal | P0 |

### Phase 2: Weather Feature Implementation (3-4 days)

| # | Task | Files | Priority |
|---|------|-------|----------|
| 2.1 | Tạo `lib/features/weather/domain/entities/` | 5 entity files | P0 |
| 2.2 | Tạo `lib/features/weather/domain/repositories/weather_repository.dart` | Interface | P0 |
| 2.3 | Tạo `lib/features/weather/domain/usecases/` | 2 usecase files | P0 |
| 2.4 | Tạo `lib/features/weather/data/models/` | 5 model files (Freezed) | P0 |
| 2.5 | Tạo `lib/features/weather/data/datasources/weather_remote_datasource.dart` | HTTP client | P0 |
| 2.6 | Tạo `lib/features/weather/data/repositories/weather_repository_impl.dart` | Implementation | P0 |
| 2.7 | Tạo `lib/features/weather/presentation/providers/weather_providers.dart` | Riverpod | P0 |
| 2.8 | Tạo `lib/features/weather/presentation/screens/weather_screen.dart` | UI | P1 |
| 2.9 | Tạo `lib/features/weather/presentation/widgets/` | 4 widget files | P1 |
| 2.10 | Viết tests cho Weather usecases và repository | `test/features/weather/` | P2 |

### Phase 3: Navigation Feature Implementation (3-4 days)

| # | Task | Files | Priority |
|---|------|-------|----------|
| 3.1 | Tạo `lib/features/navigation/domain/entities/` | 2 entity files | P0 |
| 3.2 | Tạo `lib/features/navigation/domain/repositories/navigation_repository.dart` | Interface | P0 |
| 3.3 | Tạo `lib/features/navigation/domain/usecases/` | 2 usecase files | P0 |
| 3.4 | Tạo `lib/features/navigation/data/models/` | 2 model files (Freezed) | P0 |
| 3.5 | Tạo `lib/features/navigation/data/datasources/navigation_remote_datasource.dart` | HTTP client | P0 |
| 3.6 | Tạo `lib/features/navigation/data/repositories/navigation_repository_impl.dart` | Implementation | P0 |
| 3.7 | Tạo `lib/features/navigation/presentation/providers/navigation_providers.dart` | Riverpod | P0 |
| 3.8 | Tạo `lib/features/navigation/presentation/screens/navigation_screen.dart` | UI | P1 |
| 3.9 | Tạo `lib/features/navigation/presentation/widgets/` | 3 widget files | P1 |
| 3.10 | Viết tests cho Navigation usecases và repository | `test/features/navigation/` | P2 |

### Phase 4: Integration & Polish (2-3 days)

| # | Task | Files | Priority |
|---|------|-------|----------|
| 4.1 | Tích hợp Weather widget vào Map Screen | `map_screen.dart`, `weather_marker.dart` | P0 |
| 4.2 | Tích hợp Navigation vào Friend Bottom Sheet | `friend_bottom_sheet.dart` | P0 |
| 4.3 | Cập nhật GoRouter với routes mới | `app_router.dart` | P0 |
| 4.4 | Thêm Settings toggles cho Weather/Navigation | `profile_screen.dart` | P1 |
| 4.5 | Chạy `flutter analyze` + fix errors | terminal | P0 |
| 4.6 | Test manual flow hoàn chỉnh | emulator/device | P0 |

---

## PHẦN 5: API KEY CONFIGURATION

### 5.1 OpenRouteService API Key

1. Đăng ký tại: https://openrouteservice.org/dev/#/signup
2. Lấy API key từ dashboard
3. Thêm vào `lib/core/constants/api_constants.dart`:

```dart
class ApiConstants {
  // OpenRouteService
  static const String openRouteServiceApiKey = 'YOUR_ORS_API_KEY';
  static const String openRouteServiceBaseUrl = 'https://api.openrouteservice.org/v2';

  // OpenWeatherMap
  static const String openWeatherMapApiKey = 'YOUR_OWM_API_KEY';
  static const String openWeatherMapBaseUrl = 'https://api.openweathermap.org/data/3.0';
}
```

### 5.2 Security Note

⚠️ **Không commit API keys lên git**. Sử dụng:
- `.env` file + `flutter_dotenv` package, HOẶC
- `--dart-define` flag khi build: `flutter run --dart-define=ORS_API_KEY=xxx --dart-define=OWM_API_KEY=yyy`

---

## PHẦN 6: VERIFICATION PLAN

### 6.1 Automated Tests

```bash
# Build project
flutter build apk --debug

# Run code generation
dart run build_runner build --delete-conflicting-outputs

# Analyze code
flutter analyze

# Run tests
flutter test
```

### 6.2 Manual Verification Checklist

- [ ] Chạy app, đăng nhập guest mode
- [ ] Mở Map Screen, tap vào bạn bè
- [ ] Tap "Chỉ đường" → mở Navigation Screen
- [ ] Chọn phương tiện (Ô tô/Đi bộ/Xe đạp)
- [ ] Kiểm tra route polyline hiển thị trên bản đồ
- [ ] Kiểm tra ETA và turn-by-turn instructions
- [ ] Mở Weather Screen từ Map hoặc Profile
- [ ] Kiểm tra current weather, hourly, daily forecast
- [ ] Kiểm tra weather alert banner (nếu có cảnh báo)
- [ ] Kiểm tra weather icon trên friend marker

---

## PHẦN 7: CLEAN ARCHITECTURE ADOPTION CHO 2 TÍNH NĂNG MỚI

### 7.1 Khuyến nghị

Áp dụng **Clean Architecture đầy đủ** cho 2 tính năng mới này để:
- Làm mẫu (blueprint) cho các tính năng tương lai
- Demonstrate đúng Dependency Inversion
- Dễ dàng thay thế API provider sau này

### 7.2 Blueprint áp dụng cho Navigation & Weather

```
lib/features/<feature>/
├── domain/                    # ✅ Pure Dart, không phụ thuộc framework
│   ├── entities/              #    Entity classes (Freezed nhưng KHÔNG json_serializable)
│   ├── repositories/          #    Abstract interfaces
│   └── usecases/              #    Single-responsibility interactors
│       └── *_usecase.dart     #    Trả về Either<Failure, Success> (dartz/fpdart)
│
├── data/                      # ✅ Triển khai chi tiết
│   ├── models/                #    Extends entities, CÓ json_serializable
│   ├── datasources/           #    Remote/Local data sources
│   └── repositories_impl/     #    Implements domain interfaces
│
└── presentation/              # ✅ UI & State management
    ├── providers/             #    Riverpod providers (gọi UseCases)
    ├── screens/               #    Full-screen widgets
    └── widgets/               #    Reusable sub-widgets
```

### 7.3 Dependencies bổ sung cho Clean Architecture

```yaml
dependencies:
  fpdart: ^1.1.x              # Either<Failure, Success> type
  # hoặc dartz: ^0.10.x
```

---

## Open Questions

> [!IMPORTANT]
> 1. **API Keys**: Bạn đã có API key cho OpenRouteService và OpenWeatherMap chưa? Hay cần hướng dẫn đăng ký?
> 2. **Navigation Mode**: Chỉ cần driving directions hay cần cả walking/cycling/public transit?
> 3. **Weather Integration**: Weather nên hiển thị ở đâu? (a) Trên map như overlay, (b) Trong friend bottom sheet, (c) Screen riêng, (d) Cả 3?
> 4. **Clean Architecture**: Bạn có muốn áp dụng Clean Architecture đầy đủ (với Use Cases, Interfaces, Either types) cho 2 tính năng mới này không? Hay giữ pattern hiện tại cho đến Phase 3?
