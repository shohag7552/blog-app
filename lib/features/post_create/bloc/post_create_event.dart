import 'package:blog_project/core/models/post_model.dart';
import 'package:equatable/equatable.dart';

abstract class PostCreateEvent {}

class PickImages extends PostCreateEvent {}
class RemoveImage extends PostCreateEvent {
  final int index;
  RemoveImage(this.index);
}

class PostTagAdded extends PostCreateEvent {
  final String tag;
  PostTagAdded(this.tag);
}

class PostTagRemoved extends PostCreateEvent {
  final String tag;
  PostTagRemoved(this.tag);
}

class CreatePost extends PostCreateEvent {
  final PostModel post;

  CreatePost(this.post);
}