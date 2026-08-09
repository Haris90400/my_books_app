import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/book/domain/entities/book.dart';
import '../../../../shared/book/domain/repositories/books_repository.dart';
import '../../data/datasources/gemini_remote_data_source.dart';
import 'book_detail_event.dart';
import 'book_detail_state.dart';

/// State management for BookDetail.
class BookDetailBloc extends Bloc<BookDetailEvent, BookDetailState> {
  BookDetailBloc({required BooksRepository booksRepository, required GeminiRemoteDataSource geminiDataSource})
      : _booksRepository = booksRepository,
        _geminiDataSource = geminiDataSource,
        super(const BookDetailInitial()) {
    on<BookDetailRequested>(_onBookDetailRequested);
  }

  final BooksRepository _booksRepository;
  final GeminiRemoteDataSource _geminiDataSource;

  Future<void> _onBookDetailRequested(BookDetailRequested event, Emitter<BookDetailState> emit) async {
    emit(
      BookDetailLoaded(
        book: event.book,
        recommendedBooks: const [],
        isLoadingRecommendations: true,
        summary: null,
        isLoadingSummary: true,
        summaryFailed: false,
      ),
    );

    // `Future.wait`, not two sequential awaits: each helper below emits
    // its OWN partial update the moment IT finishes — Gemini being slow
    // never blocks recommendations from showing up, and vice versa (see
    // docs/notes/08 STEP 2).
    await Future.wait([_loadRecommendations(event.book, emit), _loadSummary(event.book, emit)]);
  }

  Future<void> _loadRecommendations(Book book, Emitter<BookDetailState> emit) async {
    try {
      // Google Books' `inauthor:` qualifier searches by author specifically
      // — a plain-text author-name query would also match books that just
      // MENTION the author.
      final query = book.authors.isEmpty ? book.title : 'inauthor:${book.authors.first}';
      final results = await _booksRepository.searchBooks(query: query, startIndex: 0, maxResults: 10);
      final recommended = results.where((b) => b.id != book.id).toList();

      final current = state;
      if (current is BookDetailLoaded) {
        emit(current.copyWith(recommendedBooks: recommended, isLoadingRecommendations: false));
      }
    } catch (_) {
      final current = state;
      if (current is BookDetailLoaded) {
        emit(current.copyWith(recommendedBooks: const [], isLoadingRecommendations: false));
      }
    }
  }

  Future<void> _loadSummary(Book book, Emitter<BookDetailState> emit) async {
    try {
      final summary = await _geminiDataSource.generateSummary(book);
      final current = state;
      if (current is BookDetailLoaded) {
        emit(current.copyWith(summary: summary, isLoadingSummary: false));
      }
    } catch (_) {
      final current = state;
      if (current is BookDetailLoaded) {
        emit(current.copyWith(isLoadingSummary: false, summaryFailed: true));
      }
    }
  }
}
