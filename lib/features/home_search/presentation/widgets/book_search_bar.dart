import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Represents BookSearchBar.
class BookSearchBar extends StatelessWidget {
  const BookSearchBar({
    super.key,
    required this.controller,
    required this.onSubmitted,
    required this.onFilterTap,
  });

  final TextEditingController controller;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onFilterTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            textInputAction: TextInputAction.search,
            minLines: 1,
            maxLines: 4,
            onSubmitted: onSubmitted,
            style: AppTextStyles.bodyMedium,
            decoration: InputDecoration(
              hintText: 'Search title, author, or keyword',
              hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted),
              prefixIcon: const Icon(Icons.search, color: AppColors.textMuted),
              suffixIcon: ValueListenableBuilder<TextEditingValue>(
                valueListenable: controller,
                builder: (context, value, child) {
                  if (value.text.isEmpty) return const SizedBox.shrink();
                  return IconButton(
                    icon: const Icon(Icons.close, color: AppColors.textMuted),
                    onPressed: () {
                      controller.clear();
                      onSubmitted(''); 
                    },
                  );
                },
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: IconButton(
            icon: const Icon(Icons.tune_rounded, color: AppColors.primary),
            onPressed: onFilterTap,
          ),
        ),
      ],
    );
  }
}
