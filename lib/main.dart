import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/di/service_locator.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_state.dart';
import 'firebase_options.dart';
import 'shared/book/domain/repositories/books_repository.dart';

Future<void> main() async {
  // Required before any Firebase call — Flutter needs its own bindings
  // ready first (plugin channels, etc.) before native Firebase SDKs init.
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Real key lives only in .env (gitignored) — configureDependencies()
  // reads it via dotenv.env[...] and hands it to GoogleBooksRemoteDataSource
  // as a plain constructor param, never hardcoded in source.
  await dotenv.load(fileName: '.env');

  // Sets up Hive's on-device storage directory (via path_provider under
  // the hood) — must happen before `configureDependencies()` opens any
  // Hive boxes.
  await Hive.initFlutter();

  // Populates `sl` (the service locator) — after this line, `sl<AuthRepository>()`
  // resolves to a real AuthRepositoryImpl backed by real Firebase, and
  // `sl<BooksRepository>()` to Google Books API + Hive.
  await configureDependencies();

  runApp(const BooksDiscoveryApp());
}

class BooksDiscoveryApp extends StatefulWidget {
  const BooksDiscoveryApp({super.key});

  @override
  State<BooksDiscoveryApp> createState() => _BooksDiscoveryAppState();
}

class _BooksDiscoveryAppState extends State<BooksDiscoveryApp> {
  // Built once in initState, not inside build() — MaterialApp.router
  // would lose all navigation state if a rebuild recreated either of
  // these (a brand new AppRouter has no memory of where the user was).
  late final AuthBloc _authBloc;
  late final AppRouter _appRouter;
  late final StreamSubscription<AuthState> _authSubscription;

  @override
  void initState() {
    super.initState();

    _authBloc = AuthBloc(authRepository: sl<AuthRepository>());
    // AuthGuard needs a direct reference to the Bloc (not `context.read`,
    // since guards can run before there's a BuildContext to read from).
    _appRouter = AppRouter(authBloc: _authBloc);
    _authSubscription = _authBloc.stream.listen((state) {
      if (state is AuthUnauthenticated) {
        sl<BooksRepository>().clearLocalData();
      }
    });
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    _authBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>.value(
      value: _authBloc,
      child: MaterialApp.router(
        title: 'Books Discovery App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        routerConfig: _appRouter.config(),
      ),
    );
  }
}
