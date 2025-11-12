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
        RepositoryProvider(create: (context) => FavouriteRepository()),
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
            )/*..add(const LoadFavouritePosts())*/,
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

class DraggableBottomSheetExample extends StatefulWidget {
  const DraggableBottomSheetExample({super.key});

  @override
  State<DraggableBottomSheetExample> createState() =>
      _DraggableBottomSheetExampleState();
}

class _DraggableBottomSheetExampleState
    extends State<DraggableBottomSheetExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background content
          Container(
            color: Colors.blue.shade100,
            child: const Center(
              child: Text(
                "Map or Main Content",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          // Draggable Bottom Sheet
          DraggableScrollableSheet(
            initialChildSize: 0.25, // starting height (25% of screen)
            minChildSize: 0.2,      // minimum height
            maxChildSize: 0.85,     // maximum expanded height
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Handle bar
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: Container(
                        height: 5,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    const Text(
                      "Nearby Orders",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Scrollable content inside the sheet
                    Expanded(
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount: 20,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.blue.shade200,
                              child: Text("${index + 1}"),
                            ),
                            title: Text("Order #${index + 1}"),
                            subtitle: const Text("Tap to view details"),
                            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}