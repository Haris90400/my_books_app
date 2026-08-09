import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:my_books_app/core/router/app_router.dart';
import 'package:my_books_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:my_books_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:my_books_app/features/auth/presentation/pages/login_page.dart';
import 'package:my_books_app/shared/user/domain/entities/app_user.dart';

/// Proves the point of the whole Repository abstraction: AuthBloc's
/// navigation behavior is tested here without a single real Firebase
/// call, by plugging in this fake instead of AuthRepositoryImpl.
class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({this.signedInUser});

  final AppUser? signedInUser;

  @override
  Stream<AppUser?> get authStateChanges => Stream.value(signedInUser);

  @override
  Future<AppUser> signInWithEmail({required String email, required String password}) =>
      throw UnimplementedError();

  @override
  Future<AppUser> signUpWithEmail({required String email, required String password, required String name}) =>
      throw UnimplementedError();

  @override
  Future<AppUser> signInWithGoogle() => throw UnimplementedError();

  @override
  Future<void> sendPasswordResetEmail({required String email}) => throw UnimplementedError();

  @override
  Future<void> signOut() => throw UnimplementedError();

  @override
  Future<AppUser> updateDisplayName(String name) => throw UnimplementedError();

  @override
  Future<AppUser> updateProfilePhoto(File photoFile) => throw UnimplementedError();
}

void main() {
  testWidgets('Splash navigates to LoginPage when no session exists', (tester) async {
    final fakeRepository = FakeAuthRepository(signedInUser: null);
    // No manual `.add(AppStarted())` — SplashScreen dispatches it itself
    // from its own initState now, which is exactly the bug this test
    // originally caught (see SplashScreen's doc comment).
    final authBloc = AuthBloc(authRepository: fakeRepository);
    final appRouter = AppRouter(authBloc: authBloc);
    addTearDown(authBloc.close);

    await tester.pumpWidget(
      BlocProvider<AuthBloc>.value(
        value: authBloc,
        child: MaterialApp.router(routerConfig: appRouter.config()),
      ),
    );

    // AutoRoute's router needs a frame to resolve the initial route before
    // anything renders — unlike plain MaterialApp(home: ...), which shows
    // its child on the very first frame.
    await tester.pump();
    expect(find.text('Books Discovery'), findsOneWidget);

    // Not pumpAndSettle(): SplashScreen's CircularProgressIndicator
    // animates forever, so "settle" would never happen. Explicit pumps:
    // one for AuthLoading, one for AuthUnauthenticated + the listener's
    // navigation call, one bounded pump for the route-transition animation.
    await tester.pump();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byType(LoginPage), findsOneWidget);
    expect(find.text('Log In'), findsWidgets); // title + button both say "Log In"
  });
}
