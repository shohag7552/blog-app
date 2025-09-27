
import 'package:blog_project/core/repositories/post_repository.dart';
import 'package:blog_project/features/post_create/bloc/post_create_event.dart';
import 'package:blog_project/features/post_create/bloc/post_create_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class PostCreateBloc extends Bloc<PostCreateEvent, PostCreateState> {
  final PostRepository postRepository;
  // final CommentRepository commentRepository;

  PostCreateBloc({
    required this.postRepository,
    // required this.commentRepository,
  }) : super(PostCreateInitial()) {
    on<CreatePost>(_onCreatePost);
    on<PickImages>(_onPickImages);
    on<RemoveImage>(_onRemoveImage);
    on<PostTagAdded>(_onPostTagAdded);
    on<PostTagRemoved>(_onPostTagRemoved);
  }

  void _onPostTagAdded(PostTagAdded event, Emitter<PostCreateState> emit) {
    final updatedTags = List<String>.from(state.tags)..add(event.tag);
    emit(PostCreateWithTags(images: state.images, tags: updatedTags));
  }

  void _onPostTagRemoved(PostTagRemoved event, Emitter<PostCreateState> emit) {
    final updatedTags = List<String>.from(state.tags)..remove(event.tag);
    emit(PostCreateWithTags(images: state.images, tags: updatedTags));
  }

  Future<void> _onPickImages(PickImages event, Emitter<PostCreateState> emit) async {
    final ImagePicker picker = ImagePicker();
    try {
      final picked = await picker.pickMultiImage();
      if (picked.isNotEmpty) {
        final currentImages = state.images;
        emit(PostCreateWithImages(images: [...currentImages, ...picked], tags: state.tags));
      }
    } catch (e) {
      print("Error picking images: $e");
    }
  }

  void _onRemoveImage(RemoveImage event, Emitter<PostCreateState> emit) {
    if (state.images.isNotEmpty) {
      final updatedImages = List<XFile>.from(state.images)..removeAt(event.index);
      emit(PostCreateWithImages(images: updatedImages, tags: state.tags));
    }
  }

  Future<void> _onCreatePost(CreatePost event, Emitter<PostCreateState> emit) async {
    try {
      emit(PostCreateLoading(images: state.images, tags: state.tags));

      final post = await postRepository.createPost(
        title: event.post.title,
        content: event.post.content,
        authorId: event.post.author?.userId ?? '',
        categoryId: event.post.category?.categoryId??'',
        tags: event.post.tags,
        images: event.post.image!,
      );

      print('=====> Created Post: ${post.toMap()} =====');
      emit(PostCreateSuccess(images: state.images, tags: state.tags));
    } catch (e) {
      emit(PostCreateFailure(e.toString(), images: state.images, tags: state.tags));
    }
  }


}