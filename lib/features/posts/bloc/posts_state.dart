import 'package:blog_project/core/models/comment_model.dart';
import 'package:blog_project/core/models/post_model.dart';
import 'package:equatable/equatable.dart';

abstract class PostState extends Equatable {
  const PostState();

  @override
  List<Object?> get props => [];
}

class PostInitial extends PostState {}

class PostLoading extends PostState {}

class PostsLoaded extends PostState {
  final List<PostModel> posts;
  final bool hasReachedMax;

  const PostsLoaded({
    required this.posts,
    this.hasReachedMax = false,
  });

  @override
  List<Object?> get props => [posts, hasReachedMax];
}

class PostDetailLoaded extends PostState {
  final PostModel post;
  final List<CommentModel> comments;

  const PostDetailLoaded({
    required this.post,
    required this.comments,
  });

  @override
  List<Object?> get props => [post, comments];
}

class PostCreated extends PostState {
  final PostModel post;

  const PostCreated(this.post);

  @override
  List<Object?> get props => [post];
}

class PostUpdated extends PostState {
  final PostModel post;

  const PostUpdated(this.post);

  @override
  List<Object?> get props => [post];
}

class PostDeleted extends PostState {
  final String postId;

  const PostDeleted(this.postId);

  @override
  List<Object?> get props => [postId];
}

class PostError extends PostState {
  final String message;

  const PostError(this.message);

  @override
  List<Object?> get props => [message];
}