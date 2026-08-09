import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import 'book_cover_image.dart';

/// Represents BookListTile.
class BookListTile extends StatelessWidget {
  const BookListTile({
    super.key,
    required this.title,
    required this.authors,
    required this.publisher,
    required this.coverUrl,
    required this.onTap,
    required this.heroTag,
  });

  final String title;
  final String authors;
  final String? publisher;
  final String? coverUrl;
  final VoidCallback onTap;
  final Object heroTag;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BookCoverImage(imageUrl: coverUrl, width: 56, height: 76, heroTag: heroTag),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    authors,
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (publisher != null && publisher!.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      publisher!,
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
