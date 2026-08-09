import 'dart:io';


import '../../../../shared/user/domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

/// Handles data operations for Auth.
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({required AuthRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  final AuthRemoteDataSource _remoteDataSource;

  @override
  Stream<AppUser?> get authStateChanges => _remoteDataSource.authStateChanges;

  @override
  Future<AppUser> signInWithEmail({required String email, required String password}) {
    return _remoteDataSource.signInWithEmail(email: email, password: password);
  }

  @override
  Future<AppUser> signUpWithEmail({required String email, required String password, required String name}) {
    return _remoteDataSource.signUpWithEmail(email: email, password: password, name: name);
  }

  @override
  Future<AppUser> signInWithGoogle() {
    return _remoteDataSource.signInWithGoogle();
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) {
    return _remoteDataSource.sendPasswordResetEmail(email: email);
  }

  @override
  Future<void> signOut() {
    return _remoteDataSource.signOut();
  }

  @override
  Future<AppUser> updateDisplayName(String name) {
    return _remoteDataSource.updateDisplayName(name);
  }

  @override
  Future<AppUser> updateProfilePhoto(File photoFile) {
    return _remoteDataSource.updateProfilePhoto(photoFile);
    
  }
}
