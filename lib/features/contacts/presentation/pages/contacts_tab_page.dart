import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../data/datasources/contacts_data_source.dart';
import '../bloc/contacts_bloc.dart';
import '../bloc/contacts_event.dart';
import '../bloc/contacts_state.dart';
import '../widgets/contact_detail_bottom_sheet.dart';
import '../widgets/contact_list_tile.dart';
import '../widgets/my_profile_card.dart';

/// Main UI for the ContactsTab screen.
@RoutePage(name: 'ContactsTabRoute')
class ContactsTabPage extends StatelessWidget {
  const ContactsTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ContactsBloc>(
      create: (_) => ContactsBloc(contactsDataSource: sl<ContactsDataSource>())..add(const ContactsRequested()),
      child: const _ContactsTabView(),
    );
  }
}

class _ContactsTabView extends StatelessWidget {
  const _ContactsTabView();

  @override
  Widget build(BuildContext context) {
    // Current user is read here, not re-fetched — `AuthBloc` already owns
    // it app-wide; the "Me" card is just another place that displays it.
    final authState = context.watch<AuthBloc>().state;
    final currentUser = authState is AuthAuthenticated ? authState.user : null;

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.primary, AppColors.primary.withValues(alpha: 0.75)],
            ),
            borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(32), bottomRight: Radius.circular(32)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Contacts', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppColors.white)),
              const SizedBox(height: 4),
              Text(
                'People on your device',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.white.withValues(alpha: 0.85)),
              ),
            ],
          ),
        ),
        Expanded(
          child: BlocBuilder<ContactsBloc, ContactsState>(
            builder: (context, state) {
              if (state is ContactsInitial || state is ContactsLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is ContactsPermissionDenied) {
                return _PermissionDeniedView(isPermanentlyDenied: state.isPermanentlyDenied);
              }

              if (state is ContactsError) {
                return _MessageView(
                  message: state.message,
                  actionLabel: 'Retry',
                  onAction: () => context.read<ContactsBloc>().add(const ContactsRequested()),
                );
              }

              final contacts = (state as ContactsLoaded).contacts;
              return ListView.separated(
                padding: const EdgeInsets.all(20),
                itemCount: contacts.length + 1,
                separatorBuilder: (context, index) => index == 0 ? const SizedBox(height: 16) : const Divider(height: 1),
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return MyProfileCard(
                      name: currentUser?.displayName ?? 'You',
                      email: currentUser?.email ?? '',
                      onTap: () => ContactDetailBottomSheet.show(
                        context,
                        name: currentUser?.displayName ?? 'You',
                        email: currentUser?.email,
                      ),
                    );
                  }
                  final contact = contacts[index - 1];
                  return ContactListTile(
                    name: contact.name,
                    subtitle: contact.phone ?? contact.email ?? '',
                    onTap: () => ContactDetailBottomSheet.show(
                      context,
                      name: contact.name,
                      phone: contact.phone,
                      email: contact.email,
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _PermissionDeniedView extends StatelessWidget {
  const _PermissionDeniedView({required this.isPermanentlyDenied});

  final bool isPermanentlyDenied;

  @override
  Widget build(BuildContext context) {
    return _MessageView(
      message: isPermanentlyDenied
          ? 'Contacts access was denied. Enable it from Settings to see your contacts.'
          : 'Contacts access is needed to show your contacts.',
      actionLabel: isPermanentlyDenied ? 'Open Settings' : 'Grant Access',
      onAction: isPermanentlyDenied
          ? openAppSettings
          : () => context.read<ContactsBloc>().add(const ContactsRequested()),
    );
  }
}

class _MessageView extends StatelessWidget {
  const _MessageView({required this.message, required this.actionLabel, required this.onAction});

  final String message;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.contacts_rounded, size: 48, color: AppColors.textMuted),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: 16),
            OutlinedButton(onPressed: onAction, child: Text(actionLabel)),
          ],
        ),
      ),
    );
  }
}
