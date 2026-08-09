import '../../../../shared/book/domain/entities/book.dart';

/// Remote/Local data source for TrendingBooksRemote.
abstract class TrendingBooksRemoteDataSource {
  /// Connect.
  Stream<Book> connect();

  Future<void> disconnect();
}
