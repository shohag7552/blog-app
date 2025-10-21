import 'package:blog_project/core/models/post_model.dart';
import 'package:equatable/equatable.dart';

abstract class FavouriteState extends Equatable {
  final List<PostModel> posts;
  final bool hasMore;

  const FavouriteState({this.posts = const [], this.hasMore = true});
  @override
  List<Object?> get props => [posts, hasMore];
}

class FavouriteInitial extends FavouriteState {}

class FavouriteLoading extends FavouriteState {
  const FavouriteLoading({super.posts, super.hasMore});
}

class FavouriteLoaded extends FavouriteState {
  final List<PostModel> posts;
  final bool hasReachedMax;

  const FavouriteLoaded({
    required this.posts,
    this.hasReachedMax = false,
  });

  @override
  List<Object?> get props => [posts, hasReachedMax];
}

class FavouriteError extends FavouriteState {
  final String message;

  const FavouriteError(this.message);

  @override
  List<Object?> get props => [message];
}