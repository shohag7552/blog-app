import 'package:blog_project/core/repositories/comment_repository.dart';
import 'package:blog_project/core/repositories/post_repository.dart';
import 'package:blog_project/features/posts_details/bloc/posts_details_event.dart';
import 'package:blog_project/features/posts_details/bloc/posts_details_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostsDetailsBloc extends Bloc<PostsDetailsEvent, PostsDetailsState> {
  final PostRepository postRepository;
  final CommentRepository commentRepository;

  int limit = 10;
  int offset = 0;

  PostsDetailsBloc({
    required this.postRepository,
    required this.commentRepository,
  }) : super(PostDetailsInitial()) {
    on<LoadPostDetail>(_onLoadPostDetail);
  }

  Future<void> _onLoadPostDetail(LoadPostDetail event, Emitter<PostsDetailsState> emit) async {
    try {
      emit(PostDetailsLoading());

      final post = await postRepository.getPostById(event.postId);
      final comments = await commentRepository.getCommentsByPost(event.postId);

      emit(PostDetailLoaded(
        post: post,
        comments: comments,
      ));
    } catch (e) {
      // emit(PostError(e.toString()));
    }
  }

}