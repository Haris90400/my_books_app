import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Represents ProfileAvatar.
class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    super.key,
    required this.photoPath,
    this.name,
    required this.onTap,
    required this.onEditTap,
    this.isUpdating = false,
    this.size = 96,
  });

  final String? photoPath;
  final String? name;
  final VoidCallback onTap;
  final VoidCallback onEditTap;

  /// The is updating property.
  final bool isUpdating;
  final double size;

  bool get _isNetworkUrl => photoPath != null && photoPath!.startsWith('http');
  bool get _localFileExists => photoPath != null && !_isNetworkUrl && File(photoPath!).existsSync();
  bool get _hasValidImage => _isNetworkUrl || _localFileExists;

  String _getInitials(String? name) {
    if (name == null || name.trim().isEmpty) return '?';
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length > 1) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          GestureDetector(
            onTap: onTap,
            child: Hero(
              tag: 'profile-avatar',
              child: CircleAvatar(
                radius: size / 2,
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                backgroundImage: _hasValidImage
                    ? (_isNetworkUrl ? NetworkImage(photoPath!) : FileImage(File(photoPath!))) as ImageProvider
                    : null,
                child: !_hasValidImage
                    ? Text(
                        _getInitials(name),
                        style: TextStyle(
                          fontSize: size * 0.35,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      )
                    : null,
              ),
            ),
          ),
          Positioned(
            bottom: -2,
            right: -2,
            child: InkWell(
              onTap: isUpdating ? null : onEditTap,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.white, width: 2),
                ),
                child: isUpdating
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.white),
                      )
                    : const Icon(Icons.camera_alt_rounded, size: 16, color: AppColors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
