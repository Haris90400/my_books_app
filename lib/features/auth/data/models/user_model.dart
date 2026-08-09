import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import '../../../../shared/user/domain/entities/app_user.dart';

/// Represents the User data structure.
class UserModel extends AppUser {
  const UserModel({
    required super.uid,
    required super.email,
    super.displayName,
    super.photoUrl,
  });

  /// Creates UserModel.fromFirebaseUser instance.
  factory UserModel.fromFirebaseUser(firebase_auth.User user) {
    return UserModel(
      uid: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
      photoUrl: user.photoURL,
    );
  }
}
