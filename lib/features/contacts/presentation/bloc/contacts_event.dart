import 'package:equatable/equatable.dart';

abstract class ContactsEvent extends Equatable {
  const ContactsEvent();

  @override
  List<Object?> get props => [];
}

/// Represents ContactsRequested.
class ContactsRequested extends ContactsEvent {
  const ContactsRequested();
}
