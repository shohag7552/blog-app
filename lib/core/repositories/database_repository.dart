// import 'package:appwrite/appwrite.dart';
// import 'package:appwrite/models.dart' as models;
// import '../di/service_locator.dart';
// import '../services/appwrite_service.dart';
// import '../models/post_model.dart';
//
// class DatabaseRepository {
//   final Databases _databases = getIt<Databases>();
//
//   Future<List<PostModel>> getPosts() async {
//     try {
//       final documents = await _databases.listDocuments(
//         databaseId: AppwriteConstants.databaseId,
//         collectionId: AppwriteConstants.postsCollection,
//         queries: [
//           Query.orderDesc('\$createdAt'),
//           Query.limit(50),
//         ],
//       );
//
//       return documents.documents
//           .map((doc) => PostModel.fromDocument(doc))
//           .toList();
//     } on AppwriteException {
//       rethrow;
//     }
//   }
//
//   Future<PostModel> createPost({
//     required String title,
//     required String content,
//     required String userId,
//   }) async {
//     try {
//       final document = await _databases.createDocument(
//         databaseId: AppwriteConstants.databaseId,
//         collectionId: AppwriteConstants.postsCollection,
//         documentId: ID.unique(),
//         data: {
//           'title': title,
//           'content': content,
//           'userId': userId,
//         },
//       );
//
//       return PostModel.fromDocument(document);
//     } on AppwriteException {
//       rethrow;
//     }
//   }
//
//   Future<PostModel> updatePost({
//     required String postId,
//     required String title,
//     required String content,
//   }) async {
//     try {
//       final document = await _databases.updateDocument(
//         databaseId: AppwriteConstants.databaseId,
//         collectionId: AppwriteConstants.postsCollection,
//         documentId: postId,
//         data: {
//           'title': title,
//           'content': content,
//         },
//       );
//
//       return PostModel.fromDocument(document);
//     } on AppwriteException {
//       rethrow;
//     }
//   }
//
//   Future<void> deletePost({required String postId}) async {
//     try {
//       await _databases.deleteDocument(
//         databaseId: AppwriteConstants.databaseId,
//         collectionId: AppwriteConstants.postsCollection,
//         documentId: postId,
//       );
//     } on AppwriteException {
//       rethrow;
//     }
//   }
//
//   // Real-time subscription
//   Stream<models.RealtimeMessage> subscribeToPostChanges() {
//     final realtime = Realtime(getIt<Client>());
//     return realtime.subscribe([
//       'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.postsCollection}.documents'
//     ]);
//   }
// }