import 'package:blog_project/core/models/comment_model.dart';
import 'package:blog_project/core/models/post_model.dart';
import 'package:equatable/equatable.dart';

abstract class PostState extends Equatable {
  final List<PostModel> posts;
  final bool hasMore;

  const PostState({this.posts = const [], this.hasMore = true});
  @override
  List<Object?> get props => [posts, hasMore];
}

class PostInitial extends PostState {}

class PostLoading extends PostState {
  const PostLoading({super.posts, super.hasMore});
}

class PostsLoaded extends PostState {
  final List<PostModel> posts;
  final List<PostModel> allPosts;
  final bool hasReachedMax;
  final String searchQuery;

  const PostsLoaded({
    required this.posts,
    List<PostModel>? allPosts,
    this.hasReachedMax = false,
    this.searchQuery = '',
  }) : allPosts = allPosts ?? posts;

  @override
  List<Object?> get props => [posts, allPosts, hasReachedMax, searchQuery];

  PostsLoaded copyWith({
    List<PostModel>? posts,
    List<PostModel>? allPosts,
    bool? hasReachedMax,
    String? searchQuery,
  }) {
    return PostsLoaded(
      posts: posts ?? this.posts,
      allPosts: allPosts ?? this.allPosts,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}
//
// class PostDetailLoaded extends PostState {
//   final PostModel post;
//   final List<CommentModel> comments;
//   final List<PostModel> posts;
//
//   const PostDetailLoaded({
//     required this.post,
//     required this.comments,
//     required this.posts,
//   });
//
//   @override
//   List<Object?> get props => [post, comments, posts];
// }

// class PostCreated extends PostState {
//   final PostModel post;
//
//   const PostCreated(this.post);
//
//   @override
//   List<Object?> get props => [post];
// }
//
// class PostUpdated extends PostState {
//   final PostModel post;
//
//   const PostUpdated(this.post);
//
//   @override
//   List<Object?> get props => [post];
// }

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