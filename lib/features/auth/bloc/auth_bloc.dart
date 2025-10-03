import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:appwrite/appwrite.dart';
import '../../../core/models/user_model.dart';
import '../../../core/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(AuthInitial()) {
    on<AuthStarted>(_onAuthStarted);
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthRegisterRequested>(_onAuthRegisterRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
  }

  final AuthRepository _authRepository;

  Future<void> _onAuthStarted(
    AuthStarted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    try {
      final user = await _authRepository.getCurrentUser();
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onAuthLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    try {
      final user = await _authRepository.login(
        email: event.email,
        password: event.password,
      );
      print('====user: $user');
      if(user != null) {
        emit(AuthAuthenticated(user));
      }
    } on AppwriteException catch (e) {
      emit(AuthError(_getErrorMessage(e)));
    } catch (e) {
      emit(const AuthError('An unexpected error occurred'));
    }
  }

  Future<void> _onAuthRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    try {
      await _authRepository.register(
        email: event.email,
        password: event.password,
        name: event.name,
      );
      // if(user != null) {
      //   emit(AuthAuthenticated(user));
      // }
    } on AppwriteException catch (e) {
      emit(AuthError(_getErrorMessage(e)));
    } catch (e) {
      emit(const AuthError('An unexpected error occurred'));
    }
  }

  Future<void> _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    try {
      await _authRepository.logout();
      emit(AuthUnauthenticated());
    } on AppwriteException catch (e) {
      emit(AuthError(_getErrorMessage(e)));
    } catch (e) {
      emit(const AuthError('Failed to logout'));
    }
  }

  String _getErrorMessage(AppwriteException e) {
    switch (e.code) {
      case 401:
        return 'Invalid email or password';
      case 409:
        return 'User with this email already exists';
      case 429:
        return 'Too many requests. Please try again later';
      default:
        return e.message ?? 'An error occurred';
    }
  }
}