import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import 'profile_avatar.dart';

/// Represents ProfileHeader.
class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.photoPath,
    this.name,
    required this.onAvatarTap,
    required this.onEditTap,
    this.isUpdating = false,
  });

  final String? photoPath;
  final String? name;
  final VoidCallback onAvatarTap;
  final VoidCallback onEditTap;
  final bool isUpdating;

  static const _avatarSize = 104.0;
  static const _bandHeight = 148.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _bandHeight + (_avatarSize / 2),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            height: _bandHeight,
            width: double.infinity,
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
          ),
          Positioned(
            top: _bandHeight - (_avatarSize / 1.8),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(color: AppColors.white, shape: BoxShape.circle),
              child: ProfileAvatar(
                photoPath: photoPath,
                name: name,
                onTap: onAvatarTap,
                onEditTap: onEditTap,
                isUpdating: isUpdating,
                size: _avatarSize,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
