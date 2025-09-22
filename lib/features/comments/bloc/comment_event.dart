import 'package:equatable/equatable.dart';

abstract class CommentEvent extends Equatable {
  const CommentEvent();

  @override
  List<Object?> get props => [];
}

class LoadComments extends CommentEvent {
  final String postId;
  final int limit;
  final int offset;

  const LoadComments({
    required this.postId,
    this.limit = 10,
    this.offset = 0,
  });

  @override
  List<Object?> get props => [postId, limit, offset];
}

class CreateComment extends CommentEvent {
  final String postId;
  final String userId;
  final String content;

  const CreateComment({required this.content, required this.postId, required this.userId});

  @override
  List<Object?> get props => [content, postId, userId];
}

class DeleteComment extends CommentEvent {
  final String commentId;
  final String? postId;

  const DeleteComment({this.postId, required this.commentId});

  @override
  List<Object?> get props => [postId, commentId];
}