import 'package:appwrite/appwrite.dart';
import 'package:blog_project/core/configuratio/appwrite_config.dart';
import 'package:blog_project/core/models/comment_model.dart';
import 'package:blog_project/core/services/appwrite_service.dart';

class CommentRepository {
  final AppwriteService _appwriteService = AppwriteService();

  Future<List<CommentModel>> getCommentsByPost(String postId) async {
    try {
      final response = await _appwriteService.listDocuments(
        collectionId: AppwriteConfig.commentsCollection,
        queries: [
          Query.equal('post', postId),
          Query.orderDesc('createdAt'),
        ],
      );

      return response.rows.map((doc) => CommentModel.fromMap(doc.data)).toList();
    } catch (e) {
      throw Exception('Failed to fetch comments: $e');
    }
  }

  Future<CommentModel> createComment({
    required String content,
    required String postId,
    required String userId,
  }) async {
    try {
      final data = {
        'content': content,
        'post': postId,
        'user': userId,
        'createdAt': DateTime.now().toIso8601String(),
      };

      final response = await _appwriteService.createDocument(
        collectionId: AppwriteConfig.commentsCollection,
        data: data,
      );

      return CommentModel.fromMap(response.data);
    } catch (e) {
      throw Exception('Failed to create comment: $e');
    }
  }

  Future<void> deleteComment(String commentId) async {
    try {
      await _appwriteService.deleteDocument(
        collectionId: AppwriteConfig.commentsCollection,
        documentId: commentId,
      );
    } catch (e) {
      throw Exception('Failed to delete comment: $e');
    }
  }
}