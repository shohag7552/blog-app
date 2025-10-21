import 'package:blog_project/core/repositories/auth_repository.dart';
import 'package:blog_project/core/repositories/comment_repository.dart';
import 'package:blog_project/core/repositories/favourite_repository.dart';
import 'package:blog_project/core/repositories/post_repository.dart';
import 'package:blog_project/features/auth/bloc/auth_bloc.dart';
import 'package:blog_project/features/auth/pages/auth_wrapper.dart';
import 'package:blog_project/features/auth/pages/login_page.dart';
import 'package:blog_project/features/comments/bloc/comment_bloc.dart';
import 'package:blog_project/features/favourite/bloc/favourite_bloc.dart';
import 'package:blog_project/features/favourite/bloc/favourite_event.dart';
import 'package:blog_project/features/posts/bloc/posts_bloc.dart';
import 'package:blog_project/features/posts/bloc/posts_event.dart';
import 'package:blog_project/features/profile/bloc/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/post_create/bloc/post_create_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => AuthRepository()),
        RepositoryProvider(create: (context) => PostRepository()),
        RepositoryProvider(create: (context) => CommentRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(
              authRepository: context.read<AuthRepository>(),
            )..add(AuthStarted()),
          ),
          BlocProvider(
            create: (context) => PostCreateBloc(
              postRepository: context.read<PostRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => PostBloc(
              postRepository: context.read<PostRepository>(),
              commentRepository: context.read<CommentRepository>(),
            )..add(const LoadPosts()),
          ),
          BlocProvider(
            create: (context) => FavouriteBloc(
              favouriteRepository: context.read<FavouriteRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => CommentBloc(
              commentRepository: context.read<CommentRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => ProfileBloc(authRepository: context.read<AuthRepository>()),
          ),
        ],
        child: MaterialApp(
          title: 'Appwrite Blog',
          theme: ThemeData(
            primaryColor: Colors.yellow,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellow),
            useMaterial3: true,
          ),
          home: const AuthWrapper(),
        ),
      ),
    );
  }
}

