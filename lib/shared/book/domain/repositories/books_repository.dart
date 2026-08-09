import '../entities/book.dart';

/// Handles data operations for Books.
abstract class BooksRepository {
  /// Search books.
  Future<List<Book>> searchBooks({
    required String query,
    required int startIndex,
    int maxResults = 20,
  });

  /// Clear local data.
  Future<void> clearLocalData();

  /// Get all cached books.
  Future<List<Book>> getAllCachedBooks();

  /// Get recent search queries.
  Future<List<String>> getRecentSearchQueries();
}
