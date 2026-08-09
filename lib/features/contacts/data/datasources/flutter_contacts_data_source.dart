import 'package:flutter_contacts/flutter_contacts.dart' as fc;

import '../../../../core/error/exceptions.dart';
import '../../domain/entities/contact.dart';
import 'contacts_data_source.dart';

/// Remote/Local data source for FlutterContacts.
class FlutterContactsDataSource implements ContactsDataSource {
  @override
  Future<List<Contact>> getAllContacts() async {
    try {
      // `properties` defaults to none (id + display name only, cheap for
      // a picker UI) — phones/emails need this explicit opt-in.
      final deviceContacts = await fc.FlutterContacts.getAll(
        properties: {fc.ContactProperty.phone, fc.ContactProperty.email},
      );

      // `id`/`displayName` are nullable in this package's model — a
      // record missing either isn't a usable `Contact` for this app
      // (nothing to key or show), filtered here at the mapping boundary,
      // same as `BookModel`'s defensive field reads.
      return deviceContacts
          .where((c) => c.id != null && (c.displayName?.trim().isNotEmpty ?? false))
          .map(_toContact)
          .toList();
    } catch (_) {
      throw const AppException('Could not load contacts. Please try again.');
    }
  }

  Contact _toContact(fc.Contact contact) {
    return Contact(
      id: contact.id!,
      name: contact.displayName!,
      phone: contact.phones.isNotEmpty ? contact.phones.first.number : null,
      email: contact.emails.isNotEmpty ? contact.emails.first.address : null,
    );
  }
}
