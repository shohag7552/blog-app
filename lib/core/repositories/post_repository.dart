import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:blog_project/core/configuratio/appwrite_config.dart';
import 'package:image_picker/image_picker.dart';
import '../services/appwrite_service.dart';
import '../models/post_model.dart';

class PostRepository {
  final AppwriteService _appwriteService = AppwriteService();

  Future<List<PostModel>> getPosts({
    int limit = 10,
    int offset = 0,
    String? categoryId,
    String? authorId,
  }) async {
    try {
      List<String> queries = [
        Query.limit(limit),
        Query.offset(offset),
        Query.orderDesc('\$createdAt'),
      ];

      if (categoryId != null) {
        queries.add(Query.equal('category', categoryId));
      }

      if (authorId != null) {
        queries.add(Query.equal('author', authorId));
      }

      final response = await _appwriteService.listTable(
        tableId: AppwriteConfig.postsCollection,
        queries: queries,
      );

      /// Likes fetching
      final userId = await _getUserId();
      final likesRes = await _appwriteService.listTable(
        tableId: AppwriteConfig.likes,
        queries: [
          Query.equal('user', userId),
        ],
      );
      final likedPostIds = likesRes.rows.map((doc) => doc.data['post']).toList();

      log('====> Fetched ${response.total} posts with ${likedPostIds} liked posts for user: $userId');

      final postsWithLikes = response.rows.map((post) {
        final isLiked = likedPostIds.contains(post.$id);
        print('===================1111==========> Post ID: ${post.$id}, isLiked: $isLiked');
        final data = {
          'id': post.$id,
          'title': post.data['title'],
          'content': post.data['content'],
          'liked': isLiked ? 1 : 0,
          ...post.data,
        };
        print('===================2222==========> $data');
        return data;
      }).toList();
      return postsWithLikes.map((data) => PostModel.fromMap(data)).toList();
      // return response.rows.map((doc) => PostModel.fromMap(doc.data)).toList();
    } catch (e) {
      throw Exception('Failed to fetch posts: $e');
    }
  }

  Future<PostModel> getPostById(String postId) async {
    try {
      final response = await _appwriteService.getDocument(
        collectionId: AppwriteConfig.postsCollection,
        documentId: postId,
      );

      return PostModel.fromMap(response.data);
    } catch (e) {
      throw Exception('Failed to fetch post: $e');
    }
  }

  Future<PostModel> createPost({
    required String title,
    required String content,
    required String authorId,
    required String categoryId,
    required List<String> tags,
    required List<XFile>? images,
  }) async {
    try {
      List<String> imageUrls = [];
      log('===> Images length: ${images?.length}');
      if(images != null)  {
        for(XFile image in images) {
          log('===> Image path: ${image.path}');
          String? url = await _appwriteService.uploadImage(image);
          if(url != null) {
            imageUrls.add(url);
          }
        }
      }

      User user = await _appwriteService.getCurrentUser();

      final data = {
        'title': title,
        'content': content,
        'author_id': authorId.isNotEmpty ? authorId : user.$id,
        'category_id': categoryId,
        'tags': tags,
        'likes': 0,
        'photos': imageUrls,
        // 'createdAt': now.toIso8601String(),
        // 'updatedAt': now.toIso8601String(),
      };

      print('=====type: ${data['tags'].runtimeType}, value: ${data['tags']} =====');

      final response = await _appwriteService.createRow(
        collectionId: AppwriteConfig.postsCollection, data: data,
      );

      // return PostModel(postId: '', content: '', tags: [], likes: 0, createdAt: DateTime.now(), updatedAt: DateTime.now(), title: '');
      return PostModel.fromMap(response.data);
    } catch (e) {
      log('==> Error creating post: $e');
      throw Exception('Failed to create post: $e');
    }
  }

  Future<PostModel> updatePost({
    required String postId,
    String? title,
    String? content,
    String? categoryId,
    List<String>? tags,
  }) async {
    try {
      Map<String, dynamic> data = {
        'updatedAt': DateTime.now().toIso8601String(),
      };

      if (title != null) data['title'] = title;
      if (content != null) data['content'] = content;
      if (categoryId != null) data['category'] = categoryId;
      if (tags != null) data['tags'] = tags;

      final response = await _appwriteService.updateTable(
        collectionId: AppwriteConfig.postsCollection,
        documentId: postId,
        data: data,
      );

      return PostModel.fromMap(response.data);
    } catch (e) {
      throw Exception('Failed to update post: $e');
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      await _appwriteService.deleteRow(
        collectionId: AppwriteConfig.postsCollection,
        rowId: postId,
      );
    } catch (e) {
      throw Exception('Failed to delete post: $e');
    }
  }

  // Future<void> likePost(String postId, int currentLikes) async {
  //   try {
  //     await _appwriteService.updateTable(
  //       collectionId: AppwriteConfig.postsCollection,
  //       documentId: postId,
  //       data: {'likes': currentLikes + 1},
  //     );
  //   } catch (e) {
  //     throw Exception('Failed to like post: $e');
  //   }
  //
  // }

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

  Future<void> toggleLike(String postId) async {

    // 1️⃣ Find current user doc

    final userDocId = await _getUserId();
    log('====> Current user doc ID: $userDocId');

    // 2️⃣ Check if this user already liked the post
    final existingLikes = await _appwriteService.listTable(
      tableId: AppwriteConfig.likes,
      queries: [
        Query.equal('user', userDocId),
        Query.equal('post', postId),
      ],
    );

    log('====> Existing likes count: ${existingLikes.total}');

    if (existingLikes.rows.isNotEmpty) {
      // Unlike → delete the like document

      await _appwriteService.deleteRow(
        collectionId: AppwriteConfig.likes,
        rowId: existingLikes.rows.first.$id,
      );

      log("====> Unliked post");
    } else {
      // Like → create new like document
      await _appwriteService.createRow(
          collectionId: AppwriteConfig.likes,
          data: {
            'user': userDocId,
            'post': postId,
          });

      log("====> Liked post : $postId , by user: $userDocId");
    }
  }

  Future<int> getLikeCount(String postId) async {
    final likes = _appwriteService.listTable(
      tableId: AppwriteConfig.likes,
      queries: [Query.equal('post', postId)],
    );
    return likes.then((value) => value.total);
  }

  Future<bool> isPostLikedByUser(String postId) async {

    final user = await _appwriteService.getCurrentUser();
    final userDocId = user.$id;

    final existing = await _appwriteService.listTable(
      tableId: AppwriteConfig.likes,
      queries: [
        Query.equal('user', userDocId),
        Query.equal('post', postId),
      ],
    );

    return existing.rows.isNotEmpty;
  }
}