import 'package:blog_project/core/models/post_model.dart';
import 'package:blog_project/core/repositories/comment_repository.dart';
import 'package:blog_project/core/repositories/post_repository.dart';
import 'package:blog_project/features/posts/bloc/posts_event.dart';
import 'package:blog_project/features/posts/bloc/posts_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostRepository postRepository;
  final CommentRepository commentRepository;

  int limit = 10;
  int offset = 0;

  PostBloc({
    required this.postRepository,
    required this.commentRepository,
  }) : super(PostInitial()) {
    on<LoadPosts>(_onLoadPosts);
    // on<LoadPostDetail>(_onLoadPostDetail);
    // on<CreatePost>(_onCreatePost);
    // on<UpdatePost>(_onUpdatePost);
    on<DeletePost>(_onDeletePost);
    on<LikePost>(_onLikePost);
  }

  Future<void> _onLoadPosts(LoadPosts event, Emitter<PostState> emit) async {
    try {
      if (!event.loadMore) {
        offset = 0;
        emit(PostLoading());
      }

      final newPosts = await postRepository.getPosts(
        limit: limit,
        offset: offset,
        categoryId: event.categoryId,
        authorId: event.authorId,
      );

      final allPosts = event.loadMore
          ? [...state.posts, ...newPosts]
          : newPosts;

      offset += limit;

      print('Loaded ${newPosts.length} posts, total: ${allPosts.length}, rich max: ${newPosts.length == limit}');
      emit(PostsLoaded(
        posts: allPosts,
        hasReachedMax: newPosts.length == limit,
      ));

    } catch (e) {
      emit(PostError(e.toString()));
    }
  }

  // Future<void> _onLoadPostDetail(LoadPostDetail event, Emitter<PostState> emit) async {
  //   try {
  //     emit(PostLoading());
  //
  //     final post = await postRepository.getPostById(event.postId);
  //     final comments = await commentRepository.getCommentsByPost(event.postId);
  //
  //     emit(PostDetailLoaded(
  //       post: post,
  //       comments: comments,
  //       posts: state.posts,
  //     ));
  //   } catch (e) {
  //     emit(PostError(e.toString()));
  //   }
  // }

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

  // Future<void> _onUpdatePost(UpdatePost event, Emitter<PostState> emit) async {
  //   try {
  //     emit(PostLoading());
  //
  //     final post = await postRepository.updatePost(
  //       postId: event.postId,
  //       title: event.title,
  //       content: event.content,
  //       categoryId: event.categoryId,
  //       tags: event.tags,
  //     );
  //
  //     emit(PostUpdated(post));
  //   } catch (e) {
  //     emit(PostError(e.toString()));
  //   }
  // }
  //
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
    // try {
    //   await postRepository.toggleLike(event.postId);
    //
    //   // Reload the current state
    //   if (state is PostDetailLoaded) {
    //     add(LoadPostDetail(event.postId));
    //   } else {
    //     add(const LoadPosts());
    //   }
    // } catch (e) {
    //   emit(PostError(e.toString()));
    // }
    // Ensure we are operating on a loaded state. If we are in detail view, the existing logic is fine.
    if (state is! PostsLoaded) {
      // if (state is PostDetailLoaded) {
        // Keep the existing logic for the detail page, which refreshes the detail view.
        await postRepository.toggleLike(event.postId);
        // add(LoadPostDetail(event.postId));
      // }
      // If not loaded, or in a different state, just exit gracefully.
      return;
    }

    // Cast the state to PostsLoaded to access the list
    final currentState = state as PostsLoaded;

    // Optimistically update the UI while the async operation runs (optional but good UX)
    // For simplicity, we will update the state AFTER the successful repository call.

    try {
      // 1. Call the repository to toggle the like and get the updated counts/status.
      // Assuming toggleLike returns the updated Post object, or at least a signal of success.
      // If your repository only returns success/failure, you'll need to calculate the new values.
      // For this example, let's assume it returns the new favorite status (boolean) and count (int).

      // NOTE: This repository call needs to return the updated post data (new like count).
      // Let's assume the repository has a method that returns the *updated post*.
      final updatedPost = await postRepository.toggleLike(event.postId);

      // 2. Locate the index of the post to be replaced
      final postIndex = currentState.posts.indexWhere((p) => p.postId == event.postId);

      if (postIndex != -1) {
        // 3. Create a mutable copy of the current list of posts
        final List<PostModel> updatedPosts = List.from(currentState.posts);

        // 4. Replace the old post object with the newly fetched/updated post object
        updatedPosts[postIndex] = updatedPost;

        // 5. Emit a NEW PostsLoaded state with the updated list
        emit(PostsLoaded(
          posts: updatedPosts,
          hasReachedMax: currentState.hasReachedMax,
        ));
      }

    } catch (e) {
      // Re-emit the last successful state, and perhaps show an error snackbar via BlocListener
      // emit(PostError(e.toString(), posts: currentState.posts));
      emit(PostError(e.toString()));
    }
  }
}