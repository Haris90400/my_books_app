import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/book/domain/entities/book.dart';
import '../../../../shared/book/domain/repositories/books_repository.dart';
import 'analytics_event.dart';
import 'analytics_state.dart';

/// State management for Analytics.
class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {
  AnalyticsBloc({required BooksRepository booksRepository})
      : _booksRepository = booksRepository,
        super(const AnalyticsInitial()) {
    on<AnalyticsRequested>(_onAnalyticsRequested);
  }

  final BooksRepository _booksRepository;

  Future<void> _onAnalyticsRequested(AnalyticsRequested event, Emitter<AnalyticsState> emit) async {
    emit(const AnalyticsLoading());
    try {
      final cachedBooks = await _booksRepository.getAllCachedBooks();
      final recentQueries = await _booksRepository.getRecentSearchQueries();

      final genreDistribution = _computeGenreDistribution(cachedBooks);
      emit(
        AnalyticsLoaded(
          genreDistribution: genreDistribution,
          publishingTrend: _computeYearBuckets(cachedBooks),
          totalSearches: recentQueries.length,
          booksDiscovered: cachedBooks.length,
          topGenre: genreDistribution.isEmpty ? '—' : genreDistribution.first.genre,
          searchQueries: recentQueries,
          cachedBooks: cachedBooks,
        ),
      );
    } catch (_) {
      emit(const AnalyticsError('Could not load your analytics. Please try again.'));
    }
  }

  /// The _max genre slices property.
  static const _maxGenreSlices = 6;

  /// Creates _computeGenreDistribution instance.
  List<GenreSlice> _computeGenreDistribution(List<Book> books) {
    final counts = <String, int>{};
    for (final book in books) {
      final primaryGenre = book.categories.isEmpty ? 'Uncategorized' : book.categories.first.split('/').first.trim();
      counts[primaryGenre] = (counts[primaryGenre] ?? 0) + 1;
    }
    final slices = [for (final entry in counts.entries) (genre: entry.key, count: entry.value)];
    slices.sort((a, b) => b.count.compareTo(a.count));

    if (slices.length <= _maxGenreSlices) return slices;

    final topSlices = slices.take(_maxGenreSlices).toList();
    final otherCount = slices.skip(_maxGenreSlices).fold<int>(0, (sum, s) => sum + s.count);
    return [...topSlices, (genre: 'Other', count: otherCount)];
  }

  static const _bucketSizeYears = 5;

  /// The _max recent buckets property.
  static const _maxRecentBuckets = 6;

  List<YearBucket> _computeYearBuckets(List<Book> books) {
    final years = books.map((b) => b.publishedYear).whereType<int>().toList();
    if (years.isEmpty) return [];

    final maxYear = years.reduce((a, b) => a > b ? a : b);
    final latestBucketStart = (maxYear ~/ _bucketSizeYears) * _bucketSizeYears;
    final earliestBucketStart = latestBucketStart - (_maxRecentBuckets - 1) * _bucketSizeYears;

    final counts = <int, int>{};
    var olderCount = 0;
    for (final year in years) {
      if (year < earliestBucketStart) {
        olderCount++;
        continue;
      }
      final bucket = (year ~/ _bucketSizeYears) * _bucketSizeYears;
      counts[bucket] = (counts[bucket] ?? 0) + 1;
    }

    return [
      if (olderCount > 0) (label: '< $earliestBucketStart', count: olderCount),
      for (var start = earliestBucketStart; start <= latestBucketStart; start += _bucketSizeYears)
        (label: '\'${_twoDigitYear(start)}-\'${_twoDigitYear(start + _bucketSizeYears - 1)}', count: counts[start] ?? 0),
    ];
  }

  String _twoDigitYear(int year) => (year % 100).toString().padLeft(2, '0');
}
