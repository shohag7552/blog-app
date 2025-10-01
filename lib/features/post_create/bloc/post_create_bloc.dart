
import 'package:blog_project/core/repositories/post_repository.dart';
import 'package:blog_project/features/post_create/bloc/post_create_event.dart';
import 'package:blog_project/features/post_create/bloc/post_create_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class PostCreateBloc extends Bloc<PostCreateEvent, PostCreateState> {
  final PostRepository postRepository;
  // final CommentRepository commentRepository;
  final ImagePicker _picker = ImagePicker();

  PostCreateBloc({
    required this.postRepository,
    // required this.commentRepository,
  }) : super(PostCreateState()) {
    on<PostImagesPicked>(_onImagesPicked);
    on<PostImageRemoved>(_onImageRemoved);
    on<PostTagAdded>(_onTagAdded);
    on<PostTagRemoved>(_onTagRemoved);
    on<CreatePost>(_onPostSubmitted);
  }

  Future<void> _onImagesPicked(PostImagesPicked event, Emitter<PostCreateState> emit) async {
    final pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      emit(state.copyWith(
        images: [...state.images, ...pickedFiles],
        status: PostCreateStatus.editing,
      ));
    }
  }

  void _onImageRemoved(
      PostImageRemoved event,
      Emitter<PostCreateState> emit,
      ) {
    final updated = List<XFile>.from(state.images)..removeAt(event.index);
    emit(state.copyWith(images: updated, status: PostCreateStatus.editing));
  }

  void _onTagAdded(
      PostTagAdded event,
      Emitter<PostCreateState> emit,
      ) {
    if (!state.tags.contains(event.tag)) {
      emit(state.copyWith(
        tags: [...state.tags, event.tag],
        status: PostCreateStatus.editing,
      ));
    }
  }

  void _onTagRemoved(
      PostTagRemoved event,
      Emitter<PostCreateState> emit,
      ) {
    final updated = List<String>.from(state.tags)..remove(event.tag);
    emit(state.copyWith(tags: updated, status: PostCreateStatus.editing));
  }

  Future<void> _onPostSubmitted(CreatePost event, Emitter<PostCreateState> emit) async {
    emit(state.copyWith(status: PostCreateStatus.submitting));
    try {
      final post = await postRepository.createPost(
        title: event.post.title??'',
        content: event.post.content??'',
        authorId: event.post.author?.userId ?? '',
        categoryId: event.post.category?.categoryId??'',
        tags: event.post.tags??[],
        images: event.post.image!,
      );

      // print('=====> Created Post: ${post.toMap()} =====');
      emit(state.copyWith(status: PostCreateStatus.success, images: [], tags: []));
    } catch (e) {
      print('----------Error creating post: $e');
      emit(state.copyWith(
        status: PostCreateStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  // void _onPostTagAdded(PostTagAdded event, Emitter<PostCreateState> emit) {
  //   final updatedTags = List<String>.from(state.tags)..add(event.tag);
  //   emit(PostCreateWithTags(images: state.images, tags: updatedTags));
  // }
  //
  // void _onPostTagRemoved(PostTagRemoved event, Emitter<PostCreateState> emit) {
  //   final updatedTags = List<String>.from(state.tags)..remove(event.tag);
  //   emit(PostCreateWithTags(images: state.images, tags: updatedTags));
  // }
  //
  // Future<void> _onPickImages(PickImages event, Emitter<PostCreateState> emit) async {
  //   final ImagePicker picker = ImagePicker();
  //   try {
  //     final picked = await picker.pickMultiImage();
  //     if (picked.isNotEmpty) {
  //       final currentImages = state.images;
  //       emit(PostCreateWithImages(images: [...currentImages, ...picked], tags: state.tags));
  //     }
  //   } catch (e) {
  //     print("Error picking images: $e");
  //   }
  // }
  //
  // void _onRemoveImage(RemoveImage event, Emitter<PostCreateState> emit) {
  //   if (state.images.isNotEmpty) {
  //     final updatedImages = List<XFile>.from(state.images)..removeAt(event.index);
  //     emit(PostCreateWithImages(images: updatedImages, tags: state.tags));
  //   }
  // }
  //
  // Future<void> _onCreatePost(CreatePost event, Emitter<PostCreateState> emit) async {
  //   try {
  //     emit(PostCreateLoading(images: state.images, tags: state.tags));
  //
  //     final post = await postRepository.createPost(
  //       title: event.post.title,
  //       content: event.post.content,
  //       authorId: event.post.author?.userId ?? '',
  //       categoryId: event.post.category?.categoryId??'',
  //       tags: event.post.tags,
  //       images: event.post.image!,
  //     );
  //
  //     print('=====> Created Post: ${post.toMap()} =====');
  //     emit(PostCreateSuccess(images: state.images, tags: state.tags));
  //   } catch (e) {
  //     emit(PostCreateFailure(e.toString(), images: state.images, tags: state.tags));
  //   }
  // }


}