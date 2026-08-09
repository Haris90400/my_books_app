import '../../domain/entities/contact.dart';

/// Remote/Local data source for Contacts.
abstract class ContactsDataSource {
  /// Get all contacts.
  Future<List<Contact>> getAllContacts();
}
