import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:blog_project/core/configuratio/appwrite_config.dart';
import 'package:blog_project/core/models/post_model.dart';
import 'package:blog_project/core/services/appwrite_service.dart';

class FavouriteRepository {
  final AppwriteService _appwriteService = AppwriteService();

Future<List<PostModel>?> getFavouritePosts({
    int limit = 10,
    int offset = 0,
    // String? categoryId,
    String? authorId,
  }) async {
    try {
      List<String> queries = [
        Query.limit(limit),
        Query.offset(offset),
        Query.orderDesc('\$createdAt'),
        // Query.select([
        //   '\$id',
        //   // 'user.*',
        //   'post.*', // <-- Use '.*' to fetch all attributes of the related post
        // ]),
      ];

      // if (categoryId != null) {
      //   queries.add(Query.equal('category', categoryId));
      // }

      final userDocId = await _getUserId();

      if (userDocId.isNotEmpty) {
        queries.add(Query.equal('user', userDocId));
        queries.add(Query.select([
          '\$id',
          // 'user.*',
          'post.*', // <-- Use '.*' to fetch all attributes of the related post
        ]),);
      }

      print('=============queries: $queries');
      final response = await _appwriteService.listTable(
        tableId: AppwriteConfig.likes,
        queries: queries,
      );

      final favouritePosts = response.rows.map((likeDoc) {
        final postData = likeDoc.data['post'];

        if (postData is Map<String, dynamic>) {
          final postMap = {
            'id': postData['\$id'],
            'title': postData['title'],
            'content': postData['content'],
            'author_id': postData['author_id'],
            'photos': postData['photos'],
            'category_id': postData['category_id'],
            'tags': postData['tags'],
            'likes': 1,
          };
          return PostModel.fromMap(postMap);
        }
        return null;
      }).whereType<PostModel>().toList();

      print('=============response: ${favouritePosts}');
      return favouritePosts;

      return null;

      /// Likes fetching
      // final userId = await _getUserId();
      // final likesRes = await _appwriteService.listTable(
      //   tableId: AppwriteConfig.likes,
      //   queries: [
      //     Query.equal('user', userId),
      //   ],
      // );
      // final likedPostIds = likesRes.rows.map((doc) => doc.data['post']).toList();

      // final postsWithLikes = response.rows.map((post) {
      //   final isLiked = likedPostIds.contains(post.$id);
      //   final data = {
      //     'id': post.$id,
      //     'title': post.data['title'],
      //     'content': post.data['content'],
      //     'likes': isLiked ? 1 : 0,
      //     'author_id': post.data['author_id'],
      //     'photos': post.data['photos'],
      //     'category_id': post.data['category_id'],
      //     'tags': post.data['tags'],
      //   };
      //   return data;
      // }).toList();

      // return postsWithLikes.map((data) => PostModel.fromMap(data)).toList();
    } catch (e) {
      throw Exception('Failed to fetch posts: $e');
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
}