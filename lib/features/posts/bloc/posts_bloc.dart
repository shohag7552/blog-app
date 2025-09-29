import 'package:blog_project/core/repositories/comment_repository.dart';
import 'package:blog_project/core/repositories/post_repository.dart';
import 'package:blog_project/features/posts/bloc/posts_event.dart';
import 'package:blog_project/features/posts/bloc/posts_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostRepository postRepository;
  final CommentRepository commentRepository;

  PostBloc({
    required this.postRepository,
    required this.commentRepository,
  }) : super(PostInitial()) {
    on<LoadPosts>(_onLoadPosts);
    on<LoadPostDetail>(_onLoadPostDetail);
    // on<CreatePost>(_onCreatePost);
    on<UpdatePost>(_onUpdatePost);
    on<DeletePost>(_onDeletePost);
    on<LikePost>(_onLikePost);
  }

  Future<void> _onLoadPosts(LoadPosts event, Emitter<PostState> emit) async {
    try {
      emit(PostLoading());

      final posts = await postRepository.getPosts(
        limit: event.limit,
        offset: event.offset,
        categoryId: event.categoryId,
        authorId: event.authorId,
      );

      emit(PostsLoaded(
        posts: posts,
        hasReachedMax: posts.length < event.limit,
      ));
    } catch (e) {
      emit(PostError(e.toString()));
    }
  }

  Future<void> _onLoadPostDetail(LoadPostDetail event, Emitter<PostState> emit) async {
    try {
      emit(PostLoading());

      final post = await postRepository.getPostById(event.postId);
      final comments = await commentRepository.getCommentsByPost(event.postId);

      emit(PostDetailLoaded(
        post: post,
        comments: comments,
      ));
    } catch (e) {
      emit(PostError(e.toString()));
    }
  }

  // Future<void> _onCreatePost(CreatePost event, Emitter<PostState> emit) async {
  //   try {
  //     emit(PostLoading());
  //
  //     final post = await postRepository.createPost(
  //       title: event.title,
  //       content: event.content,
  //       authorId: event.authorId,
  //       categoryId: event.categoryId,
  //       tags: event.tags,
  //     );
  //
  //     emit(PostCreated(post));
  //   } catch (e) {
  //     emit(PostError(e.toString()));
  //   }
  // }

  Future<void> _onUpdatePost(UpdatePost event, Emitter<PostState> emit) async {
    try {
      emit(PostLoading());

      final post = await postRepository.updatePost(
        postId: event.postId,
        title: event.title,
        content: event.content,
        categoryId: event.categoryId,
        tags: event.tags,
      );

      emit(PostUpdated(post));
    } catch (e) {
      emit(PostError(e.toString()));
    }
  }

  Future<void> _onDeletePost(DeletePost event, Emitter<PostState> emit) async {
    try {
      emit(PostLoading());

      await postRepository.deletePost(event.postId);

      emit(PostDeleted(event.postId));
    } catch (e) {
      emit(PostError(e.toString()));
    }
  }

  Future<void> _onLikePost(LikePost event, Emitter<PostState> emit) async {
    try {
      await postRepository.likePost(event.postId, event.currentLikes);

      // Reload the current state
      if (state is PostDetailLoaded) {
        add(LoadPostDetail(event.postId));
      } else {
        add(const LoadPosts());
      }
    } catch (e) {
      emit(PostError(e.toString()));
    }
  }
}