import 'package:image_picker/image_picker.dart';

abstract class PostCreateState {}

class PostCreateInitial extends PostCreateState {}
class PostCreateLoading extends PostCreateState {}
class PostCreateSuccess extends PostCreateState {}
class PostCreateFailure extends PostCreateState {
  final String message;
  PostCreateFailure(this.message);
}
class PostCreateWithImages extends PostCreateState {
  final List<XFile> images;

  PostCreateWithImages({this.images = const []});

  PostCreateWithImages copyWith({List<XFile>? images}) {
    return PostCreateWithImages(
      images: images ?? this.images,
    );
  }
}