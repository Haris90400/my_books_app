import '../models/book_model.dart';

/// Remote/Local data source for SearchHistoryLocal.
abstract class SearchHistoryLocalDataSource {
  Future<void> cacheSearchResults({required String query, required List<BookModel> books});

  /// Clear all.
  Future<void> clearAll();

  /// Get all cached books.
  Future<List<BookModel>> getAllCachedBooks();

  /// Get recent search queries.
  Future<List<String>> getRecentSearchQueries();
}
