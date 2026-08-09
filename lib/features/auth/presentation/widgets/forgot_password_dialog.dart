import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/repositories/auth_repository.dart';
import '../cubit/forgot_password_cubit.dart';
import 'auth_text_field.dart';

/// Represents ForgotPasswordDialog.
class ForgotPasswordDialog extends StatefulWidget {
  const ForgotPasswordDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      builder: (_) => BlocProvider(
        create: (_) => ForgotPasswordCubit(authRepository: sl<AuthRepository>()),
        child: const ForgotPasswordDialog(),
      ),
    );
  }

  @override
  State<ForgotPasswordDialog> createState() => _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends State<ForgotPasswordDialog> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
      builder: (context, state) {
        if (state is ForgotPasswordSuccess) {
          return AlertDialog(
            title: const Text('Check Your Email'),
            content: const Text(
              'If an account exists for that email, a password reset link has been sent.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Done'),
              ),
            ],
          );
        }

        final isLoading = state is ForgotPasswordLoading;

        return AlertDialog(
          title: const Text('Reset Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Enter your email and we'll send you a reset link.",
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 16),
              AuthTextField(
                label: 'Your Email',
                controller: _emailController,
                hintText: 'you@example.com',
                keyboardType: TextInputType.emailAddress,
              ),
              if (state is ForgotPasswordError) ...[
                const SizedBox(height: 8),
                Text(state.message, style: AppTextStyles.bodySmall.copyWith(color: AppColors.error)),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: isLoading ? null : () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () => context.read<ForgotPasswordCubit>().sendResetEmail(_emailController.text.trim()),
              child: isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.white),
                    )
                  : const Text('Send Link'),
            ),
          ],
        );
      },
    );
  }
}
