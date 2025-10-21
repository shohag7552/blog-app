import 'package:blog_project/features/favourite/bloc/favourite_bloc.dart';
import 'package:blog_project/features/favourite/bloc/favourite_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavouritePage extends StatefulWidget {
  const FavouritePage({super.key});

  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {

  @override
  void initState() {
    super.initState();

    context.read<FavouriteBloc>().add(LoadFavouritePosts(loadMore: true));
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favourite'),
      ),
      body: const Center(
        child: Text(
          'No favourites added yet!',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}