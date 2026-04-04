import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';

/// Built-in emoji/sticker picker using emoji characters
class StickerPicker extends StatelessWidget {
  final void Function(String stickerUrl) onStickerSelected;
  final VoidCallback onClose;

  const StickerPicker({
    super.key,
    required this.onStickerSelected,
    required this.onClose,
  });

  // Sticker packs using emoji characters
  static const Map<String, List<String>> stickerPacks = {
    '😀 Mặt cười': [
      '😀', '😃', '😄', '😁', '😆', '🥹', '😅', '🤣', '😂', '🙂',
      '😉', '😊', '😇', '🥰', '😍', '🤩', '😘', '😗', '😚', '😋',
      '😛', '😜', '🤪', '😝', '🤑', '🤗', '🤭', '🤫', '🤔', '🫡',
    ],
    '❤️ Trái tim': [
      '❤️', '🧡', '💛', '💚', '💙', '💜', '🖤', '🤍', '🤎', '💕',
      '💞', '💓', '💗', '💖', '💝', '💘', '💟', '❣️', '💑', '👩‍❤️‍👨',
    ],
    '👋 Tay & Cử chỉ': [
      '👋', '🤚', '🖐', '✋', '🖖', '👌', '🤌', '🤏', '✌️', '🤞',
      '🤟', '🤘', '🤙', '👈', '👉', '👆', '🖕', '👇', '☝️', '👍',
      '👎', '✊', '👊', '🤛', '🤜', '👏', '🙌', '🫶', '👐', '🤝',
    ],
    '🐶 Động vật': [
      '🐶', '🐱', '🐭', '🐹', '🐰', '🦊', '🐻', '🐼', '🐻‍❄️', '🐨',
      '🐯', '🦁', '🐮', '🐷', '🐸', '🐵', '🙈', '🙉', '🙊', '🐔',
      '🐧', '🐦', '🐤', '🦄', '🐝', '🦋', '🐙', '🐬', '🐳', '🦈',
    ],
    '🎉 Hoạt động': [
      '🎉', '🎊', '🎈', '🎁', '🎀', '🎗️', '🏆', '🥇', '🎯', '🎮',
      '🎲', '🎳', '🎵', '🎶', '🎸', '🎹', '🎺', '🎻', '🥁', '🎬',
      '⚽', '🏀', '🏈', '⚾', '🎾', '🏐', '🏓', '🏸', '🥊', '🚀',
    ],
    '🍕 Đồ ăn': [
      '🍕', '🍔', '🍟', '🌭', '🍿', '🧂', '🥚', '🍳', '🧈', '🥞',
      '🧇', '🥓', '🥩', '🍗', '🍖', '🌮', '🌯', '🫔', '🥙', '🧆',
      '🍜', '🍝', '🍣', '🍱', '🍛', '🍚', '🍙', '🍘', '🥮', '🍰',
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSizes.stickerPickerHeight,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.divider),
        ),
      ),
      child: DefaultTabController(
        length: stickerPacks.length,
        child: Column(
          children: [
            // Tab bar
            TabBar(
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              tabs: stickerPacks.keys
                  .map((name) => Tab(
                        child: Text(
                          name.split(' ').first,
                          style: const TextStyle(fontSize: 20),
                        ),
                      ))
                  .toList(),
              indicatorColor: AppColors.primary,
              dividerColor: Colors.transparent,
            ),

            // Sticker grid
            Expanded(
              child: TabBarView(
                children: stickerPacks.values.map((stickers) {
                  return GridView.builder(
                    padding: const EdgeInsets.all(AppSizes.sm),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 6,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                    ),
                    itemCount: stickers.length,
                    itemBuilder: (context, index) {
                      return _StickerItem(
                        emoji: stickers[index],
                        onTap: () => onStickerSelected(stickers[index]),
                      );
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StickerItem extends StatelessWidget {
  final String emoji;
  final VoidCallback onTap;

  const _StickerItem({required this.emoji, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              emoji,
              style: const TextStyle(fontSize: 30),
            ),
          ),
        ),
      ),
    );
  }
}
