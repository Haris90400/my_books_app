import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/validators/password_validator.dart';

/// Represents PasswordRulesChecklist.
class PasswordRulesChecklist extends StatelessWidget {
  const PasswordRulesChecklist({super.key, required this.result});

  final PasswordRuleResult result;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _RuleRow(label: 'At least 8 characters', met: result.hasMinLength),
        _RuleRow(label: 'One uppercase letter', met: result.hasUppercase),
        _RuleRow(label: 'One lowercase letter', met: result.hasLowercase),
        _RuleRow(label: 'One number', met: result.hasNumber),
        _RuleRow(label: 'One special character (!@#\$%^&*)', met: result.hasSpecialChar),
      ],
    );
  }
}

class _RuleRow extends StatelessWidget {
  const _RuleRow({required this.label, required this.met});

  final String label;
  final bool met;

  @override
  Widget build(BuildContext context) {
    final color = met ? AppColors.success : AppColors.textMuted;
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          Icon(
            met ? Icons.check_circle : Icons.circle_outlined,
            size: 16,
            color: color,
          ),
          const SizedBox(width: 8),
          Text(label, style: AppTextStyles.bodySmall.copyWith(color: color)),
        ],
      ),
    );
  }
}
