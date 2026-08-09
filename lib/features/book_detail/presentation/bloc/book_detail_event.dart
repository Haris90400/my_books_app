import 'package:equatable/equatable.dart';

import '../../../../shared/book/domain/entities/book.dart';

abstract class BookDetailEvent extends Equatable {
  const BookDetailEvent();

  @override
  List<Object?> get props => [];
}

/// Represents BookDetailRequested.
class BookDetailRequested extends BookDetailEvent {
  const BookDetailRequested(this.book);

  final Book book;

  @override
  List<Object?> get props => [book];
}
