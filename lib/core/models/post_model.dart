
// lib/models/post_model.dart
import 'package:blog_project/core/models/category_model.dart';
import 'package:blog_project/core/models/user_model.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

class PostModel extends Equatable {
  final String postId;
  final String title;
  final String content;
  final UserModel? author;
  final CategoryModel? category;
  final List<String> tags;
  final int likes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<XFile>? image;

  const PostModel({
    required this.postId,
    required this.title,
    required this.content,
    this.author,
    this.category,
    required this.tags,
    required this.likes,
    required this.createdAt,
    required this.updatedAt,
    this.image,
  });

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      postId: map['\$id'] ?? '',
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      author: map['author'] != null ? UserModel.fromMap(map['author']) : null,
      category: map['category'] != null ? CategoryModel.fromMap(map['category']) : null,
      tags: List<String>.from(map['tags'] ?? []),
      likes: map['likes'] ?? 0,
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(map['updatedAt'] ?? DateTime.now().toIso8601String()),
      image: map['image'] != null ? [XFile(map['image'])] : null
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'author': author?.userId,
      'category': category?.categoryId,
      'tags': tags,
      'likes': likes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'image': image?.map((img) => img.path).toList(),
    };
  }

  @override
  List<Object?> get props => [postId, title, content, author, category, tags, likes, createdAt, updatedAt, image];
}
