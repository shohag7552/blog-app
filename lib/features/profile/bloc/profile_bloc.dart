import 'package:blog_project/core/repositories/auth_repository.dart';
import 'package:blog_project/features/profile/bloc/profile_event.dart';
import 'package:blog_project/features/profile/bloc/profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthRepository authRepository;
  ProfileBloc({required this.authRepository}) : super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
  }

  Future<void> _onLoadProfile(LoadProfile event, Emitter<ProfileState> emit) async {
    try {
      emit(ProfileLoading());

      final user = await authRepository.getUserById(event.userId);
      emit(ProfileLoaded(user: user));
    } catch (e) {
      emit(ProfileError(message: 'Failed to load profile: ${e.toString()}'));
    }
  }
}