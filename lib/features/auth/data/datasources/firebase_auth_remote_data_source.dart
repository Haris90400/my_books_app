import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../core/error/exceptions.dart';
import '../models/user_model.dart';
import 'auth_remote_data_source.dart';
import 'firebase_auth_error_mapper.dart';

/// Remote/Local data source for FirebaseAuthRemote.
class FirebaseAuthRemoteDataSource implements AuthRemoteDataSource {
  FirebaseAuthRemoteDataSource({
    required firebase_auth.FirebaseAuth firebaseAuth,
    required GoogleSignIn googleSignIn,
  })  : _firebaseAuth = firebaseAuth,
        _googleSignIn = googleSignIn;

  final firebase_auth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  static const _genericErrorMessage = 'Something went wrong. Please try again.';

  @override
  Stream<UserModel?> get authStateChanges {
    return _firebaseAuth
        .authStateChanges()
        .map((user) => user == null ? null : UserModel.fromFirebaseUser(user));
  }

  @override
  Future<UserModel> signInWithEmail({required String email, required String password}) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return _requireUser(credential.user);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AppException(FirebaseAuthErrorMapper.map(e));
    } catch (_) {
      throw const AppException(_genericErrorMessage);
    }
  }

  @override
  Future<UserModel> signUpWithEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      _requireUser(credential.user); // fails fast if Firebase somehow returned no user

      // createUserWithEmailAndPassword never sets displayName — the signup
      // form's "name" field has no direct Firebase equivalent. We set it
      // as a second call, then reload() so the in-memory `User` object
      // (and everything downstream) reflects it immediately instead of
      // only after the next app restart.
      await credential.user!.updateDisplayName(name);
      await credential.user!.reload();

      return _requireUser(_firebaseAuth.currentUser);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AppException(FirebaseAuthErrorMapper.map(e));
    } catch (_) {
      throw const AppException(_genericErrorMessage);
    }
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    try {
      final googleAccount = await _googleSignIn.signIn();
      if (googleAccount == null) {
        // User closed the Google account picker — not an error.
        throw const AppException('Google sign-in was cancelled.');
      }

      final googleAuth = await googleAccount.authentication;
      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(credential);
      return _requireUser(userCredential.user);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AppException(FirebaseAuthErrorMapper.map(e));
    } on AppException {
      rethrow;
    } catch (_) {
      throw const AppException(_genericErrorMessage);
    }
  }

  @override
  Future<UserModel> updateDisplayName(String name) async {
    try {
      final currentUser = _firebaseAuth.currentUser;
      if (currentUser == null) {
        throw const AppException(_genericErrorMessage);
      }
      await currentUser.updateDisplayName(name);
      await currentUser.reload();
      return _requireUser(_firebaseAuth.currentUser);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AppException(FirebaseAuthErrorMapper.map(e));
    } catch (_) {
      throw const AppException(_genericErrorMessage);
    }
  }

  @override
  Future<UserModel> updateProfilePhoto(File photoFile) async {
    try {
      final currentUser = _firebaseAuth.currentUser;
      if (currentUser == null) {
        throw const AppException(_genericErrorMessage);
      }

      // Firebase Storage would give a real HTTPS URL here — pivoted to
      // local device storage (see docs/notes/05): Storage requires the
      // Blaze billing plan, which hit a real card/currency-mismatch
      // error. We copy the picked file into this app's own documents
      // directory (so it survives even if the original gallery file is
      // later deleted/moved) and store THAT path in Firebase's
      // `photoURL` field — the same field Google Sign-In already
      // populates with a real network URL, so `ProfileAvatar`'s
      // null/network/local-path handling already covers both cases.
      final appDir = await getApplicationDocumentsDirectory();
      final dotIndex = photoFile.path.lastIndexOf('.');
      final extension = dotIndex == -1 ? '.jpg' : photoFile.path.substring(dotIndex);
      final savedFile = await photoFile.copy('${appDir.path}/profile_${currentUser.uid}$extension');

      await currentUser.updatePhotoURL(savedFile.path);
      await currentUser.reload();

      return _requireUser(_firebaseAuth.currentUser);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AppException(FirebaseAuthErrorMapper.map(e));
    } catch (_) {
      throw const AppException(_genericErrorMessage);
    }
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on firebase_auth.FirebaseAuthException catch (e) {
      // 'user-not-found' is deliberately swallowed, not mapped/thrown:
      // returning success either way prevents an attacker from using this
      // screen to check which emails have an account here (email
      // enumeration). Every other code (e.g. malformed email, network)
      // still surfaces normally.
      if (e.code == 'user-not-found') return;
      throw AppException(FirebaseAuthErrorMapper.map(e));
    } catch (_) {
      throw const AppException(_genericErrorMessage);
    }
  }

  @override
  Future<void> signOut() async {
    await Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

  /// Creates _requireUser instance.
  UserModel _requireUser(firebase_auth.User? user) {
    if (user == null) {
      throw const AppException(_genericErrorMessage);
    }
    return UserModel.fromFirebaseUser(user);
  }
}
