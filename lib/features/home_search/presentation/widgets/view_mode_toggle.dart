import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

enum BookViewMode { list, grid }

/// Represents ViewModeToggle.
class ViewModeToggle extends StatelessWidget {
  const ViewModeToggle({super.key, required this.mode, required this.onChanged});

  final BookViewMode mode;
  final ValueChanged<BookViewMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.textMuted.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ToggleButton(
            icon: Icons.view_list_rounded,
            isActive: mode == BookViewMode.list,
            onTap: () => onChanged(BookViewMode.list),
          ),
          _ToggleButton(
            icon: Icons.grid_view_rounded,
            isActive: mode == BookViewMode.grid,
            onTap: () => onChanged(BookViewMode.grid),
          ),
        ],
      ),
    );
  }
}

class _ToggleButton extends StatelessWidget {
  const _ToggleButton({required this.icon, required this.isActive, required this.onTap});

  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, size: 20, color: isActive ? AppColors.white : AppColors.textMuted),
      ),
    );
  }
}
