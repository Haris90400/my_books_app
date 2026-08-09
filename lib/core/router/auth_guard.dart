import 'package:auto_route/auto_route.dart';

import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_state.dart';
import 'app_router.dart';

/// Represents AuthGuard.
class AuthGuard extends AutoRouteGuard {
  AuthGuard({required this.authBloc});

  final AuthBloc authBloc;

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final isAuthenticated = authBloc.state is AuthAuthenticated;
    if (isAuthenticated) {
      resolver.next(true);
    } else {
      resolver.next(false);
      router.push(const LoginRoute());
    }
  }
}
