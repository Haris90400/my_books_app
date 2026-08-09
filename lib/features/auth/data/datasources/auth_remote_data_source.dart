import 'dart:io';


import '../models/user_model.dart';

/// Remote/Local data source for AuthRemote.
abstract class AuthRemoteDataSource {
  Stream<UserModel?> get authStateChanges;

  Future<UserModel> signInWithEmail({required String email, required String password});

  Future<UserModel> signUpWithEmail({
    required String email,
    required String password,
    required String name,
  });

  Future<UserModel> updateDisplayName(String name);

  Future<UserModel> updateProfilePhoto(File photoFile);

  Future<UserModel> signInWithGoogle();

  Future<void> sendPasswordResetEmail({required String email});

  Future<void> signOut();
}
