import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/validators/password_validator.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/password_rules_checklist.dart';
import '../widgets/social_sign_in_button.dart';

/// Main UI for the SignUp screen.
@RoutePage(name: 'SignUpRoute')
class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _agreedToTerms = false;

  PasswordRuleResult _passwordResult = PasswordValidator.validate('');

  @override
  void dispose() {
    _nameController.dispose();
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
          listener: (context, state) {
            if (state is AuthAuthenticated) {
              context.router.replaceAll([const DashboardRoute()]);
            } else if (state is AuthError) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(content: Text(state.message), backgroundColor: AppColors.error));
            }
          },
          builder: (context, state) {
            final isLoading = state is AuthLoading;
            final hasName = _nameController.text.trim().isNotEmpty;
            final canSubmit = !isLoading && hasName && _passwordResult.isValid && _agreedToTerms;

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Sign Up', style: textTheme.headlineLarge),
                  const SizedBox(height: 4),
                  Text(
                    'Enter your details below & free sign up',
                    style: textTheme.bodySmall?.copyWith(color: AppColors.textMuted),
                  ),
                  const SizedBox(height: 32),
                  AuthTextField(
                    label: 'Your Name',
                    controller: _nameController,
                    hintText: 'Kristin Watson',
                    keyboardType: TextInputType.name,
                    // Only local UI state — forces a rebuild so `canSubmit`
                    // re-evaluates as the user types, same reason
                    // password's onChanged exists below.
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 20),
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
                    hintText: 'Create a password',
                    obscureText: _obscurePassword,
                    onChanged: (value) {
                      setState(() => _passwordResult = PasswordValidator.validate(value));
                    },
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        color: AppColors.textMuted,
                      ),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  const SizedBox(height: 12),
                  PasswordRulesChecklist(result: _passwordResult),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Checkbox(
                        value: _agreedToTerms,
                        activeColor: AppColors.primary,
                        onChanged: (value) => setState(() => _agreedToTerms = value ?? false),
                      ),
                      Expanded(
                        child: Text(
                          'By creating an account you agree with our terms & conditions.',
                          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: canSubmit ? () => _submitSignUp(context) : null,
                    child: isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.white),
                          )
                        : const Text('Create account'),
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
                      onTap: () => context.router.maybePop(),
                      child: RichText(
                        text: TextSpan(
                          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                          children: [
                            const TextSpan(text: 'Already have an account? '),
                            TextSpan(
                              text: 'Log in',
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

  void _submitSignUp(BuildContext context) {
    context.read<AuthBloc>().add(
          SignUpRequested(
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text,
          ),
        );
  }
}
