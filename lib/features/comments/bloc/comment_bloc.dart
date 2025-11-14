import 'package:blog_project/core/repositories/comment_repository.dart';
import 'package:blog_project/features/comments/bloc/comment_event.dart';
import 'package:blog_project/features/comments/bloc/comment_state.dart' hide LoadComments;
import 'package:flutter_bloc/flutter_bloc.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final CommentRepository commentRepository;

  CommentBloc({required this.commentRepository}) : super(CommentInitial()) {
    on<LoadComments>(_onLoadComments);
    on<CreateComment>(_onCreateComment);
    on<DeleteComment>(_onDeleteComment);
  }

  Future<void> _onLoadComments(LoadComments event, Emitter<CommentState> emit) async {
    // try {
      emit(CommentLoading());

      final comments = await commentRepository.getCommentsByPost(event.postId);

      emit(CommentsLoaded(comments: comments));
    // } catch (e) {
    //   emit(CommentError(e.toString()));
    // }
  }

  Future<void> _onCreateComment(CreateComment event, Emitter<CommentState> emit) async {
    try {
      emit(CommentLoading());

      final comment = await commentRepository.createComment(
        content: event.content,
        postId: event.postId,
        userId: event.userId,
      );

      emit(CommentCreated(comment!));

      // Reload comments
      add(LoadComments(postId: event.postId));
    } catch (e) {
      emit(CommentError(e.toString()));
    }
  }

  Future<void> _onDeleteComment(DeleteComment event, Emitter<CommentState> emit) async {
    try {
      await commentRepository.deleteComment(event.commentId);

      // Reload comments if we have the postId
      if (event.postId != null) {
        add(LoadComments(postId: event.postId!));
      }
    } catch (e) {
      emit(CommentError(e.toString()));
    }
  }
}