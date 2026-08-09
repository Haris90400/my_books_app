import 'package:equatable/equatable.dart';

/// Represents Contact.
class Contact extends Equatable {
  const Contact({required this.id, required this.name, this.phone, this.email});

  final String id;
  final String name;
  final String? phone;
  final String? email;

  @override
  List<Object?> get props => [id, name, phone, email];
}
