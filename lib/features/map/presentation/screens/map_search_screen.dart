import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../providers/map_search_provider.dart';

class MapSearchScreen extends ConsumerStatefulWidget {
  const MapSearchScreen({super.key});

  @override
  ConsumerState<MapSearchScreen> createState() => _MapSearchScreenState();
}

class _MapSearchScreenState extends ConsumerState<MapSearchScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Delay requesting focus to avoid animation jank
    Future.microtask(() => _focusNode.requestFocus());
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(mapSearchProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar header
            Padding(
              padding: const EdgeInsets.only(
                left: 8.0,
                right: 16.0,
                top: 16.0,
                bottom: 8.0,
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: AppColors.textPrimary,
                    ),
                    onPressed: () => context.pop(),
                  ),
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(width: 12),
                          const Icon(
                            Icons.search,
                            color: AppColors.textSecondary,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              focusNode: _focusNode,
                              onChanged: (val) {
                                ref
                                    .read(mapSearchProvider.notifier)
                                    .search(val);
                                setState(() {}); // To show/hide clear button
                              },
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 16,
                                color: AppColors.textPrimary,
                              ),
                              decoration: const InputDecoration(
                                hintText: 'Tìm kiếm địa điểm...',
                                hintStyle: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 16,
                                  color: AppColors.textSecondary,
                                ),
                                filled: false,
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                          if (_controller.text.isNotEmpty)
                            IconButton(
                              icon: const Icon(
                                Icons.close,
                                color: AppColors.textSecondary,
                                size: 18,
                              ),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              onPressed: () {
                                _controller.clear();
                                ref.read(mapSearchProvider.notifier).clear();
                                setState(() {});
                              },
                            ),
                          const SizedBox(width: 12),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Results list
            Expanded(
              child: searchState.when(
                data: (results) {
                  if (results.isEmpty && _controller.text.isNotEmpty) {
                    return const Center(
                      child: Text(
                        'Không tìm thấy kết quả',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: results.length,
                    itemBuilder: (context, index) {
                      final result = results[index];
                      return ListTile(
                        leading: const Icon(
                          Icons.location_on,
                          color: AppColors.textSecondary,
                        ),
                        title: Text(
                          result.addressLine1 ?? result.formatted,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontFamily: 'Inter',
                            fontSize: 16,
                          ),
                        ),
                        subtitle: result.addressLine2 != null
                            ? Text(
                                result.addressLine2!,
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontFamily: 'Inter',
                                  fontSize: 14,
                                ),
                              )
                            : null,
                        onTap: () {
                          // Return result back to MapScreen
                          context.pop(result);
                        },
                      );
                    },
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
                error: (error, _) => Center(
                  child: Text(
                    'Đã xảy ra lỗi: $error',
                    style: const TextStyle(color: AppColors.error),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
