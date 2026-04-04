import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';

class MessageBubble extends StatelessWidget {
  final String content;
  final bool isMe;
  final String messageType;
  final String? stickerUrl;
  final Map<String, dynamic> metadata;
  final DateTime? timestamp;

  const MessageBubble({
    super.key,
    required this.content,
    required this.isMe,
    this.messageType = 'text',
    this.stickerUrl,
    this.metadata = const {},
    this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.sm),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (isMe) const Spacer(flex: 2),
          Flexible(
            flex: 5,
            child: _buildBubble(),
          ),
          if (!isMe) const Spacer(flex: 2),
        ],
      ),
    );
  }

  Widget _buildBubble() {
    if (messageType == 'sticker') {
      return _buildStickerBubble();
    }

    if (messageType == 'location') {
      return _buildLocationBubble();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isMe ? AppColors.myMessage : AppColors.otherMessage,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(16),
          topRight: const Radius.circular(16),
          bottomLeft: Radius.circular(isMe ? 16 : 4),
          bottomRight: Radius.circular(isMe ? 4 : 16),
        ),
        boxShadow: [
          BoxShadow(
            color: (isMe ? AppColors.primary : Colors.black).withValues(alpha: 0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            content,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 15,
              color: isMe ? AppColors.myMessageText : AppColors.otherMessageText,
              height: 1.4,
            ),
          ),
          if (timestamp != null) ...[
            const SizedBox(height: 2),
            Text(
              _formatTime(timestamp!),
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 10,
                color: (isMe ? AppColors.myMessageText : AppColors.textTertiary)
                    .withValues(alpha: 0.6),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStickerBubble() {
    return Column(
      crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          width: 120,
          height: 120,
          padding: const EdgeInsets.all(8),
          child: stickerUrl != null
              ? Text(
                  stickerUrl!,
                  style: const TextStyle(fontSize: 64),
                  textAlign: TextAlign.center,
                )
              : const Icon(Icons.emoji_emotions, size: 64, color: AppColors.primary),
        ),
        if (timestamp != null)
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              _formatTime(timestamp!),
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 10,
                color: AppColors.textTertiary,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildLocationBubble() {
    final lat = metadata['latitude'] as double?;
    final lng = metadata['longitude'] as double?;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isMe ? AppColors.myMessage : AppColors.otherMessage,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.location_on,
                size: 18,
                color: isMe ? AppColors.myMessageText : AppColors.primary,
              ),
              const SizedBox(width: 4),
              Text(
                'Vị trí được chia sẻ',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isMe ? AppColors.myMessageText : AppColors.textPrimary,
                ),
              ),
            ],
          ),
          if (lat != null && lng != null) ...[
            const SizedBox(height: 4),
            Text(
              '${lat.toStringAsFixed(4)}, ${lng.toStringAsFixed(4)}',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                color: (isMe ? AppColors.myMessageText : AppColors.textTertiary),
              ),
            ),
          ],
          if (timestamp != null) ...[
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                _formatTime(timestamp!),
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 10,
                  color: (isMe ? AppColors.myMessageText : AppColors.textTertiary)
                      .withValues(alpha: 0.6),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatTime(DateTime dt) {
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}
