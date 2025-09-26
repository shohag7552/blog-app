// lib/services/appwrite_service.dart
import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:blog_project/core/configuratio/appwrite_config.dart';
import 'package:image_picker/image_picker.dart';

class AppwriteService {
  late final Client client;
  late final TablesDB databases;
  late final Account account;
  late final Storage storage;
  static final AppwriteService _instance = AppwriteService._internal();

  factory AppwriteService() => _instance;

  AppwriteService._internal() {
    client = Client()
        .setEndpoint(AppwriteConfig.endpoint)
        .setProject(AppwriteConfig.projectId);

    databases = TablesDB(client);
    account = Account(client);
    storage = Storage(client);
  }

  // Database operations
  Future<Row> createDocument({
    required String collectionId,
    required Map<String, dynamic> data,
    String? documentId,
  }) async {
    final user = await account.get();
    print('====> database: ${AppwriteConfig.databaseId}, tableId: $collectionId, rowId: $documentId and  with data: $data');
    // return await databases.createRow(databaseId: databaseId, tableId: tableId, rowId: rowId, data: data)
    return await databases.createRow(
      databaseId: AppwriteConfig.databaseId,
      tableId: collectionId,
      rowId: documentId ?? ID.unique(),
      data: data,
      permissions: [
        // Permission.read(Role.user(user.$id)),   // only this user can read
        // Permission.update(Role.user(user.$id)), // only this user can update
        // Permission.delete(Role.user(user.$id)), // only this user can delete
        Permission.write(Role.user(user.$id)),  // only this user can write
      ],
    );
  }

  Future<Row> getDocument({
    required String collectionId,
    required String documentId,
  }) async {
    return await databases.getRow(
      databaseId: AppwriteConfig.databaseId,
      tableId: collectionId,
      rowId: documentId,
    );
  }

  Future<RowList> listDocuments({
    required String collectionId,
    List<String>? queries,
  }) async {
    return await databases.listRows(
      databaseId: AppwriteConfig.databaseId,
      tableId: collectionId,
      queries: queries ?? [],
    );
  }

  Future<Row> updateDocument({
    required String collectionId,
    required String documentId,
    required Map<String, dynamic> data,
  }) async {
    return await databases.updateRow(
      databaseId: AppwriteConfig.databaseId,
      tableId: collectionId,
      rowId: documentId,
      data: data,
    );
  }

  Future<void> deleteDocument({
    required String collectionId,
    required String documentId,
  }) async {
    return await databases.deleteRow(
      databaseId: AppwriteConfig.databaseId,
      tableId: collectionId,
      rowId: documentId,
    );
  }

  /// Authentication

  Future<User> getCurrentUser() async {
    return await account.get();
  }

  Future<void> signUp({required String email, required String password, required String name}) async {
    log('====> SignUp request- email:$email, name:$name, password:$password');
    await account.create(userId: ID.unique(), email: email, password: password, name: name);
  }

  Future<void> signIn({required String email, required String password}) async {
    log('====> signIn request- email:$email, password:$password');

    await account.createEmailPasswordSession(email: email, password: password);
  }

  Future<void> signOut() async {
    await account.deleteSession(sessionId: 'current');
  }

  Future<void> updateName({required String name}) async {
    await account.updateName(name: name);
  }

  Future<void> updatePassword({required String password, required String oldPassword}) async {
    await account.updatePassword(password: password, oldPassword: oldPassword);
  }

  Future<(String? url, String? fileId)> uploadImage(XFile file) async {
    try {
      final result = await storage.createFile(
        bucketId: AppwriteConfig.postsBucketId,     // Create bucket in Appwrite console
        fileId: ID.unique(),            // Auto-generate unique ID
        file: InputFile.fromPath(
          path: file.path,
          filename: file.path.split('/').last,
        ),
        permissions: [ Permission.read(Role.any()) ],
      );

      // Return uploaded file ID
      log("Upload successful: ${result.$id} // ${result.toMap()}");
      // Construct a direct view/preview URL (public if bucket/file perms allow it)
      final fileUrl = 'https://cloud.appwrite.io/v1/storage/buckets/${AppwriteConfig.postsBucketId}/files/${result.$id}/view?project=${AppwriteConfig.projectId}';

      log(fileUrl);
      return (fileUrl, result.$id);
    } catch (e) {
      print("Upload error: $e");
      return (null, null);
    }
  }

  Future<void> deleteImage(String fileId) async {
    try {
      await storage.deleteFile(
        bucketId: AppwriteConfig.postsBucketId,
        fileId: fileId,
      );
      print("Image deleted from storage.");
    } catch (e) {
      print("Delete error: $e");
    }
  }
  // String getImageUrl(String fileId) {
  //   return storage.getFileView(
  //     bucketId: "YOUR_BUCKET_ID",
  //     fileId: fileId,
  //   ).href;
  // }


// Future<Map<String, dynamic>?> uploadXFileAndSave(XFile xfile, {String? userId}) async {
  //   try {
  //     // Build InputFile correctly for web vs mobile
  //     late InputFile input;
  //     if (kIsWeb) {
  //       final bytes = await xfile.readAsBytes(); // required on web
  //       input = InputFile.fromBytes(bytes: bytes, filename: xfile.name);
  //     } else {
  //       // mobile/desktop: path is available
  //       if (xfile.path == null || xfile.path!.isEmpty) {
  //         throw Exception('Invalid file path on non-web platform');
  //       }
  //       input = InputFile.fromPath(path: xfile.path!, filename: xfile.name);
  //     }
  //
  //     // Upload file
  //     final uploadedFile = await storage.createFile(
  //       bucketId: BUCKET_ID,
  //       fileId: ID.unique(),
  //       file: input,
  //       // Optional: set file-level permissions; remove or adjust as needed
  //       // permissions: [ Permission.read(Role.any()) ],
  //     );
  //
  //     final fileId = uploadedFile.$id;
  //
  //     // Construct a direct view/preview URL (public if bucket/file perms allow it)
  //     final fileUrl =
  //         'https://cloud.appwrite.io/v1/storage/buckets/$BUCKET_ID/files/$fileId/view?project=$PROJECT_ID';
  //     // If you use a custom endpoint, replace cloud.appwrite.io with your endpoint domain.
  //
  //     // Save metadata to database (optional)
  //     final doc = await databases.createDocument(
  //       databaseId: DATABASE_ID,
  //       collectionId: COLLECTION_ID,
  //       documentId: ID.unique(),
  //       data: {
  //         'fileId': fileId,
  //         'fileName': xfile.name,
  //         'fileUrl': fileUrl,
  //         'uploaderId': userId ?? 'anonymous',
  //         'createdAt': DateTime.now().toIso8601String(),
  //       },
  //     );
  //
  //     return {
  //       'fileId': fileId,
  //       'fileUrl': fileUrl,
  //       'document': doc,
  //     };
  //   } on AppwriteException catch (e) {
  //     // Appwrite-specific errors give helpful fields
  //     print('AppwriteException: ${e.code} ${e.message} ${e.response}');
  //     return null;
  //   } catch (e) {
  //     print('Upload error: $e');
  //     return null;
  //   }
  // }
}