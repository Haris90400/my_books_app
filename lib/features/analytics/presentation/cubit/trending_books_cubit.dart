import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/book/domain/entities/book.dart';
import '../../data/datasources/trending_books_remote_data_source.dart';

abstract class TrendingBooksState extends Equatable {
  const TrendingBooksState();

  @override
  List<Object?> get props => [];
}

class TrendingInitial extends TrendingBooksState {
  const TrendingInitial();
}

class TrendingConnecting extends TrendingBooksState {
  const TrendingConnecting();
}

class TrendingUpdated extends TrendingBooksState {
  const TrendingUpdated(this.books);

  final List<Book> books;

  @override
  List<Object?> get props => [books];
}

class TrendingError extends TrendingBooksState {
  const TrendingError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

/// State management for TrendingBooks.
class TrendingBooksCubit extends Cubit<TrendingBooksState> {
  TrendingBooksCubit({required TrendingBooksRemoteDataSource dataSource})
      : _dataSource = dataSource,
        super(const TrendingInitial());

  final TrendingBooksRemoteDataSource _dataSource;
  StreamSubscription<Book>? _subscription;
  final List<Book> _books = [];

  static const _maxBooks = 6;
  static const _reconnectDelay = Duration(seconds: 3);

  Future<void> connect() async {
    emit(const TrendingConnecting());
    await _subscription?.cancel();
    _subscription = _dataSource.connect().listen(_onBookReceived, onError: _onError);
  }

  void _onBookReceived(Book book) {
    _books.insert(0, book);
    if (_books.length > _maxBooks) {
      _books.removeRange(_maxBooks, _books.length);
    }
    emit(TrendingUpdated(List.unmodifiable(_books)));
  }

  void _onError(Object _) {
    emit(const TrendingError('Live connection lost — retrying…'));
    Future.delayed(_reconnectDelay, () {
      if (!isClosed) connect();
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    _dataSource.disconnect();
    return super.close();
  }
}
