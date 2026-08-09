import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/forgot_password_dialog.dart';
import '../widgets/social_sign_in_button.dart';

/// Main UI for the Login screen.
@RoutePage(name: 'LoginRoute')
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          // listener: one-time reactions (navigation, SnackBar) — never
          // used for building widgets, only for side effects.
          listener: (context, state) {
            if (state is AuthAuthenticated) {
              context.router.replaceAll([const DashboardRoute()]);
            } else if (state is AuthError) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(content: Text(state.message), backgroundColor: AppColors.error));
            }
          },
          // builder: decides what to render for the current state —
          // here, only whether the buttons show a spinner or their label.
          builder: (context, state) {
            final isLoading = state is AuthLoading;

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  Text('Log In', style: textTheme.headlineLarge),
                  const SizedBox(height: 4),
                  Text(
                    'Welcome back, sign in to continue',
                    style: textTheme.bodySmall?.copyWith(color: AppColors.textMuted),
                  ),
                  const SizedBox(height: 32),
                  AuthTextField(
                    label: 'Your Email',
                    controller: _emailController,
                    hintText: 'you@example.com',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),
                  AuthTextField(
                    label: 'Password',
                    controller: _passwordController,
                    hintText: 'Enter your password',
                    obscureText: _obscurePassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        color: AppColors.textMuted,
                      ),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => ForgotPasswordDialog.show(context),
                      child: Text(
                        'Forgot password?',
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: isLoading ? null : () => _submitLogin(context),
                    child: isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.white),
                          )
                        : const Text('Log In'),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Expanded(child: Divider(color: AppColors.textMuted)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text('or', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted)),
                      ),
                      const Expanded(child: Divider(color: AppColors.textMuted)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SocialSignInButton(
                    label: 'Continue with Google',
                    onPressed: isLoading
                        ? () {}
                        : () => context.read<AuthBloc>().add(const GoogleSignInRequested()),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: GestureDetector(
                      onTap: () => context.router.push(const SignUpRoute()),
                      child: RichText(
                        text: TextSpan(
                          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                          children: [
                            const TextSpan(text: "Don't have an account? "),
                            TextSpan(
                              text: 'Sign up',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _submitLogin(BuildContext context) {
    context.read<AuthBloc>().add(
          LoginRequested(email: _emailController.text.trim(), password: _passwordController.text),
        );
  }
}
