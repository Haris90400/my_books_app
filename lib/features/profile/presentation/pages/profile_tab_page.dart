import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/user/domain/entities/app_user.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../widgets/editable_name_field.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_info_tile.dart';
import '../widgets/profile_update_success_overlay.dart';

/// Main UI for the ProfileTab screen.
@RoutePage(name: 'ProfileTabRoute')
class ProfileTabPage extends StatelessWidget {
  const ProfileTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _ProfileTabView();
  }
}

class _ProfileTabView extends StatefulWidget {
  const _ProfileTabView();

  @override
  State<_ProfileTabView> createState() => _ProfileTabViewState();
}

class _ProfileTabViewState extends State<_ProfileTabView> {
  final _imagePicker = ImagePicker();

  /// The _is saving name property.
  bool _isSavingName = false;
  bool _isUpdatingPhoto = false;

  bool get _hasPendingUpdate => _isSavingName || _isUpdatingPhoto;

  /// Setup required properties.
  AppUser? _cachedUser;

  Future<void> _onEditPhotoTap(BuildContext context) async {
    final status = await Permission.photos.request();

    if (status.isPermanentlyDenied) {
      if (!context.mounted) return;
      await _showPermissionDeniedDialog(context);
      return;
    }
    if (!status.isGranted) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text('Gallery access is needed to update your profile picture.')));
      return;
    }

    final picked = await _imagePicker.pickImage(source: ImageSource.gallery, imageQuality: 80, maxWidth: 800);
    if (picked == null || !context.mounted) return; // user closed the picker without choosing

    setState(() => _isUpdatingPhoto = true);
    context.read<AuthBloc>().add(ProfilePhotoUpdateRequested(File(picked.path)));
  }

  Future<void> _showPermissionDeniedDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Permission needed'),
        content: const Text('Gallery access was denied. Enable it from Settings to update your profile picture.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  void _onSaveName(BuildContext context, String name) {
    setState(() => _isSavingName = true);
    context.read<AuthBloc>().add(ProfileNameUpdateRequested(name));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (!_hasPendingUpdate) return; // an unrelated AuthBloc transition — not ours to react to

        if (state is AuthAuthenticated) {
          // Photo is always re-saved to the SAME on-disk path
          // (`profile_{uid}.ext`) — Flutter's image cache keys `FileImage`
          // by that path alone, not by file content/mtime, so it kept
          // serving the old decoded bytes for an unchanged path string
          // until the app restarted and the cache cleared. Evicting the
          // path here forces the next `FileImage`/`Image.file` build to
          // re-read from disk instead of trusting the stale cache entry.
          if (_isUpdatingPhoto) {
            final photoPath = state.user.photoUrl;
            if (photoPath != null && !photoPath.startsWith('http')) {
              FileImage(File(photoPath)).evict();
            }
          }
          setState(() {
            _isSavingName = false;
            _isUpdatingPhoto = false;
          });
          ProfileUpdateSuccessOverlay.show(context);
        } else if (state is AuthError) {
          setState(() {
            _isSavingName = false;
            _isUpdatingPhoto = false;
          });
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(state.message), backgroundColor: AppColors.error));
        }
      },
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          _cachedUser = state.user;
        }
        final user = _cachedUser;

        return SingleChildScrollView(
          child: Column(
            children: [
              ProfileHeader(
                photoPath: user?.photoUrl,
                name: user?.displayName,
                onAvatarTap: () => context.router.push(PhotoViewerRoute(photoPath: user?.photoUrl)),
                onEditTap: _isUpdatingPhoto ? () {} : () => _onEditPhotoTap(context),
                isUpdating: _isUpdatingPhoto,
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: EditableNameField(
                  name: user?.displayName ?? 'Unknown',
                  isSaving: _isSavingName,
                  onSave: (name) => _onSaveName(context, name),
                ),
              ),
              const SizedBox(height: 28),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ACCOUNT',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textMuted,
                        letterSpacing: 0.8,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ProfileInfoTile(icon: Icons.email_outlined, label: 'Email', value: user?.email ?? '—'),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => context.read<AuthBloc>().add(const LogoutRequested()),
                        icon: const Icon(Icons.logout_rounded, color: AppColors.error),
                        label: const Text('Log Out', style: TextStyle(color: AppColors.error)),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(52),
                          side: const BorderSide(color: AppColors.error),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
