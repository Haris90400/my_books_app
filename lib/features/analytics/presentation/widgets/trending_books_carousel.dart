import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/book/domain/entities/book.dart';
import '../../../home_search/presentation/widgets/book_cover_image.dart';

/// Represents TrendingBooksCarousel.
class TrendingBooksCarousel extends StatelessWidget {
  const TrendingBooksCarousel({super.key, required this.books, required this.isLive});

  final List<Book> books;
  final bool isLive;

  @override
  Widget build(BuildContext context) {
    if (books.isEmpty) {
      return Center(
        child: Text('Waiting for trending updates…', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted)),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                color: isLive ? AppColors.success : AppColors.textMuted,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              isLive ? 'LIVE' : 'CONNECTING…',
              style: AppTextStyles.bodySmall.copyWith(
                color: isLive ? AppColors.success : AppColors.textMuted,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.6,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 150,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: books.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final book = books[index];
              return SizedBox(
                width: 100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BookCoverImage(imageUrl: book.thumbnailUrl, width: 100, height: 110),
                    const SizedBox(height: 6),
                    Text(
                      book.title,
                      style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w500),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
