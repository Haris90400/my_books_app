import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import 'genre_chip.dart';

typedef FilterResult = ({Set<String> genres, RangeValues yearRange});

/// Represents FilterBottomSheet.
class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({
    super.key,
    required this.initialGenres,
    required this.initialYearRange,
  });

  final Set<String> initialGenres;
  final RangeValues initialYearRange;

  static const genreOptions = [
    'Fiction',
    'Non-fiction',
    'Sci-Fi',
    'Biography',
    'Mystery',
    'Fantasy',
    'Romance',
    'History',
  ];

  static Future<FilterResult?> show(
    BuildContext context, {
    required Set<String> initialGenres,
    required RangeValues initialYearRange,
  }) {
    return showModalBottomSheet<FilterResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => FilterBottomSheet(
        initialGenres: initialGenres,
        initialYearRange: initialYearRange,
      ),
    );
  }

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late Set<String> _selectedGenres = {...widget.initialGenres};
  late RangeValues _yearRange = widget.initialYearRange;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Text('Search Filter', style: AppTextStyles.titleMedium),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text('Categories', style: AppTextStyles.titleMedium),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final genre in FilterBottomSheet.genreOptions)
                  GenreChip(
                    label: genre,
                    selected: _selectedGenres.contains(genre),
                    onTap: () => setState(() {
                      _selectedGenres.contains(genre)
                          ? _selectedGenres.remove(genre)
                          : _selectedGenres.add(genre);
                    }),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            Text('Published Year', style: AppTextStyles.titleMedium),
            RangeSlider(
              min: 1950,
              max: 2025,
              divisions: 75,
              activeColor: AppColors.primary,
              inactiveColor: AppColors.textMuted.withValues(alpha: 0.3),
              labels: RangeLabels(
                _yearRange.start.round().toString(),
                _yearRange.end.round().toString(),
              ),
              values: _yearRange,
              onChanged: (values) => setState(() => _yearRange = values),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _yearRange.start.round().toString(),
                    style: AppTextStyles.bodySmall,
                  ),
                  Text(
                    _yearRange.end.round().toString(),
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _selectedGenres = {};
                        _yearRange = const RangeValues(1950, 2025);
                      });
                      Navigator.of(context).pop((genres: _selectedGenres, yearRange: _yearRange));
                    },
                    child: const Text('Clear'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(
                      context,
                    ).pop((genres: _selectedGenres, yearRange: _yearRange)),
                    child: const Text('Apply Filter'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
