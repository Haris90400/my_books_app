import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

/// Represents SearchQuerySubmitted.
class SearchQuerySubmitted extends SearchEvent {
  const SearchQuerySubmitted(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

/// Represents LoadMoreRequested.
class LoadMoreRequested extends SearchEvent {
  const LoadMoreRequested();
}
