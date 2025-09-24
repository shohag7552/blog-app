import 'package:blog_project/core/models/post_model.dart';

abstract class PostCreateEvent {}

class CreatePost extends PostCreateEvent {
  final PostModel post;

  CreatePost(this.post);
}