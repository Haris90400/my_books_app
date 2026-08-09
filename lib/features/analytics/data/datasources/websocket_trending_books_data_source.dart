import 'dart:async';
import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../../shared/book/data/models/book_model.dart';
import '../../../../shared/book/domain/entities/book.dart';
import 'trending_books_remote_data_source.dart';

/// Remote/Local data source for WebSocketTrendingBooks.
class WebSocketTrendingBooksDataSource implements TrendingBooksRemoteDataSource {
  WebSocketTrendingBooksDataSource({required this.uri});

  final Uri uri;

  WebSocketChannel? _channel;
  Timer? _sendTimer;
  int _cursor = 0;

  static const _sampleBooks = <BookModel>[
    BookModel(id: 'trend-1', title: 'Atomic Habits', authors: ['James Clear'], categories: ['Self-help']),
    BookModel(id: 'trend-2', title: 'Project Hail Mary', authors: ['Andy Weir'], categories: ['Science Fiction']),
    BookModel(id: 'trend-3', title: 'Dune', authors: ['Frank Herbert'], categories: ['Science Fiction']),
    BookModel(id: 'trend-4', title: 'Steve Jobs', authors: ['Walter Isaacson'], categories: ['Biography']),
    BookModel(id: 'trend-5', title: 'Sapiens', authors: ['Yuval Noah Harari'], categories: ['History']),
  ];

  @override
  Stream<Book> connect() {
    final channel = WebSocketChannel.connect(uri);
    _channel = channel;
    _cursor = 0;

    // First update arrives almost immediately, then one every 4s —
    // fast enough to feel "live" in a demo without spamming the socket.
    _sendTimer = Timer.periodic(const Duration(seconds: 4), (_) => _sendNextSample());
    _sendNextSample();

    return channel.stream.map((raw) => BookModel.fromCacheJson(jsonDecode(raw as String) as Map<dynamic, dynamic>));
  }

  void _sendNextSample() {
    final book = _sampleBooks[_cursor % _sampleBooks.length];
    _cursor++;
    _channel?.sink.add(jsonEncode(book.toCacheJson()));
  }

  @override
  Future<void> disconnect() async {
    _sendTimer?.cancel();
    _sendTimer = null;
    await _channel?.sink.close();
    _channel = null;
  }
}
