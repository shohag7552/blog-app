import 'package:blog_project/core/models/post_model.dart';
import 'package:equatable/equatable.dart';

abstract class PostCreateEvent {}

class PickImages extends PostCreateEvent {}
class RemoveImage extends PostCreateEvent {
  final int index;
  RemoveImage(this.index);
}

class CreatePost extends PostCreateEvent {
  final PostModel post;

  CreatePost(this.post);
}