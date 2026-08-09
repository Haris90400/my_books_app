import 'package:dio/dio.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_error_mapper.dart';
import '../../../../shared/book/domain/entities/book.dart';
import 'gemini_remote_data_source.dart';

/// Remote/Local data source for GoogleGeminiRemote.
class GoogleGeminiRemoteDataSource implements GeminiRemoteDataSource {
  GoogleGeminiRemoteDataSource({required Dio dio, required String apiKey})
      : _dio = dio,
        _apiKey = apiKey;

  final Dio _dio;
  final String _apiKey;

  /// The _base url property.
  static const _baseUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-flash-latest:generateContent';

  static const _fallbackMessage = 'Summary could not be generated right now.';

  @override
  Future<String> generateSummary(Book book) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        _baseUrl,
        queryParameters: {'key': _apiKey},
        data: {
          'contents': [
            {
              'parts': [
                {'text': _buildPrompt(book)},
              ],
            },
          ],
        },
      );

      final text = _extractText(response.data);
      if (text == null || text.trim().isEmpty) {
        throw const AppException(_fallbackMessage);
      }
      return text.trim();
    } on DioException catch (e) {
      throw AppException(DioErrorMapper.map(e));
    } on AppException {
      rethrow;
    } catch (_) {
      throw const AppException(_fallbackMessage);
    }
  }

  /// Creates _buildPrompt instance.
  String _buildPrompt(Book book) {
    final buffer = StringBuffer()
      ..writeln(
        'Write a concise, engaging summary (2-3 sentences, under 60 words) '
        'of this book for a reader deciding whether to read it.',
      )
      ..writeln('Title: ${book.title}')
      ..writeln('Author(s): ${book.authorsLabel}');

    if (book.categories.isNotEmpty) {
      buffer.writeln('Genre: ${book.categories.first}');
    }
    if (book.description != null && book.description!.isNotEmpty) {
      buffer.writeln('Description: ${book.description}');
    }

    buffer.writeln('Respond with ONLY the summary text, no preamble or labels.');
    return buffer.toString();
  }

  /// Creates _extractText instance.
  String? _extractText(Map<String, dynamic>? data) {
    final candidates = data?['candidates'] as List?;
    if (candidates == null || candidates.isEmpty) return null;

    final content = (candidates.first as Map<String, dynamic>)['content'] as Map<String, dynamic>?;
    final parts = content?['parts'] as List?;
    if (parts == null || parts.isEmpty) return null;

    return (parts.first as Map<String, dynamic>)['text'] as String?;
  }
}
