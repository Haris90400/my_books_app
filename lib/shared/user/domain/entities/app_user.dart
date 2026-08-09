import 'package:equatable/equatable.dart';

/// Represents AppUser.
class AppUser extends Equatable {
  const AppUser({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoUrl,
  });

  final String uid;
  final String email;
  final String? displayName;
  final String? photoUrl;

  @override
  List<Object?> get props => [uid, email, displayName, photoUrl];
}
