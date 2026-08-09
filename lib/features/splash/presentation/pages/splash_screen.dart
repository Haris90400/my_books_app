import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';

/// Main UI for the Splash screen.
@RoutePage(name: 'SplashRoute')
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(const AppStarted());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          context.router.replaceAll([const DashboardRoute()]);
        } else if (state is AuthUnauthenticated || state is AuthError) {
          final sharedPrefs = sl<SharedPreferences>();
          final onboardingCompleted = sharedPrefs.getBool('onboarding_completed') ?? false;

          if (onboardingCompleted) {
            context.router.replaceAll([const LoginRoute()]);
          } else {
            context.router.replaceAll([const OnboardingRoute()]);
          }
        }
        // AuthInitial / AuthLoading: stay on this screen.
      },
      child: const _SplashScreenBody(),
    );
  }
}

class _SplashScreenBody extends StatelessWidget {
  const _SplashScreenBody();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(
                  Icons.auto_stories_rounded,
                  color: AppColors.white,
                  size: 48,
                ),
              ),
              const SizedBox(height: 24),
              Text('Books Discovery', style: textTheme.headlineMedium),
              const SizedBox(height: 4),
              Text(
                'Find your next great read',
                style: textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 48),
              const SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
