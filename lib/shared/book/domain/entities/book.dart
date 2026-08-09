import 'package:equatable/equatable.dart';

/// Represents Book.
class Book extends Equatable {
  const Book({
    required this.id,
    required this.title,
    required this.authors,
    this.description,
    this.publisher,
    this.publishedDate,
    this.categories = const [],
    this.thumbnailUrl,
    this.pageCount,
  });

  final String id;
  final String title;
  final List<String> authors;
  final String? description;
  final String? publisher;

  /// The published date property.
  final String? publishedDate;
  final List<String> categories;
  final String? thumbnailUrl;
  final int? pageCount;

  /// Setup required properties.
  int? get publishedYear {
    if (publishedDate == null || publishedDate!.length < 4) return null;
    return int.tryParse(publishedDate!.substring(0, 4));
  }

  String get authorsLabel => authors.isEmpty ? 'Unknown author' : authors.join(', ');

  @override
  List<Object?> get props => [
        id,
        title,
        authors,
        description,
        publisher,
        publishedDate,
        categories,
        thumbnailUrl,
        pageCount,
      ];
}
