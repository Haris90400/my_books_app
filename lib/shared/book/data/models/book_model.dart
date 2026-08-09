import '../../domain/entities/book.dart';

/// Represents the Book data structure.
class BookModel extends Book {
  const BookModel({
    required super.id,
    required super.title,
    required super.authors,
    super.description,
    super.publisher,
    super.publishedDate,
    super.categories,
    super.thumbnailUrl,
    super.pageCount,
  });

  /// Creates BookModel.fromGoogleBooksVolume instance.
  factory BookModel.fromGoogleBooksVolume(Map<String, dynamic> json) {
    final volumeInfo = json['volumeInfo'] as Map<String, dynamic>? ?? const {};
    final imageLinks = volumeInfo['imageLinks'] as Map<String, dynamic>?;
    final rawThumbnail = imageLinks?['thumbnail'] as String?;

    return BookModel(
      id: json['id'] as String? ?? '',
      title: volumeInfo['title'] as String? ?? 'Untitled',
      authors: (volumeInfo['authors'] as List?)?.cast<String>() ?? const [],
      description: volumeInfo['description'] as String?,
      publisher: volumeInfo['publisher'] as String?,
      publishedDate: volumeInfo['publishedDate'] as String?,
      categories: (volumeInfo['categories'] as List?)?.cast<String>() ?? const [],
      // Google Books serves cover images over http:// — Android blocks
      // cleartext traffic by default, so this would silently fail to load.
      thumbnailUrl: rawThumbnail?.replaceFirst('http://', 'https://'),
      pageCount: volumeInfo['pageCount'] as int?,
    );
  }

  /// To cache json.
  Map<String, dynamic> toCacheJson() {
    return {
      'id': id,
      'title': title,
      'authors': authors,
      'description': description,
      'publisher': publisher,
      'publishedDate': publishedDate,
      'categories': categories,
      'thumbnailUrl': thumbnailUrl,
      'pageCount': pageCount,
    };
  }

  factory BookModel.fromCacheJson(Map<dynamic, dynamic> json) {
    return BookModel(
      id: json['id'] as String,
      title: json['title'] as String,
      authors: (json['authors'] as List).cast<String>(),
      description: json['description'] as String?,
      publisher: json['publisher'] as String?,
      publishedDate: json['publishedDate'] as String?,
      categories: (json['categories'] as List? ?? const []).cast<String>(),
      thumbnailUrl: json['thumbnailUrl'] as String?,
      pageCount: json['pageCount'] as int?,
    );
  }
}
