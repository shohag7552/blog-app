// part of 'posts_details_bloc.dart';
//
// sealed class PostsEvent extends Equatable {
//   const PostsEvent();
//
//   @override
//   List<Object> get props => [];
// }
import 'package:equatable/equatable.dart';

abstract class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object?> get props => [];
}

class LoadPosts extends PostEvent {
  final String? categoryId;
  final String? authorId;
  final int limit;
  final int offset;
  final bool loadMore;

  const LoadPosts({
    this.categoryId,
    this.authorId,
    this.limit = 10,
    this.offset = 0,
    this.loadMore = false,
  });

  @override
  List<Object?> get props => [categoryId, authorId, limit, offset, loadMore];
}

// class LoadPostDetail extends PostEvent {
//   final String postId;
//
//   const LoadPostDetail(this.postId);
//
//   @override
//   List<Object?> get props => [postId];
// }

// class CreatePost extends PostEvent {
//   final String title;
//   final String content;
//   final String authorId;
//   final String categoryId;
//   final List<String> tags;
//
//   const CreatePost({
//     required this.title,
//     required this.content,
//     required this.authorId,
//     required this.categoryId,
//     required this.tags,
//   });
//
//   @override
//   List<Object?> get props => [title, content, authorId, categoryId, tags];
// }

// class UpdatePost extends PostEvent {
//   final String postId;
//   final String? title;
//   final String? content;
//   final String? categoryId;
//   final List<String>? tags;
//
//   const UpdatePost({
//     required this.postId,
//     this.title,
//     this.content,
//     this.categoryId,
//     this.tags,
//   });
//
//   @override
//   List<Object?> get props => [postId, title, content, categoryId, tags];
// }
//
class DeletePost extends PostEvent {
  final String postId;

  const DeletePost(this.postId);

  @override
  List<Object?> get props => [postId];
}

class LikePost extends PostEvent {
  final String postId;
  // final int currentLikes;

  const LikePost({
    required this.postId,
    // required this.currentLikes,
  });

  @override
  List<Object?> get props => [postId/*, currentLikes*/];
}

class SearchPosts extends PostEvent {
  final String query;

  const SearchPosts(this.query);

  @override
  List<Object?> get props => [query];
}