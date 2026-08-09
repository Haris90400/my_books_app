import 'dart:async';

import '../../domain/entities/book.dart';
import '../../domain/repositories/books_repository.dart';
import '../datasources/books_remote_data_source.dart';
import '../datasources/search_history_local_data_source.dart';
import '../models/book_model.dart';

/// Handles data operations for Books.
class BooksRepositoryImpl implements BooksRepository {
  BooksRepositoryImpl({
    required BooksRemoteDataSource remoteDataSource,
    required SearchHistoryLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  final BooksRemoteDataSource _remoteDataSource;
  final SearchHistoryLocalDataSource _localDataSource;

  @override
  Future<List<Book>> searchBooks({
    required String query,
    required int startIndex,
    int maxResults = 20,
  }) async {
    final books = await _remoteDataSource.search(
      query: query,
      startIndex: startIndex,
      maxResults: maxResults,
    );

    // Fire-and-forget, deliberately not awaited: the caller asked for
    // search RESULTS, and got them — a cache write failing is not a
    // reason to fail the search. `unawaited` makes that a documented
    // choice instead of an accidentally-ignored Future.
    unawaited(_cacheQuietly(query, books));

    return books;
  }

  Future<void> _cacheQuietly(String query, List<BookModel> books) async {
    try {
      await _localDataSource.cacheSearchResults(query: query, books: books);
    } catch (_) {
      // Caching search history is a nice-to-have for this call's caller;
      // it must never surface as a failed search to the user.
    }
  }

  @override
  Future<void> clearLocalData() {
    return _localDataSource.clearAll();
  }

  @override
  Future<List<Book>> getAllCachedBooks() {
    return _localDataSource.getAllCachedBooks();
  }

  @override
  Future<List<String>> getRecentSearchQueries() {
    return _localDataSource.getRecentSearchQueries();
  }
}
