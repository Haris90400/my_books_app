import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/exceptions.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

/// State management for Auth.
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(const AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<LoginRequested>(_onLoginRequested);
    on<SignUpRequested>(_onSignUpRequested);
    on<GoogleSignInRequested>(_onGoogleSignInRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<ProfileNameUpdateRequested>(_onProfileNameUpdateRequested);
    on<ProfilePhotoUpdateRequested>(_onProfilePhotoUpdateRequested);
  }

  final AuthRepository _authRepository;

  Future<void> _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    final currentUser = await _authRepository.authStateChanges.first;
    emit(currentUser != null ? AuthAuthenticated(currentUser) : const AuthUnauthenticated());
  }

  Future<void> _onLoginRequested(LoginRequested event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    try {
      final user = await _authRepository.signInWithEmail(
        email: event.email,
        password: event.password,
      );
      emit(AuthAuthenticated(user));
    } on AppException catch (e) {
      emit(AuthError(e.message));
    }
  }

  Future<void> _onProfileNameUpdateRequested(ProfileNameUpdateRequested event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    try {
      final updatedUser = await _authRepository.updateDisplayName(event.name);
      emit(AuthAuthenticated(updatedUser));
    } on AppException catch (e) {
      emit(AuthError(e.message));
    }
  }

  Future<void> _onProfilePhotoUpdateRequested(ProfilePhotoUpdateRequested event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    try {
      final updatedUser = await _authRepository.updateProfilePhoto(event.photoFile);
      emit(AuthAuthenticated(updatedUser));
    } on AppException catch (e) {
      emit(AuthError(e.message));
    }
  }

  Future<void> _onSignUpRequested(SignUpRequested event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    try {
      final user = await _authRepository.signUpWithEmail(
        name: event.name,
        email: event.email,
        password: event.password,
      );
      emit(AuthAuthenticated(user));
    } on AppException catch (e) {
      emit(AuthError(e.message));
    }
  }

  Future<void> _onGoogleSignInRequested(GoogleSignInRequested event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    try {
      final user = await _authRepository.signInWithGoogle();
      emit(AuthAuthenticated(user));
    } on AppException catch (e) {
      emit(AuthError(e.message));
    }
  }

  Future<void> _onLogoutRequested(LogoutRequested event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    try {
      await _authRepository.signOut();
      emit(const AuthUnauthenticated());
    } on AppException catch (e) {
      emit(AuthError(e.message));
    }
  }
}
