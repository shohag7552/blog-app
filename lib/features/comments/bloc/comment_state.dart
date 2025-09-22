import 'package:blog_project/core/models/comment_model.dart';
import 'package:equatable/equatable.dart';

abstract class CommentState extends Equatable {
  const CommentState();

  @override
  List<Object?> get props => [];
}

class CommentInitial extends CommentState {}

class CommentLoading extends CommentState {}

class CommentsLoaded extends CommentState {
  final List<CommentModel> comments;
  final bool hasReachedMax;

  const CommentsLoaded({
    required this.comments,
    this.hasReachedMax = false,
  });

  @override
  List<Object?> get props => [comments, hasReachedMax];
}

class CommentError extends CommentState {
  final String message;

  const CommentError(this.message);

  @override
  List<Object?> get props => [message];
}

class CommentCreated extends CommentState {
  final CommentModel comment;

  const CommentCreated(this.comment);

  @override
  List<Object?> get props => [comment];
}

class LoadComments extends CommentState {
  final String id;

  const LoadComments(this.id);

  @override
  List<Object?> get props => [id];
}

