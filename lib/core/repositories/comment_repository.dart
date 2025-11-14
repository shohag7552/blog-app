import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:blog_project/core/configuratio/appwrite_config.dart';
import 'package:blog_project/core/models/comment_model.dart';
import 'package:blog_project/core/services/appwrite_service.dart';

class CommentRepository {
  final AppwriteService _appwriteService = AppwriteService();

  Future<List<CommentModel>> getCommentsByPost(String postId) async {
    try {
      final response = await _appwriteService.listTable(
        tableId: AppwriteConfig.commentsCollection,
        queries: [
          Query.equal('postId', postId),
          Query.orderDesc('\$createdAt'),
        ],
      );

      log('====> Fetched comments count: ${response.total} for postId: $postId');
      return response.rows.map((doc) => CommentModel.fromMap(doc.data)).toList();
    } catch (e) {
      throw Exception('Failed to fetch comments: $e');
    }
  }

  Future<String> _getUserId() async {
    final currentUser = await _appwriteService.getCurrentUser();

    final user = await _appwriteService.listTable(
      tableId: AppwriteConfig.usersCollection,
      queries: [
        Query.equal('userId', currentUser.$id),
      ],
    );
    log('====> Fetched user rows count: ${user.total}');
    final userDocId =  user.rows.isNotEmpty ? user.rows.first.$id : '';
    return userDocId;
  }

  Future<CommentModel?> createComment({
    required String content,
    required String postId,
    required String userId,
  }) async {
    try {
      final userDocId = await _getUserId();
      print('==============create comment , userid: $userDocId, postId: $postId, content: $content');
      if (userDocId.isEmpty) {
        return null;
      }
      final data = {
        'commentText': content,
        'postId': postId,
        'userId': userDocId,
        // 'createdAt': DateTime.now().toIso8601String(),
      };

      final response = await _appwriteService.createRow(
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
      await _appwriteService.deleteRow(
        collectionId: AppwriteConfig.commentsCollection,
        rowId: commentId,
      );
    } catch (e) {
      throw Exception('Failed to delete comment: $e');
    }
  }
}