// part of 'posts_details_bloc.dart';
//
// sealed class PostsEvent extends Equatable {
//   const PostsEvent();
//
//   @override
//   List<Object> get props => [];
// }
import 'package:equatable/equatable.dart';

abstract class PostsDetailsEvent extends Equatable {
  const PostsDetailsEvent();

  @override
  List<Object?> get props => [];
}

class LoadPostDetail extends PostsDetailsEvent {
  final String postId;

  const LoadPostDetail(this.postId);

  @override
  List<Object?> get props => [postId];
}
