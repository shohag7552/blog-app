import 'dart:developer';

import 'package:blog_project/core/widgets/post_card.dart';
import 'package:blog_project/features/favourite/bloc/favourite_bloc.dart';
import 'package:blog_project/features/favourite/bloc/favourite_event.dart';
import 'package:blog_project/features/favourite/bloc/favourite_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavouritePage extends StatefulWidget {
  const FavouritePage({super.key});

  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    context.read<FavouriteBloc>().add(LoadFavouritePosts(loadMore: true));
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {

    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      final bloc = context.read<FavouriteBloc>();
      final state = bloc.state;
      if(mounted && state is FavouriteLoaded && state.hasReachedMax) {
        log('Loading more posts...');
        context.read<FavouriteBloc>().add(LoadFavouritePosts(loadMore: true));
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();

    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favourite'),
      ),
      body: BlocBuilder<FavouriteBloc, FavouriteState>(
        builder: (context, state) {
          if(state is FavouriteLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if(state is FavouriteError) {
            return Center(
              child: Text('Error: ${state.message}'),
            );
          } else if(state is FavouriteLoaded && state.posts.isEmpty) {
            return const Center(
              child: Text('No favourite posts found.'),
            );
          }
          return ListView.builder(
              controller: _scrollController,
              itemCount: state.posts.length,
              padding: const EdgeInsets.only(
                top: 20,
                left: 16,
                right: 16,
                bottom: 16,
              ),
              itemBuilder: (context, index) {
                return PostCard(postModel: state.posts[index]);
              });
        }
      ),
    );
  }
}