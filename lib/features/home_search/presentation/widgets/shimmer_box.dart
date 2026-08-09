import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Represents ShimmerBox.
class ShimmerBox extends StatelessWidget {
  const ShimmerBox({super.key, required this.width, required this.height, this.borderRadius = 6});

  final double width;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.textMuted.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: SizedBox(width: width, height: height),
    );
  }
}
