import 'package:image_picker/image_picker.dart';

abstract class PostCreateState {
  final List<XFile> images;
  final List<String> tags;

  const PostCreateState({this.images = const [], this.tags = const []});
}

class PostCreateInitial extends PostCreateState {}

class PostCreateLoading extends PostCreateState {
  const PostCreateLoading({super.images, super.tags});
}
class PostCreateSuccess extends PostCreateState {
  const PostCreateSuccess({super.images, super.tags});
}
class PostCreateFailure extends PostCreateState {
  final String message;
  const PostCreateFailure(this.message, {super.images, super.tags});
}
class PostCreateWithImages extends PostCreateState {
  const PostCreateWithImages({required super.images, super.tags});
}
class PostCreateWithTags extends PostCreateState {
  const PostCreateWithTags({super.images, required super.tags});
}