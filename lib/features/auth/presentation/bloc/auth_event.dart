import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Represents AppStarted.
class AppStarted extends AuthEvent {
  const AppStarted();
}

class LoginRequested extends AuthEvent {
  const LoginRequested({required this.email, required this.password});

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}

class SignUpRequested extends AuthEvent {
  const SignUpRequested({required this.name, required this.email, required this.password});

  final String name;
  final String email;
  final String password;

  @override
  List<Object?> get props => [name, email, password];
}

class GoogleSignInRequested extends AuthEvent {
  const GoogleSignInRequested();
}

class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}

/// Represents ProfileNameUpdateRequested.
class ProfileNameUpdateRequested extends AuthEvent {
  const ProfileNameUpdateRequested(this.name);

  final String name;

  @override
  List<Object?> get props => [name];
}

class ProfilePhotoUpdateRequested extends AuthEvent {
  const ProfilePhotoUpdateRequested(this.photoFile);

  final File photoFile;

  @override
  List<Object?> get props => [photoFile.path];
}
