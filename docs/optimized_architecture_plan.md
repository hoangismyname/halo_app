# HALO APP - CLEAN ARCHITECTURE OPTIMIZATION PLAN

Tài liệu này đề xuất phương án tái cấu trúc toàn diện (Refactoring) dự án Halo App nhằm đạt tiêu chuẩn **Clean Architecture** chuyên biệt. Bản thân dự án hiện tại đã áp dụng cơ chế phân chia theo hướng *Feature-first* (chia theo tính năng: auth, chat, friends, map...) và nhúng phân lớp (presentation, domain, data). Tuy nhiên, trên phương diện Clean Architecture chuẩn xác, thiết kế này vẫn được coi là phiên bản rút gọn (Simplified Layered Architecture).

Dưới đây là so sánh giữa **Cấu trúc hiện tại** và **Cấu trúc tối ưu (Clean Architecture)** được đề xuất, kèm theo cách phân chia tệp tin mới để giữ mã nguồn cực kỳ dễ mở rộng và bảo trì.

---

## 1. ĐÁNH GIÁ KIẾN TRÚC HIỆN TẠI VÀ CHỖ CẦN TỐI ƯU

### Trạng thái hiện tại:
- **`domain`:** Đang chứa các Model (DTO) phản hồi trực tiếp cấu trúc từ JSON của Database.
- **`data`:** Chứa thẳng File Repository kết nối thẳng vào thư viện Supabase (Ví dụ: `AuthRepository` ôm tất cả logic fetch/decode JSON).
- **`presentation`:** Riverpod Providers đóng vai trò xử lý logic nghiệp vụ và gọi thẳng Repository.

### Vấn đề gặp phải nếu Backend mở rộng:
1. Vi phạm nguyên lý **Dependency Inversion**: Repository ở Data đang là Concrete Class (Khuôn đúc xác định). Khó thay thế API.
2. Thiếu **Use Cases**: Toàn bộ UI sẽ bị phình to nếu 1 hành động cần phối hợp nhiều Repositories (Ví dụ: Gửi ảnh cần cả `StorageRepository` và `ChatRepository`).
3. Domain Models đang bị dính líu đến `json_serializable` (Của Data Layer).

---

## 2. BẢN TỐI ƯU HÓA: CẤU TRÚC CLEAN ARCHITECTURE CHUẨN MỰC

Nếu tiến hành Refactor ở Giai đoạn tiếp theo, dưới đây là bộ khung (Blueprint) hoàn hảo nhất:

### A. Tầng DOMAIN (Phần cốt lõi, không phụ thuộc vào Framework hay Supabase)
Tầng này KHÔNG được chứa bất kỳ Import nào từ `Supabase`, `http`, hay `json_serializable`.
* `entities/`: Chứa các object thuần Dart (Ví dụ: `UserEntity`).
* `repositories/`: Chứa các **Abstract class (Interface)** (Ví dụ: `abstract class AuthRepositoryInterface`).
* `usecases/`: Mỗi chức năng là một class riêng biệt (Ví dụ: `LoginUseCase`, `SendMessageUseCase`). Giúp các Lập trình viên khác nhìn vào là biết App làm được gì.

### B. Tầng DATA (Giao tiếp với Thế giới bên ngoài)
* `models/`: Các Data model extend từ `entities`, chứa các method `fromJson`, `toJson` (có thể dùng Freezed ở đây).
* `datasources/`:
  * `remote_data_source.dart`: Kết nối trực tiếp vào Supabase và trả về `models`.
  * `local_data_source.dart`: Kết nối vào SharedPreferences/Hive (đệm lấy last_location).
* `repositories_impl/`: Triển khai các Interface của tầng Domain. Ở đây sẽ gọi Data Sources và chuyển đổi `models` thành `entities` trả về cho Domain.

### C. Tầng PRESENTATION (Giao diện)
* Giữ nguyên cấu trúc: `providers/`, `screens/`, `widgets/`.
* Nhưng: Providers (Riverpod) giờ đây không gọi thẳng Repository. Các Provider sẽ gọi các `Use Cases` đã được inject sẵn.

---

## 3. VÍ DỤ MINH HOẠ BẢN OPTIMIZED CHO MODULE `auth`

Với Clean Architecture, thư mục `lib/features/auth/` sẽ biến đổi thành:

```text
lib/features/auth/
├── domain/                                  <- Lõi nghiệp vụ (Thuần Dart)
│   ├── entities/user_entity.dart
│   ├── repositories/auth_repository.dart    <- Interface
│   └── usecases/
│       ├── login_usecase.dart
│       └── logout_usecase.dart
│
├── data/                                    <- Triển khai Data
│   ├── models/user_model.dart               <- Extends UserEntity
│   ├── datasources/
│   │   ├── auth_remote_datasource.dart      <- Gọi Supabase
│   │   └── auth_local_datasource.dart       <- Gọi SharedPreferences
│   └── repositories/auth_repository_impl.dart <- Implements AuthRepository
│
└── presentation/                            <- UI & State
    ├── providers/auth_usecase_providers.dart<- Inject UseCases vào State
    ├── screens/
    └── widgets/
```

---

## 4. QUY TRÌNH THỰC THI (MIGRATION TASK LIST CHO PHASE 3)

Nếu bạn đưa ra quyết định "Áp dụng Clean Architecture 100%" trong lần sửa đổi tiếp theo, đây là các khối công việc cần làm tuần tự để không gãy App:

1. **Khởi tạo Dependency Injection (Riverpod base):** 
   - Đăng ký Provider cho các `SupabaseClient` và `SharedPreferences` ở quy mô Toàn cục (Global).
2. **Tách Data Source:**
   - Tạo `AuthRemoteDataSource` để gom mọi hàm của Supabase Auth vào.
   - Trích xuất toàn bộ Data JSON ra khỏi file code.
3. **Thêm Use Cases (Interactors):**
   - Viết tính năng `UpdateUserLocationUseCase` với tham số là toạ độ đơn giản.
4. **Cập nhật UI Providers:**
   - Chuyển Providers sang gọi các UseCases.
   - Thư viện như `fpdart` hoặc `dartz` nên được cài thêm để trả về kết quả `Either<Failure, Success>` để xử lý lỗi thanh lịch hơn thay vì `try-catch` lộn xộn trong UI.

> [!IMPORTANT]
> Cấu trúc Clean Architecture yêu cầu viết mã dài hơn (nhiều lớp Boilerplate hơn) cho tính năng đơn giản. Hãy chỉ áp dụng vào giai đoạn tiếp theo khi dự án bắt đầu lớn lên ở mảng **Friends**, **Chatting groups**, **Voice call**, v.v.! Về cơ bản, bộ Document hiện tại vẫn phục vụ rất tốt để đưa dự án tới điểm MVP (Version 1.0).
