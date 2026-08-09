import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

typedef HistoryEntry = ({String title, String subtitle});

/// Represents StatHistoryBottomSheet.
class StatHistoryBottomSheet extends StatelessWidget {
  const StatHistoryBottomSheet({super.key, required this.icon, required this.title, required this.entries});

  final IconData icon;
  final String title;
  final List<HistoryEntry> entries;

  static Future<void> show(
    BuildContext context, {
    required IconData icon,
    required String title,
    required List<HistoryEntry> entries,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StatHistoryBottomSheet(icon: icon, title: title, entries: entries),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.35,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: AppColors.textMuted.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(2)),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(icon, color: AppColors.primary, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Text(title, style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: entries.isEmpty
                    ? Center(
                        child: Text('No history yet', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted)),
                      )
                    : ListView.separated(
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        itemCount: entries.length,
                        separatorBuilder: (_, _) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final entry = entries[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            // Column, not Row: `entry.subtitle` can be an
                            // arbitrarily long author list with nothing to
                            // wrap it — as a Row sibling that pushed the
                            // title's Expanded width to near-zero and blew
                            // up into a right-overflow. Stacked + each
                            // line's own ellipsis can't do that regardless
                            // of content length.
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  entry.title,
                                  style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w500),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (entry.subtitle.isNotEmpty) ...[
                                  const SizedBox(height: 2),
                                  Text(
                                    entry.subtitle,
                                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
