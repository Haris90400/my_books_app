import 'package:flutter/material.dart';

import '../../../../shared/book/domain/entities/book.dart';
import '../bloc/analytics_state.dart' show GenreSlice;
import 'stat_card.dart';
import 'stat_history_bottom_sheet.dart';

/// Represents EngagementStatsRow.
class EngagementStatsRow extends StatelessWidget {
  const EngagementStatsRow({
    super.key,
    required this.totalSearches,
    required this.booksDiscovered,
    required this.topGenre,
    required this.searchQueries,
    required this.cachedBooks,
    required this.genreDistribution,
  });

  final int totalSearches;
  final int booksDiscovered;
  final String topGenre;
  final List<String> searchQueries;
  final List<Book> cachedBooks;
  final List<GenreSlice> genreDistribution;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: StatCard(
            icon: Icons.search_rounded,
            value: '$totalSearches',
            label: 'Searches',
            onTap: () => StatHistoryBottomSheet.show(
              context,
              icon: Icons.search_rounded,
              title: 'Search History',
              entries: [for (final query in searchQueries) (title: query, subtitle: '')],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: StatCard(
            icon: Icons.menu_book_rounded,
            value: '$booksDiscovered',
            label: 'Books Found',
            onTap: () => StatHistoryBottomSheet.show(
              context,
              icon: Icons.menu_book_rounded,
              title: 'Books Discovered',
              entries: [for (final book in cachedBooks) (title: book.title, subtitle: book.authorsLabel)],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: StatCard(
            icon: Icons.local_fire_department_rounded,
            value: topGenre,
            label: 'Top Genre',
            onTap: () => StatHistoryBottomSheet.show(
              context,
              icon: Icons.local_fire_department_rounded,
              title: 'Genre Breakdown',
              entries: [for (final slice in genreDistribution) (title: slice.genre, subtitle: '${slice.count} books')],
            ),
          ),
        ),
      ],
    );
  }
}
