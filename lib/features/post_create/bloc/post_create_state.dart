import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

enum PostCreateStatus { initial, pickingImages, editing, submitting, success, failure }

class PostCreateState extends Equatable {
  final List<XFile> images;
  final List<String> tags;
  final PostCreateStatus status;
  final String? errorMessage;

  const PostCreateState({
    this.images = const [],
    this.tags = const [],
    this.status = PostCreateStatus.initial,
    this.errorMessage,
  });

  PostCreateState copyWith({
    List<XFile>? images,
    List<String>? tags,
    PostCreateStatus? status,
    String? errorMessage,
  }) {
    return PostCreateState(
      images: images ?? this.images,
      tags: tags ?? this.tags,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [images, tags, status, errorMessage];
}
