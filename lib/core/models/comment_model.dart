
// lib/models/comment_model.dart
import 'package:blog_project/core/models/user_model.dart';
import 'package:equatable/equatable.dart';

class CommentModel extends Equatable {
  final String commentId;
  final String content;
  final String postId;
  final UserModel user;
  final DateTime createdAt;

  const CommentModel({
    required this.commentId,
    required this.content,
    required this.postId,
    required this.user,
    required this.createdAt,
  });

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      commentId: map['\$id'] ?? '',
      content: map['commentText'] ?? '',
      postId: map['postId'] ?? '',
      user: UserModel.fromMap(map['user']),
      createdAt: map['\$createdAt'] != null
          ? DateTime.parse(map['\$createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'post': postId,
      'user': user.userId,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [commentId, content, postId, user, createdAt];
}