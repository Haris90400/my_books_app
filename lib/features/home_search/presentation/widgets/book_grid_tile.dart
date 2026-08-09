import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import 'book_cover_image.dart';

class BookGridTile extends StatelessWidget {
  const BookGridTile({
    super.key,
    required this.title,
    required this.authors,
    required this.coverUrl,
    required this.onTap,
    required this.heroTag,
  });

  final String title;
  final String authors;
  final String? coverUrl;
  final VoidCallback onTap;
  final Object heroTag;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Expanded, not AspectRatio: the cover takes whatever vertical
          // space is left over after the two fixed-size text rows below.
          // AspectRatio computes an exact pixel height from width — that
          // math plus text-layout rounding is exactly what caused the
          // sub-pixel overflow. Expanded can never overflow: Column always
          // has exactly enough room for it by construction.
          Expanded(
            child: BookCoverImage(
              imageUrl: coverUrl,
              width: double.infinity,
              height: double.infinity,
              heroTag: heroTag,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w500, color: AppColors.textPrimary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            authors,
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
