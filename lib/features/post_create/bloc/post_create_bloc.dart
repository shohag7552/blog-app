
import 'package:blog_project/core/repositories/post_repository.dart';
import 'package:blog_project/features/post_create/bloc/post_create_event.dart';
import 'package:blog_project/features/post_create/bloc/post_create_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostCreateBloc extends Bloc<PostCreateEvent, PostCreateState> {
  final PostRepository postRepository;
  // final CommentRepository commentRepository;

  PostCreateBloc({
    required this.postRepository,
    // required this.commentRepository,
  }) : super(PostCreateInitial()) {
    on<CreatePost>(_onCreatePost);
  }

  Future<void> _onCreatePost(CreatePost event, Emitter<PostCreateState> emit) async {
    try {
      emit(PostCreateLoading());

      final post = await postRepository.createPost(
        title: event.post.title,
        content: event.post.content,
        authorId: event.post.author?.userId ?? '',
        categoryId: event.post.category?.categoryId??'',
        tags: event.post.tags,
      );

      print('=====> Created Post: ${post.toMap()} =====');
      emit(PostCreateSuccess());
    } catch (e) {
      emit(PostCreateFailure(e.toString()));
    }
  }


}