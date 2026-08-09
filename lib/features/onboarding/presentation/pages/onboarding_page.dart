import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../cubit/onboarding_cubit.dart';
import '../cubit/onboarding_state.dart';

@RoutePage()
class OnboardingPage extends StatefulWidget implements AutoRouteWrapper {
  const OnboardingPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => OnboardingCubit(sharedPrefs: sl()),
      child: this,
    );
  }

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    final initialPage = context.read<OnboardingCubit>().state.currentPage;
    _pageController = PageController(initialPage: initialPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNextTap(int currentIndex) {
    if (currentIndex == 2) {
      _finishOnboarding();
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onSkipTap() {
    _finishOnboarding();
  }

  void _finishOnboarding() {
    context.read<OnboardingCubit>().completeOnboarding();
    context.router.replaceAll([const LoginRoute()]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: BlocBuilder<OnboardingCubit, OnboardingState>(
          builder: (context, state) {
            return Column(
              children: [
                // Skip Button
                Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: _onSkipTap,
                    child: Text(
                      'Skip',
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                    ),
                  ),
                ),

                // PageView
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (index) {
                      context.read<OnboardingCubit>().updatePage(index);
                    },
                    children: const [
                      _OnboardingSlide(
                        lottieAsset: 'assets/lottie/onboarding_1.json',
                        title: 'Discover Books',
                        description: 'Search by title, author, or even scan a barcode to find your next great read.',
                      ),
                      _OnboardingSlide(
                        lottieAsset: 'assets/lottie/onboarding_2.json',
                        title: 'Track Analytics',
                        description: 'Visualize your reading habits and explore trending books in real-time.',
                      ),
                      _OnboardingSlide(
                        lottieAsset: 'assets/lottie/onboarding_3.json',
                        title: 'Smart AI Summaries',
                        description: 'Get instant, AI-powered book summaries and insights using Google Gemini.',
                      ),
                    ],
                  ),
                ),

                // Bottom Controls
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Page Indicators
                      Row(
                        children: List.generate(3, (index) {
                          final isActive = state.currentPage == index;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.only(right: 8),
                            height: 8,
                            width: isActive ? 24 : 8,
                            decoration: BoxDecoration(
                              color: isActive ? AppColors.primary : AppColors.textMuted,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          );
                        }),
                      ),

                      // Next / Get Started Button
                      ElevatedButton(
                        onPressed: () => _onNextTap(state.currentPage),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(140, 52),
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        ),
                        child: Text(
                          state.currentPage == 2 ? 'Get Started' : 'Next',
                          style: AppTextStyles.titleMedium.copyWith(color: AppColors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _OnboardingSlide extends StatelessWidget {
  const _OnboardingSlide({
    required this.lottieAsset,
    required this.title,
    required this.description,
  });

  final String lottieAsset;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: Lottie.asset(
              lottieAsset,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.image_not_supported,
                size: 100,
                color: AppColors.textMuted,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Text(
                  title,
                  style: AppTextStyles.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  description,
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
