import 'package:blog_project/core/models/post_model.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

abstract class PostCreateEvent  extends Equatable{
  const PostCreateEvent();

  @override
  List<Object?> get props => [];
}

class PostImagesPicked extends PostCreateEvent {
  const PostImagesPicked();

  @override
  List<Object?> get props => [];
}

class PostImageRemoved extends PostCreateEvent {
  final int index;
  const PostImageRemoved(this.index);

  @override
  List<Object?> get props => [index];
}

/// Tag events
class PostTagAdded extends PostCreateEvent {
  final String tag;
  const PostTagAdded(this.tag);

  @override
  List<Object?> get props => [tag];
}

class PostTagRemoved extends PostCreateEvent {
  final String tag;
  const PostTagRemoved(this.tag);

  @override
  List<Object?> get props => [tag];
}

class CreatePost extends PostCreateEvent {
  final PostModel post;

  const CreatePost(this.post);
  @override
  List<Object?> get props => [post];
}