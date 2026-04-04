# TỔNG KẾT & HƯỚNG DẪN DỰ ÁN HALO (GIAI ĐOẠN 1)

Phiên bản đầu tiên của Halo (Ứng dụng mạng xã hội dựa trên vị trí) đã hoàn thành phần lõi UI và luồng xử lý cơ bản với kiến trúc Riverpod & GoRouter. Tuy nhiên, do hiện tại mới ở dạng Demo (sử dụng Fake User/Guest Mode), cần có một số tinh chỉnh và hoàn thiện để dự án chính thức hoạt động trong môi trường Production.

Dưới đây là một số ghi chú và hướng dẫn tối ưu quan trọng.

---

## 1. CÁC TÍNH NĂNG TÌM ẨN VÀ LỖI ĐÃ ĐƯỢC GIẢI QUYẾT
- **Generator Errors (Code Generate Lỗi):** Toàn bộ Provider sinh ra bởi Riverpod đã được ánh xạ chuẩn xác (`authProvider` thay vì `authNotifierProvider`).
- **Path Imports:** Các đường dẫn module bị đứt gãy đã được trỏ thành Relative path tương đối.
- **Location Permission Crash:** Lỗi JVM ngầm bị Crash lúc khởi động Android đã được sửa bằng cách thêm quyền `ACCESS_FINE_LOCATION` vào `AndroidManifest.xml` cùng thư viện Geolocator để ứng dụng không chết do bị khóa Quyền truy cập ngầm.
- **Vị trí cố định khởi tạo:** Đã thay thế toạ độ Hardcode bằng tính năng `Location Stream` cập nhật liên tục, đồng thời có lưu Vị trí cuối (Last Known Position) qua đệm nội bộ (`SharedPreferences`).

---

## 2. NHỮNG ĐIỂM CẦN LƯU Ý KHI KIỂM TRA & SỬA LỖI (GIAI ĐOẠN TIẾP THEO)

> [!WARNING]
> Những nơi sau vẫn đang sử dụng dữ liệu tĩnh hoặc bỏ qua Backend tạm thời, cần lưu ý thay thế:

- **`lib/core/constants/supabase_constants.dart`:** Hiện đang sử dụng chuỗi bí mật `YOUR_PROJECT_ID`. Để làm thật, bạn **phải** lấy URL tĩnh và mã token AnonPublic ở trang Dashboard của Supabase dán vào đây. 
- **`lib/features/auth/data/auth_repository.dart`:** Biến static `isGuestMode` đang tự động gán bằng `true`. Hãy đổi ngược thành `false` nếu muốn ứng dụng sử dụng đăng nhập thật.
- **Dữ liệu giả lập UI (Mock Data):** Các Component như Chat List và Friend List chưa lắng nghe Supabase Database Filter. Để lấy dữ liệu thật, ở các lớp Repository (như `chat_repository.dart`) cần mở các khối code lắng nghe Realtime.

---

## 3. CÁC PHƯƠNG ÁN TỐI ƯU HÓA (OPTIMIZATIONS TARGETS)

> [!TIP]
> Để nâng tầm ứng dụng theo hơi hướng một mạng xã hội thực thụ như Zenly hoặc Jagat, bạn nên tối ưu theo quy luật sau:

### Hình ảnh & Bản đồ
- **Bản đồ:** Hiện tại hệ thống đang sử dụng bản đồ gạch mảng tối miễn phí của Carto (qua Flutter Map). Nên cân nhắc chuyển đổi sang SDK chuyên biệt (ví dụ: Google Maps SDK hoặc Mapbox) có cung cấp công cụ 3D tilt và la bàn (Compass) tự xoay khi di chuyển.
- **Avatar và Cached Network Image:** Hiện các avatar trong thư viện ứng dụng đã định nghĩa trong component `HaloAvatar`. Có thể thêm xử lý Compression kích thước nhỏ hơn trước khi up lên Storage của Supabase để tải hình cực nhanh.
- **Cập nhật Vị trí (Location Broadcast Rate):** 
  - Trong `location_repository.dart`, `distanceFilter` đang đặt là `10` -> `20` mét. Để tránh nóng máy và hao Pin, bạn hãy code tách luồng "Ứng dụng mở" (Cập nhật 10m) và "Chạy ngầm Background" (Cập nhật 15 phút 1 lần hoặc khoảng cách dịch chuyển 200m).
  - Tối ưu truy vấn dữ liệu theo toạ độ địa lý (PostGIS) trên Supabase.

### Xử lý kết nối Realtime
- Nên cấu trúc lại `Status` và `Chat` để gọi cùng 1 kết nối Channel Broadcast trong Supabase (để giảm thiểu Data/Socket Connection) thay vì mỗi Widget tạo một kênh độc lập.

---

## 4. DANH SÁCH TODO DÀNH CHO BẠN (CHECKLIST)
- [ ] Truy cập Supabase và kéo URL / Anon Key về gắn vào.
- [ ] Chạy lệnh `flutter pub run build_runner build --delete-conflicting-outputs` nếu bạn chỉnh sửa bất kỳ lớp nào liên quan đến logic Provider (`*.g.dart`).
- [ ] Tích hợp Push Notifications bằng Firebase Cloud Messaging kết hợp với Supabase Database Trigger mỗi lần có Notification mới.
- [ ] Fix nốt 20 lỗi kiểu lặt vặt Warnings (Unused element, top_level_inference) do Riverpod trả về trong bảng log của `flutter analyze` để dự án đạt độ Clean 100%.

> [!NOTE]
> Khi cần chỉnh sửa file hoặc thực hiện các phần tiếp theo, bạn chỉ việc cung cấp file cần giải quyết (Ví dụ: "Hãy mở lại và kết nối Supabase thật"), dự án đã lưu đầy đủ luồng thực thi trong thiết lập này!
