import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/exceptions.dart';
import '../../domain/repositories/auth_repository.dart';

abstract class ForgotPasswordState extends Equatable {
  const ForgotPasswordState();

  @override
  List<Object?> get props => [];
}

class ForgotPasswordInitial extends ForgotPasswordState {
  const ForgotPasswordInitial();
}

class ForgotPasswordLoading extends ForgotPasswordState {
  const ForgotPasswordLoading();
}

class ForgotPasswordSuccess extends ForgotPasswordState {
  const ForgotPasswordSuccess();
}

class ForgotPasswordError extends ForgotPasswordState {
  const ForgotPasswordError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

/// State management for ForgotPassword.
class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(const ForgotPasswordInitial());

  final AuthRepository _authRepository;

  Future<void> sendResetEmail(String email) async {
    emit(const ForgotPasswordLoading());
    try {
      await _authRepository.sendPasswordResetEmail(email: email);
      emit(const ForgotPasswordSuccess());
    } on AppException catch (e) {
      emit(ForgotPasswordError(e.message));
    }
  }
}
