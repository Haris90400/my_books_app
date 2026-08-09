import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/datasources/firebase_auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../shared/book/data/datasources/books_remote_data_source.dart';
import '../../shared/book/data/datasources/google_books_remote_data_source.dart';
import '../../shared/book/data/datasources/hive_search_history_local_data_source.dart';
import '../../shared/book/data/datasources/search_history_local_data_source.dart';
import '../../features/analytics/data/datasources/trending_books_remote_data_source.dart';
import '../../features/analytics/data/datasources/websocket_trending_books_data_source.dart';
import '../../features/book_detail/data/datasources/gemini_remote_data_source.dart';
import '../../features/book_detail/data/datasources/google_gemini_remote_data_source.dart';
import '../../features/contacts/data/datasources/contacts_data_source.dart';
import '../../features/contacts/data/datasources/flutter_contacts_data_source.dart';
import '../../shared/book/data/repositories/books_repository_impl.dart';
import '../../shared/book/domain/repositories/books_repository.dart';
import '../network/dio_client.dart';

/// The sl property.
final GetIt sl = GetIt.instance;

/// Configure dependencies.
Future<void> configureDependencies() async {
  // External SDKs — registered so nothing below constructs them directly.
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton<GoogleSignIn>(() => GoogleSignIn());
  sl.registerLazySingleton<Dio>(buildDioClient);

  final queriesBox = await Hive.openBox('search_queries_box');
  final booksBox = await Hive.openBox('cached_books_box');
  final sharedPrefs = await SharedPreferences.getInstance();

  sl.registerLazySingleton<SharedPreferences>(() => sharedPrefs);

  // Data layer
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => FirebaseAuthRemoteDataSource(
      firebaseAuth: sl(),
      googleSignIn: sl(),
    ),
  );
  sl.registerLazySingleton<BooksRemoteDataSource>(
    () => GoogleBooksRemoteDataSource(dio: sl(), apiKey: dotenv.env['GOOGLE_BOOKS_API_KEY'] ?? ''),
  );
  sl.registerLazySingleton<GeminiRemoteDataSource>(
    () => GoogleGeminiRemoteDataSource(dio: sl(), apiKey: dotenv.env['GEMINI_API_KEY'] ?? ''),
  );
  sl.registerLazySingleton<ContactsDataSource>(FlutterContactsDataSource.new);
  sl.registerLazySingleton<SearchHistoryLocalDataSource>(
    () => HiveSearchHistoryLocalDataSource(queriesBox: queriesBox, booksBox: booksBox),
  );
  // Factory, not lazy singleton: every time the Analytics tab is entered,
  // `TrendingBooksCubit` needs a FRESH connection, not a reused instance
  // whose channel may already be closed from a previous visit.
  // `wss://echo.websocket.org` (the classic public echo server) was
  // discontinued in 2024 — every connection attempt now fails the
  // WebSocket upgrade handshake. Postman's public echo endpoint is the
  // maintained equivalent: echoes back whatever raw text is sent, same
  // as the old one.
  sl.registerFactory<TrendingBooksRemoteDataSource>(
    () => WebSocketTrendingBooksDataSource(uri: Uri.parse('wss://ws.postman-echo.com/raw')),
  );

  // Domain layer (registered against the ABSTRACT type on the left —
  // this is the actual "plugging in" moment for these repositories)
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<BooksRepository>(
    () => BooksRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );
}
