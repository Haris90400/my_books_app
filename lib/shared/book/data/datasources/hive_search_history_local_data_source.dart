import 'package:hive/hive.dart';

import '../models/book_model.dart';
import 'search_history_local_data_source.dart';

/// Remote/Local data source for HiveSearchHistoryLocal.
class HiveSearchHistoryLocalDataSource implements SearchHistoryLocalDataSource {
  HiveSearchHistoryLocalDataSource({
    required Box<dynamic> queriesBox,
    required Box<dynamic> booksBox,
  })  : _queriesBox = queriesBox,
        _booksBox = booksBox;

  final Box<dynamic> _queriesBox;
  final Box<dynamic> _booksBox;

  static const _queriesKey = 'recent_queries';
  static const _maxRecentQueries = 20;

  @override
  Future<void> cacheSearchResults({required String query, required List<BookModel> books}) async {
    await _saveQuery(query);
    await _saveBooks(books);
  }

  Future<void> _saveQuery(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;

    final existing = (_queriesBox.get(_queriesKey) as List?)?.cast<String>().toList() ?? <String>[];
    existing
      ..remove(trimmed) // avoid a duplicate entry if it's already there
      ..insert(0, trimmed); // most-recent-first
    if (existing.length > _maxRecentQueries) {
      existing.removeRange(_maxRecentQueries, existing.length);
    }

    await _queriesBox.put(_queriesKey, existing);
  }

  Future<void> _saveBooks(List<BookModel> books) async {
    for (final book in books) {
      await _booksBox.put(book.id, book.toCacheJson());
    }
  }

  @override
  Future<void> clearAll() async {
    await Future.wait([_queriesBox.clear(), _booksBox.clear()]);
  }

  @override
  Future<List<BookModel>> getAllCachedBooks() async {
    return _booksBox.values.map((json) => BookModel.fromCacheJson(json as Map<dynamic, dynamic>)).toList();
  }

  @override
  Future<List<String>> getRecentSearchQueries() async {
    return (_queriesBox.get(_queriesKey) as List?)?.cast<String>().toList() ?? <String>[];
  }
}
