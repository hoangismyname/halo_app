import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';

class ChatInput extends StatefulWidget {
  final void Function(String) onSend;
  final VoidCallback onStickerTap;
  final bool showingStickerPicker;

  const ChatInput({
    super.key,
    required this.onSend,
    required this.onStickerTap,
    this.showingStickerPicker = false,
  });

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final _controller = TextEditingController();
  bool _hasText = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _send() {
    if (_controller.text.trim().isNotEmpty) {
      widget.onSend(_controller.text);
      _controller.clear();
      setState(() => _hasText = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: AppSizes.md,
        right: AppSizes.sm,
        top: AppSizes.sm,
        bottom: MediaQuery.paddingOf(context).bottom + AppSizes.sm,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.divider),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Sticker button
          GestureDetector(
            onTap: widget.onStickerTap,
            child: Container(
              width: 40,
              height: 40,
              margin: const EdgeInsets.only(bottom: 2),
              child: Icon(
                widget.showingStickerPicker
                    ? Icons.keyboard
                    : Icons.emoji_emotions_outlined,
                color: widget.showingStickerPicker
                    ? AppColors.primary
                    : AppColors.textTertiary,
                size: 24,
              ),
            ),
          ),

          const SizedBox(width: 4),

          // Text input
          Expanded(
            child: Container(
              constraints: const BoxConstraints(maxHeight: 120),
              child: TextField(
                controller: _controller,
                maxLines: null,
                onChanged: (text) =>
                    setState(() => _hasText = text.trim().isNotEmpty),
                onSubmitted: (_) => _send(),
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15,
                  color: AppColors.textPrimary,
                ),
                cursorColor: AppColors.primary,
                decoration: InputDecoration(
                  hintText: 'Nhập tin nhắn...',
                  hintStyle: TextStyle(
                    fontFamily: 'Inter',
                    color: AppColors.textTertiary.withValues(alpha: 0.6),
                    fontSize: 15,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 10),
                  fillColor: AppColors.inputFill,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 4),

          // Send button
          GestureDetector(
            onTap: _hasText ? _send : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 40,
              height: 40,
              margin: const EdgeInsets.only(bottom: 2),
              decoration: BoxDecoration(
                gradient: _hasText ? AppColors.primaryGradient : null,
                color: _hasText ? null : Colors.transparent,
                shape: BoxShape.circle,
                boxShadow: _hasText
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 8,
                        ),
                      ]
                    : null,
              ),
              child: Icon(
                Icons.send_rounded,
                color: _hasText ? Colors.white : AppColors.textTertiary,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
