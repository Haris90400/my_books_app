import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/book/domain/entities/book.dart';
import '../../../../shared/book/domain/repositories/books_repository.dart';
import '../bloc/search_bloc.dart';
import '../bloc/search_event.dart';
import '../bloc/search_state.dart';
import '../widgets/book_grid_tile.dart';
import '../widgets/book_grid_tile_skeleton.dart';
import '../widgets/book_list_tile.dart';
import '../widgets/book_list_tile_skeleton.dart';
import '../widgets/book_search_bar.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../widgets/quick_scan_actions.dart';
import '../widgets/search_state_message.dart';
import '../widgets/view_mode_toggle.dart';
import '../utils/ocr_helper.dart';

const _gridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
  crossAxisCount: 3,
  mainAxisSpacing: 16,
  crossAxisSpacing: 12,
  childAspectRatio: 0.58,
);

/// Main UI for the HomeSearch screen.
@RoutePage(name: 'HomeSearchRoute')
class HomeSearchPage extends StatelessWidget {
  const HomeSearchPage({super.key});

  /// The _default query property.
  static const _defaultQuery = 'bestseller';

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchBloc>(
      create: (_) => SearchBloc(booksRepository: sl<BooksRepository>())
        ..add(const SearchQuerySubmitted(_defaultQuery)),
      child: const _HomeSearchView(),
    );
  }
}

class _HomeSearchView extends StatefulWidget {
  const _HomeSearchView();

  @override
  State<_HomeSearchView> createState() => _HomeSearchViewState();
}

