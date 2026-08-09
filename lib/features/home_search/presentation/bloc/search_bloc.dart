import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../shared/book/domain/repositories/books_repository.dart';
import 'search_event.dart';
import 'search_state.dart';

/// State management for Search.
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc({required BooksRepository booksRepository})
      : _booksRepository = booksRepository,
        super(const SearchInitial()) {
    on<SearchQuerySubmitted>(_onSearchQuerySubmitted);
    on<LoadMoreRequested>(_onLoadMoreRequested);
  }

  final BooksRepository _booksRepository;

  /// The _current query property.
  String _currentQuery = '';

  static const _pageSize = 20;

  Future<void> _onSearchQuerySubmitted(SearchQuerySubmitted event, Emitter<SearchState> emit) async {
    _currentQuery = event.query;
    emit(const SearchLoading());
    try {
      final books = await _booksRepository.searchBooks(
        query: _currentQuery,
        startIndex: 0,
        maxResults: _pageSize,
      );
      emit(SearchLoaded(books: books, hasReachedMax: books.length < _pageSize));
    } on AppException catch (e) {
      emit(SearchError(e.message));
    }
  }

  Future<void> _onLoadMoreRequested(LoadMoreRequested event, Emitter<SearchState> emit) async {
    final currentState = state;
    // Guards against: firing while the first page is still loading, firing
    // twice for the same page (rapid scroll-triggered dispatches), and
    // firing after the API already said "no more results."
    if (currentState is! SearchLoaded || currentState.hasReachedMax || currentState.isLoadingMore) {
      return;
    }

    emit(currentState.copyWith(isLoadingMore: true, loadMoreError: null));
    try {
      final moreBooks = await _booksRepository.searchBooks(
        query: _currentQuery,
        startIndex: currentState.books.length,
        maxResults: _pageSize,
      );
      emit(
        currentState.copyWith(
          books: [...currentState.books, ...moreBooks],
          hasReachedMax: moreBooks.length < _pageSize,
          isLoadingMore: false,
        ),
      );
    } on AppException catch (e) {
      emit(currentState.copyWith(isLoadingMore: false, loadMoreError: e.message));
    }
  }
}
