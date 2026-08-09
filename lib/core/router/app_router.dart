import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart' show Key;

import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/sign_up_page.dart';
import '../../features/analytics/presentation/pages/analytics_tab_page.dart';
import '../../features/book_detail/presentation/pages/book_cover_viewer_page.dart';
import '../../features/book_detail/presentation/pages/book_detail_page.dart';
import '../../features/home_search/presentation/pages/home_search_page.dart';
import '../../features/home_search/presentation/pages/home_tab_shell.dart';
import '../../features/home_search/presentation/pages/scanner_page.dart';
import '../../features/contacts/presentation/pages/contacts_tab_page.dart';
import '../../features/navigation/presentation/pages/dashboard_shell.dart';
import '../../features/profile/presentation/pages/photo_viewer_page.dart';
import '../../features/profile/presentation/pages/profile_tab_page.dart';
import '../../features/splash/presentation/pages/splash_screen.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../shared/book/domain/entities/book.dart';
import 'auth_guard.dart';

part 'app_router.gr.dart';

/// Represents AppRouter.
@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  AppRouter({required this.authBloc});

  final AuthBloc authBloc;

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: SplashRoute.page, initial: true),
    AutoRoute(page: OnboardingRoute.page),
    AutoRoute(page: LoginRoute.page),
    AutoRoute(page: SignUpRoute.page),
    // Top-level (not nested under DashboardRoute) on purpose: pushing
    // it should cover the whole screen, bottom nav included — a
    // photo viewer with the tab bar still showing looks wrong. No
    // AuthGuard either: only reachable by navigating from the
    // already-authenticated Profile tab.
    AutoRoute(page: PhotoViewerRoute.page),
    // Same top-level reasoning as PhotoViewerRoute — pushed from inside
    // Book Detail (itself nested two levels deep under Dashboard → Home
    // tab), still bubbles up to the root router since it's declared here,
    // not under HomeTabRoute's children.
    AutoRoute(page: BookCoverViewerRoute.page),
    AutoRoute(
      page: DashboardRoute.page,
      guards: [AuthGuard(authBloc: authBloc)],
      children: [
        AutoRoute(
          page: HomeTabRoute.page,
          path: 'home',
          children: [
            AutoRoute(page: HomeSearchRoute.page, path: '', initial: true),
            AutoRoute(page: BookDetailRoute.page, path: 'book'),
            AutoRoute(page: ScannerRoute.page, path: 'scanner'),
          ],
        ),
        AutoRoute(page: AnalyticsTabRoute.page, path: 'analytics'),
        AutoRoute(page: ContactsTabRoute.page, path: 'contacts'),
        AutoRoute(page: ProfileTabRoute.page, path: 'profile'),
      ],
    ),
  ];
}
