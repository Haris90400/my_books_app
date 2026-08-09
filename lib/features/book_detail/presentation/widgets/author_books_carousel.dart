import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/book/domain/entities/book.dart';
import '../../../home_search/presentation/widgets/book_cover_image.dart';

/// Represents AuthorBooksCarousel.
class AuthorBooksCarousel extends StatelessWidget {
  const AuthorBooksCarousel({super.key, required this.books, required this.isLoading, required this.onBookTap});

  final List<Book> books;
  final bool isLoading;
  final ValueChanged<Book> onBookTap;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const SizedBox(height: 150, child: Center(child: CircularProgressIndicator()));
    }
    if (books.isEmpty) {
      return SizedBox(
        height: 60,
        child: Center(
          child: Text('No other books found', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted)),
        ),
      );
    }

    return SizedBox(
      height: 150,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: books.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final book = books[index];
          return GestureDetector(
            onTap: () => onBookTap(book),
            child: SizedBox(
              width: 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BookCoverImage(imageUrl: book.thumbnailUrl, width: 100, height: 110, heroTag: 'book-cover-${book.id}'),
                  const SizedBox(height: 6),
                  Text(
                    book.title,
                    style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w500),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
