import 'package:equatable/equatable.dart';

abstract class FavouriteEvent  extends Equatable{
  const FavouriteEvent();

  @override
  List<Object?> get props => [];
}

class LoadFavouritePosts extends FavouriteEvent {
  final String? categoryId;
  final String? authorId;
  final int limit;
  final int offset;
  final bool loadMore;

  const LoadFavouritePosts({
    this.categoryId,
    this.authorId,
    this.limit = 10,
    this.offset = 0,
    this.loadMore = false,
  });

  @override
  List<Object?> get props => [categoryId, authorId, limit, offset, loadMore];
}

class LoadOnlyFavouritePostsIds extends FavouriteEvent {
  final String? authorId;

  const LoadOnlyFavouritePostsIds({
    this.authorId,
  });

  @override
  List<Object?> get props => [authorId];
}

class AddToFavourite extends FavouriteEvent {
  final String postId;

  const AddToFavourite({required this.postId});

  @override
  List<Object?> get props => [postId];
}

class RemoveFromFavourite extends FavouriteEvent {
  final String postId;

  const RemoveFromFavourite({required this.postId});

  @override
  List<Object?> get props => [postId];
}