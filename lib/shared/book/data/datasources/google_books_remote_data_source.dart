import 'package:dio/dio.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_error_mapper.dart';
import '../models/book_model.dart';
import 'books_remote_data_source.dart';

/// Remote/Local data source for GoogleBooksRemote.
class GoogleBooksRemoteDataSource implements BooksRemoteDataSource {
  GoogleBooksRemoteDataSource({required Dio dio, required String apiKey})
      : _dio = dio,
        _apiKey = apiKey;

  final Dio _dio;
  final String _apiKey;

  static const _baseUrl = 'https://www.googleapis.com/books/v1/volumes';

  @override
  Future<List<BookModel>> search({
    required String query,
    required int startIndex,
    required int maxResults,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        _baseUrl,
        queryParameters: {
          'q': query,
          'startIndex': startIndex,
          'maxResults': maxResults,
          if (_apiKey.isNotEmpty) 'key': _apiKey,
        },
      );

      // Google Books omits `items` entirely (not `[]`) when nothing
      // matches — `?? const []` is the difference between "no results"
      // and a null-check crash.
      final items = (response.data?['items'] as List?) ?? const [];
      return items
          .cast<Map<String, dynamic>>()
          .map(BookModel.fromGoogleBooksVolume)
          .toList();
    } on DioException catch (e) {
      throw AppException(DioErrorMapper.map(e));
    } catch (_) {
      throw const AppException('Something went wrong. Please try again.');
    }
  }
}
