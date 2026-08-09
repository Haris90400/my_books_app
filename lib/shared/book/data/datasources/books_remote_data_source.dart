import '../models/book_model.dart';

/// Remote/Local data source for BooksRemote.
abstract class BooksRemoteDataSource {
  Future<List<BookModel>> search({
    required String query,
    required int startIndex,
    required int maxResults,
  });
}
