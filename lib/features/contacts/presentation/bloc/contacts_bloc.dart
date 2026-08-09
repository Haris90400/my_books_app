import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/error/exceptions.dart';
import '../../data/datasources/contacts_data_source.dart';
import 'contacts_event.dart';
import 'contacts_state.dart';

/// State management for Contacts.
class ContactsBloc extends Bloc<ContactsEvent, ContactsState> {
  ContactsBloc({required ContactsDataSource contactsDataSource})
      : _contactsDataSource = contactsDataSource,
        super(const ContactsInitial()) {
    on<ContactsRequested>(_onContactsRequested);
  }

  final ContactsDataSource _contactsDataSource;

  Future<void> _onContactsRequested(ContactsRequested event, Emitter<ContactsState> emit) async {
    emit(const ContactsLoading());

    final status = await Permission.contacts.request();
    if (status.isPermanentlyDenied) {
      emit(const ContactsPermissionDenied(isPermanentlyDenied: true));
      return;
    }
    if (!status.isGranted) {
      emit(const ContactsPermissionDenied(isPermanentlyDenied: false));
      return;
    }

    try {
      final contacts = await _contactsDataSource.getAllContacts();
      // Alphabetical order is a DISPLAY concern, not something the raw
      // device fetch owes anyone — same "transform lives in the Bloc"
      // discipline as Analytics' genre/year bucketing.
      contacts.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      emit(ContactsLoaded(contacts));
    } on AppException catch (e) {
      emit(ContactsError(e.message));
    }
  }
}
