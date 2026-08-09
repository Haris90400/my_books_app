import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/router/app_router.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../widgets/app_bottom_nav_bar.dart';

/// Represents DashboardShell.
@RoutePage(name: 'DashboardRoute')
class DashboardShell extends StatelessWidget {
  const DashboardShell({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          context.router.replaceAll([const LoginRoute()]);
        }
      },
      child: AutoTabsRouter(
        routes: const [
          HomeTabRoute(),
          AnalyticsTabRoute(),
          ContactsTabRoute(),
          ProfileTabRoute(),
        ],
        builder: (context, child) {
          final tabsRouter = AutoTabsRouter.of(context);
          return Scaffold(
            body: SafeArea(child: child),
            bottomNavigationBar: AppBottomNavBar(
              currentIndex: tabsRouter.activeIndex,
              onTap: tabsRouter.setActiveIndex,
            ),
          );
        },
      ),
    );
  }
}
