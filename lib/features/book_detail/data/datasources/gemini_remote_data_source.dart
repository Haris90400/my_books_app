import '../../../../shared/book/domain/entities/book.dart';

/// Remote/Local data source for GeminiRemote.
abstract class GeminiRemoteDataSource {
  /// Generate summary.
  Future<String> generateSummary(Book book);
}
