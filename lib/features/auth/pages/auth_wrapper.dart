import 'package:blog_project/core/widgets/custom_snakebar.dart';
import 'package:blog_project/features/post_create/pages/post_create_page.dart';
import 'package:blog_project/features/posts/pages/post_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import 'login_page.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthInitial) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is AuthAuthenticated) {
          return PostPage();
        } else if (state is AuthUnauthenticated || state is AuthError) {
          if (state is AuthError) {
            customSnakeBar(context, state.message, isSuccess: false);
          }
          return const LoginPage();
        } else {
          return const Scaffold(
            backgroundColor: Color(0xFF18391E),
            body: Center(
              child: Text('Unknown state'),
            ),
          );
        }
        /*switch (state) {
          case AuthInitial():
          case AuthLoading():
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          case AuthAuthenticated():
            return PostCreatePage();
            return PostPage();
          case AuthUnauthenticated():
          case AuthError():
            // customSnakeBar(context, (state as AuthError).message, isSuccess: false);
            return const LoginPage();
        }*/
      },
    );
  }
}