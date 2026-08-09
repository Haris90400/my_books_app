import 'package:equatable/equatable.dart';

import '../../../../shared/book/domain/entities/book.dart';

/// Creates = instance.
typedef GenreSlice = ({String genre, int count});
typedef YearBucket = ({String label, int count});

abstract class AnalyticsState extends Equatable {
  const AnalyticsState();

  @override
  List<Object?> get props => [];
}

class AnalyticsInitial extends AnalyticsState {
  const AnalyticsInitial();
}

class AnalyticsLoading extends AnalyticsState {
  const AnalyticsLoading();
}

class AnalyticsLoaded extends AnalyticsState {
  const AnalyticsLoaded({
    required this.genreDistribution,
    required this.publishingTrend,
    required this.totalSearches,
    required this.booksDiscovered,
    required this.topGenre,
    required this.searchQueries,
    required this.cachedBooks,
  });

  final List<GenreSlice> genreDistribution;
  final List<YearBucket> publishingTrend;
  final int totalSearches;
  final int booksDiscovered;
  final String topGenre;

  /// The search queries property.
  final List<String> searchQueries;
  final List<Book> cachedBooks;

  @override
  List<Object?> get props =>
      [genreDistribution, publishingTrend, totalSearches, booksDiscovered, topGenre, searchQueries, cachedBooks];
}

class AnalyticsError extends AnalyticsState {
  const AnalyticsError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
