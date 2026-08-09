import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/book/domain/repositories/books_repository.dart';
import '../../data/datasources/trending_books_remote_data_source.dart';
import '../bloc/analytics_bloc.dart';
import '../bloc/analytics_event.dart';
import '../bloc/analytics_state.dart';
import '../cubit/trending_books_cubit.dart';
import '../widgets/engagement_stats_row.dart';
import '../widgets/genre_donut_chart.dart';
import '../widgets/publishing_trend_chart.dart';
import '../widgets/trending_books_carousel.dart';

/// Main UI for the AnalyticsTab screen.
@RoutePage(name: 'AnalyticsTabRoute')
class AnalyticsTabPage extends StatelessWidget {
  const AnalyticsTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AnalyticsBloc>(
          create: (_) =>
              AnalyticsBloc(booksRepository: sl<BooksRepository>())
                ..add(const AnalyticsRequested()),
        ),
        BlocProvider<TrendingBooksCubit>(
          create: (_) => TrendingBooksCubit(
            dataSource: sl<TrendingBooksRemoteDataSource>(),
          )..connect(),
        ),
      ],
      child: const _AnalyticsTabView(),
    );
  }
}

class _AnalyticsTabView extends StatelessWidget {
  const _AnalyticsTabView();

  /// Creates _onRefresh instance.
  Future<void> _onRefresh(BuildContext context) {
    final bloc = context.read<AnalyticsBloc>();
    bloc.add(const AnalyticsRequested());
    return bloc.stream.firstWhere(
      (state) => state is AnalyticsLoaded || state is AnalyticsError,
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => _onRefresh(context),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary,
                    AppColors.primary.withValues(alpha: 0.75),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Analytics',
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(color: AppColors.white),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Your reading insights',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.white.withValues(alpha: 0.85),
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () => _onRefresh(context),
                    icon: const Icon(
                      Icons.refresh_rounded,
                      color: AppColors.white,
                    ),
                    tooltip: 'Refresh',
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: BlocBuilder<AnalyticsBloc, AnalyticsState>(
                builder: (context, state) {
                  if (state is AnalyticsLoading || state is AnalyticsInitial) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 60),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  if (state is AnalyticsError) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Column(
                        children: [
                          Text(
                            state.message,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textMuted,
                            ),
                          ),
                          const SizedBox(height: 12),
                          OutlinedButton(
                            onPressed: () => context.read<AnalyticsBloc>().add(
                              const AnalyticsRequested(),
                            ),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  final loaded = state as AnalyticsLoaded;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      EngagementStatsRow(
                        totalSearches: loaded.totalSearches,
                        booksDiscovered: loaded.booksDiscovered,
                        topGenre: loaded.topGenre,
                        searchQueries: loaded.searchQueries,
                        cachedBooks: loaded.cachedBooks,
                        genreDistribution: loaded.genreDistribution,
                      ),
                      const SizedBox(height: 28),
                      _SectionCard(
                        title: 'Genre Distribution',
                        child: GenreDonutChart(
                          slices: loaded.genreDistribution,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _SectionCard(
                        title: 'Publishing Trend',
                        child: SizedBox(
                          height: 180,
                          child: PublishingTrendChart(
                            buckets: loaded.publishingTrend,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _SectionCard(
                        title: 'Trending Books',
                        child:
                            BlocBuilder<TrendingBooksCubit, TrendingBooksState>(
                              builder: (context, trendingState) {
                                return TrendingBooksCarousel(
                                  books: trendingState is TrendingUpdated
                                      ? trendingState.books
                                      : const [],
                                  isLive: trendingState is TrendingUpdated,
                                );
                              },
                            ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}
