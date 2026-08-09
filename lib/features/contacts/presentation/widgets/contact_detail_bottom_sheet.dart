import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Represents ContactDetailBottomSheet.
class ContactDetailBottomSheet extends StatelessWidget {
  const ContactDetailBottomSheet({super.key, required this.name, this.phone, this.email});

  final String name;
  final String? phone;
  final String? email;

  static Future<void> show(BuildContext context, {required String name, String? phone, String? email}) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => ContactDetailBottomSheet(name: name, phone: phone, email: email),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(color: AppColors.textMuted.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(height: 20),
          CircleAvatar(
            radius: 32,
            backgroundColor: AppColors.primary.withValues(alpha: 0.12),
            child: Text(
              _initials(name),
              style: AppTextStyles.titleLarge.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 12),
          Text(name, style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 20),
          if (phone != null && phone!.isNotEmpty) _DetailRow(icon: Icons.call_rounded, label: 'Phone', value: phone!),
          if (phone != null && phone!.isNotEmpty && email != null && email!.isNotEmpty) const SizedBox(height: 10),
          if (email != null && email!.isNotEmpty) _DetailRow(icon: Icons.email_outlined, label: 'Email', value: email!),
          if ((phone == null || phone!.isEmpty) && (email == null || email!.isEmpty))
            Text('No phone or email on file', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted)),
        ],
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    final first = parts.first[0];
    final last = parts.length > 1 ? parts.last[0] : '';
    return (first + last).toUpperCase();
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(14)),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted)),
                Text(value, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
