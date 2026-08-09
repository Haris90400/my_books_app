import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/book/domain/entities/book.dart';
import '../../../../shared/book/domain/repositories/books_repository.dart';
import '../../../home_search/presentation/widgets/book_cover_image.dart';
import '../../data/datasources/gemini_remote_data_source.dart';
import '../bloc/book_detail_bloc.dart';
import '../bloc/book_detail_event.dart';
import '../bloc/book_detail_state.dart';
import '../widgets/ai_summary_card.dart';
import '../widgets/author_books_carousel.dart';
import '../widgets/book_metadata_chip.dart';

/// Main UI for the BookDetail screen.
@RoutePage(name: 'BookDetailRoute')
class BookDetailPage extends StatelessWidget {
  const BookDetailPage({super.key, required this.book});

  final Book book;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BookDetailBloc>(
      create: (_) => BookDetailBloc(
        booksRepository: sl<BooksRepository>(),
        geminiDataSource: sl<GeminiRemoteDataSource>(),
      )..add(BookDetailRequested(book)),
      child: _BookDetailView(book: book),
    );
  }
}

class _BookDetailView extends StatelessWidget {
  const _BookDetailView({required this.book});

  final Book book;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _CoverHeader(book: book),
              const SizedBox(height: 20),
              Text(book.title, style: AppTextStyles.headlineMedium),
              const SizedBox(height: 4),
              Text(book.authorsLabel, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted)),
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (book.publisher != null && book.publisher!.isNotEmpty)
                    BookMetadataChip(icon: Icons.apartment_rounded, label: book.publisher!),
                  if (book.publishedYear != null)
                    BookMetadataChip(icon: Icons.event_rounded, label: '${book.publishedYear}'),
                  if (book.pageCount != null)
                    BookMetadataChip(icon: Icons.menu_book_rounded, label: '${book.pageCount} pages'),
                  if (book.categories.isNotEmpty)
                    BookMetadataChip(icon: Icons.sell_rounded, label: book.categories.first.split('/').first.trim()),
                ],
              ),
              const SizedBox(height: 20),
              Text('About this book', style: AppTextStyles.titleMedium),
              const SizedBox(height: 8),
              Text(
                (book.description == null || book.description!.isEmpty) ? 'No description available.' : book.description!,
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary, height: 1.5),
              ),
              const SizedBox(height: 24),
              BlocBuilder<BookDetailBloc, BookDetailState>(
                builder: (context, state) {
                  final loaded = state is BookDetailLoaded ? state : null;
                  return AiSummaryCard(
                    isLoading: loaded?.isLoadingSummary ?? true,
                    summary: loaded?.summary,
                    hasError: loaded?.summaryFailed ?? false,
                  );
                },
              ),
              const SizedBox(height: 24),
              Text('More by ${book.authorsLabel}', style: AppTextStyles.titleMedium),
              const SizedBox(height: 12),
              BlocBuilder<BookDetailBloc, BookDetailState>(
                builder: (context, state) {
                  final loaded = state is BookDetailLoaded ? state : null;
                  return AuthorBooksCarousel(
                    books: loaded?.recommendedBooks ?? const [],
                    isLoading: loaded?.isLoadingRecommendations ?? true,
                    onBookTap: (tappedBook) => context.router.push(BookDetailRoute(book: tappedBook)),
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _CoverHeader extends StatelessWidget {
  const _CoverHeader({required this.book});

  final Book book;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: GestureDetector(
            onTap: () => context.router.push(
              BookCoverViewerRoute(imageUrl: book.thumbnailUrl, heroTag: 'book-cover-${book.id}'),
            ),
            child: BookCoverImage(
              imageUrl: book.thumbnailUrl,
              width: 180,
              height: 260,
              borderRadius: 20,
              heroTag: 'book-cover-${book.id}',
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          child: _BackButton(onTap: () => context.router.maybePop()),
        ),
      ],
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      shape: const CircleBorder(),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: const Padding(
          padding: EdgeInsets.all(8),
          child: Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
        ),
      ),
    );
  }
}
