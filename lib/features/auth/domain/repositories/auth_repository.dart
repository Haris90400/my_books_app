import 'dart:io';

import '../../../../shared/user/domain/entities/app_user.dart';

/// Handles data operations for Auth.
abstract class AuthRepository {
  /// Setup required properties.
  Stream<AppUser?> get authStateChanges;

  Future<AppUser> signInWithEmail({required String email, required String password});

  Future<AppUser> signUpWithEmail({
    required String email,
    required String password,
    required String name,
  });

  Future<AppUser> signInWithGoogle();

  Future<void> sendPasswordResetEmail({required String email});

  Future<void> signOut();

  /// Update display name.
  Future<AppUser> updateDisplayName(String name);

  Future<AppUser> updateProfilePhoto(File photoFile);
}
