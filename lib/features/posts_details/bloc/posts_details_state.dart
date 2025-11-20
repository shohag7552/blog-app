import 'package:blog_project/core/models/comment_model.dart';
import 'package:blog_project/core/models/post_model.dart';
import 'package:equatable/equatable.dart';

abstract class PostsDetailsState extends Equatable {
  final PostModel? post;
  final List<CommentModel> comments;

  const PostsDetailsState({this.post, this.comments = const []});
  @override
  List<Object?> get props => [post, comments];
}

class PostDetailsInitial extends PostsDetailsState {}

class PostDetailsLoading extends PostsDetailsState {}

class PostDetailLoaded extends PostsDetailsState {
  final PostModel post;
  final List<CommentModel> comments;

  const PostDetailLoaded({
    required this.post,
    required this.comments,
  });

  @override
  List<Object?> get props => [post, comments];
}