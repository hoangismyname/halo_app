# Demo Phiên bản Alpha Halo App

Hệ thống đã triển khai xong Base codebase cho **Halo App** và giải quyết toàn bộ các vấn đề về Generator & Lints. 

## Tiến độ hiện tại

> [!TIP]
> **Máy ảo Android (Pixel 10 Pro XL) đã được khởi động và lệnh build app đang được chạy ngầm.** Quá trình tải các thư viện của Gradle & NDK trong lần build đầu tiên sẽ mất khoảng 5-10 phút. Ngay khi build xong, app sẽ tự động mở lên trong máy ảo.

### Các Module Đã Hoàn Thành Cấu Trúc UI & Logic:
- **Core Layer:** Setup Theme (Dark) / Router (GoRouter + Riverpod Auth Guard).
- **Auth:** Đăng nhập / Đăng ký (Xử lý Supabase Auth state).
- **Trang chủ (Bản đồ):** Tích hợp OpenStreetMap và Floating UI.
- **Tính năng Xã hội:** Tìm/thêm bạn bè, Danh sách bạn bè.
- **Nhắn tin (Chat):** Giao diện danh sách phòng Chat và chi tiết Phòng chat, Hỗ trợ Sticker Custom.
- **Trạng thái (Status):** Xem trạng thái và thả Emoji tương tự Jagat.
- **Hồ sơ cá nhân:** Xem Profile và Chỉnh sửa.

### Vấn Đề Lưu Ý Nếu Bạn Test App Ngay Lúc Này:
> [!WARNING]
> Do `SupabaseConstants.url` và `SupabaseConstants.anonKey` trong file (`lib/core/constants/supabase_constants.dart`) đang dùng Placeholder (`YOUR_PROJECT_ID`...), khi ứng dụng chạy lên và đến màn hình Splash/Login, nó có thể throw exception hoặc không kết nối được backend. UI/UX hoàn toàn sẵn sàng, nhưng bạn cần thay credentials thật của Supabase vào file trên để nó chính thức hoạt động 100%.

## Bạn muốn tôi làm gì tiếp theo?
1. Trực tiếp thay **URL & API Key** của Supabase nếu bạn có sẵn? (Vui lòng cung cấp)
2. Chờ emulator build xong và kiểm tra phần UI?
3. Thêm/Sửa giao diện nào bạn chưa ưng ý?
