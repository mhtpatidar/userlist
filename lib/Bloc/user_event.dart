// lib/Bloc/user_event.dart
import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

class FetchUsers extends UserEvent {}

class FetchMoreUsers extends UserEvent {} // New event for fetching more users
