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