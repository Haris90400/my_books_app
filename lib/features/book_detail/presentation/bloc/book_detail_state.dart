import 'package:equatable/equatable.dart';

import '../../../../shared/book/domain/entities/book.dart';

abstract class BookDetailState extends Equatable {
  const BookDetailState();

  @override
  List<Object?> get props => [];
}

class BookDetailInitial extends BookDetailState {
  const BookDetailInitial();
}

/// Represents BookDetailLoaded.
class BookDetailLoaded extends BookDetailState {
  const BookDetailLoaded({
    required this.book,
    required this.recommendedBooks,
    required this.isLoadingRecommendations,
    required this.summary,
    required this.isLoadingSummary,
    required this.summaryFailed,
  });

  final Book book;

  final List<Book> recommendedBooks;
  final bool isLoadingRecommendations;

  /// The summary property.
  final String? summary;
  final bool isLoadingSummary;
  final bool summaryFailed;

  BookDetailLoaded copyWith({
    List<Book>? recommendedBooks,
    bool? isLoadingRecommendations,
    String? summary,
    bool? isLoadingSummary,
    bool? summaryFailed,
  }) {
    return BookDetailLoaded(
      book: book,
      recommendedBooks: recommendedBooks ?? this.recommendedBooks,
      isLoadingRecommendations: isLoadingRecommendations ?? this.isLoadingRecommendations,
      summary: summary ?? this.summary,
      isLoadingSummary: isLoadingSummary ?? this.isLoadingSummary,
      summaryFailed: summaryFailed ?? this.summaryFailed,
    );
  }

  @override
  List<Object?> get props => [book, recommendedBooks, isLoadingRecommendations, summary, isLoadingSummary, summaryFailed];
}