class _HomeSearchViewState extends State<_HomeSearchView> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();

  BookViewMode _viewMode = BookViewMode.list;
  Set<String> _selectedGenres = {};
  RangeValues _yearRange = const RangeValues(1950, 2025);
  String _lastQuery = HomeSearchPage._defaultQuery;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final nearBottom =
        _scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 300;
    if (nearBottom) {
      context.read<SearchBloc>().add(const LoadMoreRequested());
    }
  }

  void _onSubmitted(String query) {
    final trimmed = query.trim();
    _lastQuery = trimmed.isEmpty ? HomeSearchPage._defaultQuery : trimmed;
    context.read<SearchBloc>().add(SearchQuerySubmitted(_lastQuery));
  }

  Future<void> _onFilterTap() async {
    final result = await FilterBottomSheet.show(
      context,
      initialGenres: _selectedGenres,
      initialYearRange: _yearRange,
    );
    if (result == null) return;
    setState(() {
      _selectedGenres = result.genres;
      _yearRange = result.yearRange;
    });
  }

  Future<void> _onScanTap() async {
    final result = await context.router.push(const ScannerRoute());
    if (result != null && result is String && result.trim().isNotEmpty) {
      _searchController.text = result.trim();
      _onSubmitted(result.trim());
    }
  }

  Future<void> _onCameraTap() async {
    final text = await OcrHelper.scanBookCover();
    if (text != null && text.trim().isNotEmpty) {
      _searchController.text = text.trim();
      if (mounted) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(const SnackBar(
              content: Text('Text extracted! Edit before searching if needed.')));
      }
    }
  }

  /// Creates _applyFilters instance.
  List<Book> _applyFilters(List<Book> books) {
    return books.where((book) {
      final matchesGenre = _selectedGenres.isEmpty ||
          _selectedGenres.any(
            (genre) => book.categories.any((c) => c.toLowerCase().contains(genre.toLowerCase())),
          );
      final year = book.publishedYear;
      final matchesYear = year == null || (year >= _yearRange.start && year <= _yearRange.end);
      return matchesGenre && matchesYear;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Full-width gradient band (no horizontal padding, unlike the
        // rest of this screen) — same treatment as Profile's header, for
        // visual consistency between the two "identity" screens of the
        // app. Search bar sits inside it (not below), so it reads as
        // this screen's primary action, the way Profile's avatar does.
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.primary, AppColors.primary.withValues(alpha: 0.75)],
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(32),
              bottomRight: Radius.circular(32),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Discover Books',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppColors.white),
              ),
              const SizedBox(height: 16),
              BookSearchBar(controller: _searchController, onSubmitted: _onSubmitted, onFilterTap: _onFilterTap),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: QuickScanActions(
            onScanTap: _onScanTap,
            onCameraTap: _onCameraTap,
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Popular right now', style: Theme.of(context).textTheme.titleLarge),
              ViewModeToggle(mode: _viewMode, onChanged: (mode) => setState(() => _viewMode = mode)),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) => _buildBody(state),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBody(SearchState state) {
    if (state is SearchInitial || state is SearchLoading) {
      return _buildSkeleton();
    }

    if (state is SearchError) {
      return SearchStateMessage(
        icon: Icons.error_outline_rounded,
        title: 'Something went wrong',
        subtitle: state.message,
      );
    }

    final loaded = state as SearchLoaded;
    final results = _applyFilters(loaded.books);

    if (results.isEmpty) {
      return const SearchStateMessage(
        icon: Icons.search_off_rounded,
        title: 'No books found',
        subtitle: 'Try a different title, keyword, or filter.',
      );
    }

    // One CustomScrollView for both view modes, not two separate
    // ListView/GridView widgets each needing their own footer logic —
    // that duplication is exactly how the grid pagination footer got
    // missed the first time.
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        if (_viewMode == BookViewMode.list)
          SliverList.separated(
            itemCount: results.length,
            separatorBuilder: (_, _) => const Divider(height: 1, color: AppColors.textMuted),
            itemBuilder: (context, index) {
              final book = results[index];
              return BookListTile(
                title: book.title,
                authors: book.authorsLabel,
                publisher: book.publisher,
                coverUrl: book.thumbnailUrl,
                heroTag: 'book-cover-${book.id}',
                onTap: () => context.router.push(BookDetailRoute(book: book)),
              );
            },
          )
        else
          SliverGrid(
            gridDelegate: _gridDelegate,
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final book = results[index];
                return BookGridTile(
                  title: book.title,
                  authors: book.authorsLabel,
                  coverUrl: book.thumbnailUrl,
                  heroTag: 'book-cover-${book.id}',
                  onTap: () => context.router.push(BookDetailRoute(book: book)),
                );
              },
              childCount: results.length,
            ),
          ),
        SliverToBoxAdapter(child: _paginationFooter(loaded)),
      ],
    );
  }

  Widget _buildSkeleton() {
    return Shimmer.fromColors(
      baseColor: AppColors.textMuted.withValues(alpha: 0.25),
      highlightColor: AppColors.white,
      child: _viewMode == BookViewMode.list
          ? ListView.separated(
              itemCount: 6,
              separatorBuilder: (_, _) => const Divider(height: 1, color: AppColors.textMuted),
              itemBuilder: (_, _) => const BookListTileSkeleton(),
            )
          : GridView.builder(
              itemCount: 6,
              gridDelegate: _gridDelegate,
              itemBuilder: (_, _) => const BookGridTileSkeleton(),
            ),
    );
  }

  Widget _paginationFooter(SearchLoaded loaded) {
    if (loaded.loadMoreError != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: TextButton.icon(
            onPressed: () => context.read<SearchBloc>().add(const LoadMoreRequested()),
            icon: const Icon(Icons.refresh_rounded, size: 18, color: AppColors.error),
            label: const Text(
              "Couldn't load more — tap to retry",
              style: TextStyle(color: AppColors.error, fontSize: 12),
            ),
          ),
        ),
      );
    }

    if (loaded.isLoadingMore) {
      return Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Shimmer.fromColors(
          baseColor: AppColors.textMuted.withValues(alpha: 0.25),
          highlightColor: AppColors.white,
          child: _viewMode == BookViewMode.list
              ? const Column(children: [BookListTileSkeleton(), BookListTileSkeleton()])
              : GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 3,
                  gridDelegate: _gridDelegate,
                  itemBuilder: (_, _) => const BookGridTileSkeleton(),
                ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
