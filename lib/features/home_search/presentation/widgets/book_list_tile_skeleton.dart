import 'package:flutter/material.dart';

import 'shimmer_box.dart';

/// Represents BookListTileSkeleton.
class BookListTileSkeleton extends StatelessWidget {
  const BookListTileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ShimmerBox(width: 56, height: 76, borderRadius: 12),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ShimmerBox(width: double.infinity, height: 14),
                const SizedBox(height: 8),
                SizedBox(width: MediaQuery.of(context).size.width * 0.4, child: const ShimmerBox(width: double.infinity, height: 12)),
                const SizedBox(height: 6),
                SizedBox(width: MediaQuery.of(context).size.width * 0.3, child: const ShimmerBox(width: double.infinity, height: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
