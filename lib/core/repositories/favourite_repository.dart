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
      ];

      // if (categoryId != null) {
      //   queries.add(Query.equal('category', categoryId));
      // }

      if (authorId != null) {
        queries.add(Query.equal('user', authorId));
      }

      final response = await _appwriteService.listTable(
        tableId: AppwriteConfig.likes,
        queries: queries,
      );
      
      print('=============response: ${response.rows}');

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
}