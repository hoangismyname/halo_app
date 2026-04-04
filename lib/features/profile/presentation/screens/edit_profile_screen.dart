import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../profile_providers.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/halo_avatar.dart';
import '../../../../core/widgets/halo_button.dart';
import '../../../../core/widgets/halo_text_field.dart';
import '../../../../core/utils/extensions.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _displayNameController = TextEditingController();
  final _bioController = TextEditingController();
  bool _initialized = false;

  @override
  void dispose() {
    _displayNameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(currentProfileProvider);
    final updateState = ref.watch(profileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chỉnh sửa hồ sơ'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, size: 20),
        ),
      ),
      body: profileAsync.when(
        data: (profile) {
          if (profile == null) {
            return const Center(
              child: Text('Không tìm thấy hồ sơ',
                  style: TextStyle(color: AppColors.textTertiary)),
            );
          }

          if (!_initialized) {
            _displayNameController.text = profile.displayName;
            _bioController.text = profile.bio;
            _initialized = true;
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.lg),
            child: Column(
              children: [
                Stack(
                  children: [
                    HaloAvatar(
                      imageUrl: profile.avatarUrl,
                      name: profile.displayName.isNotEmpty
                          ? profile.displayName
                          : profile.username,
                      size: AppSizes.avatarXxl,
                      showBorder: true,
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: AppColors.background, width: 3),
                        ),
                        child: const Icon(Icons.camera_alt,
                            size: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.xl),
                HaloTextField(
                  controller: _displayNameController,
                  labelText: 'Tên hiển thị',
                  prefixIcon: Icons.person_outline,
                ),
                const SizedBox(height: AppSizes.md),
                HaloTextField(
                  controller: _bioController,
                  labelText: 'Giới thiệu',
                  prefixIcon: Icons.info_outline,
                  maxLines: 3,
                  maxLength: 200,
                ),
                const SizedBox(height: AppSizes.xl),
                HaloButton(
                  text: 'Lưu thay đổi',
                  isLoading: updateState.isLoading,
                  onPressed: () async {
                    final success = await ref
                        .read(profileProvider.notifier)
                        .updateProfile(
                          displayName: _displayNameController.text.trim(),
                          bio: _bioController.text.trim(),
                        );
                    if (context.mounted) {
                      if (success) {
                        ref.invalidate(currentProfileProvider);
                        context.showSnackBar('Đã cập nhật hồ sơ!');
                        Navigator.pop(context);
                      } else {
                        context.showSnackBar('Cập nhật thất bại',
                            isError: true);
                      }
                    }
                  },
                ),
              ],
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (error, _) => Center(
          child: Text('Lỗi: $error',
              style: const TextStyle(color: AppColors.error)),
        ),
      ),
    );
  }
}
