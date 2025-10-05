import 'package:blog_project/core/models/user_model.dart';
import 'package:equatable/equatable.dart';

abstract class ProfileState extends Equatable {
  final UserModel? user;
  const ProfileState({this.user});

  @override
  List<Object?> get props => [user];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {
  const ProfileLoading({super.user});
}

class ProfileLoaded extends ProfileState {
  const ProfileLoaded({required super.user});

  @override
  List<Object?> get props => [user];
}

class ProfileError extends ProfileState {
  final String message;
  const ProfileError({required this.message});

  @override
  List<Object?> get props => [message, user];
}