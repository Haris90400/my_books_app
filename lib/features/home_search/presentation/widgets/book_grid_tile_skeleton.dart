import 'package:flutter/material.dart';

import 'shimmer_box.dart';

/// Represents BookGridTileSkeleton.
class BookGridTileSkeleton extends StatelessWidget {
  const BookGridTileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Expanded(child: ShimmerBox(width: double.infinity, height: double.infinity, borderRadius: 12)),
        const SizedBox(height: 6),
        const ShimmerBox(width: double.infinity, height: 12),
        const SizedBox(height: 4),
        const ShimmerBox(width: 40, height: 10),
      ],
    );
  }
}
