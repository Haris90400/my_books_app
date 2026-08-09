import 'package:equatable/equatable.dart';

import '../../../../shared/book/domain/entities/book.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

/// Represents SearchInitial.
class SearchInitial extends SearchState {
  const SearchInitial();
}

/// Represents SearchLoading.
class SearchLoading extends SearchState {
  const SearchLoading();
}

/// Represents SearchLoaded.
class SearchLoaded extends SearchState {
  const SearchLoaded({
    required this.books,
    required this.hasReachedMax,
    this.isLoadingMore = false,
    this.loadMoreError,
  });

  final List<Book> books;
  final bool hasReachedMax;
  final bool isLoadingMore;

  /// The load more error property.
  final String? loadMoreError;

  SearchLoaded copyWith({
    List<Book>? books,
    bool? hasReachedMax,
    bool? isLoadingMore,
    String? loadMoreError,
  }) {
    return SearchLoaded(
      books: books ?? this.books,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      loadMoreError: loadMoreError,
    );
  }

  @override
  List<Object?> get props => [books, hasReachedMax, isLoadingMore, loadMoreError];
}

class SearchError extends SearchState {
  const SearchError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
