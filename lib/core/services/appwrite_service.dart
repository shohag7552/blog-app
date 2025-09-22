// lib/services/appwrite_service.dart
import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:blog_project/core/configuratio/appwrite_config.dart';

class AppwriteService {
  late final Client client;
  late final TablesDB databases;
  late final Account account;
  static final AppwriteService _instance = AppwriteService._internal();

  factory AppwriteService() => _instance;

  AppwriteService._internal() {
    client = Client()
        .setEndpoint(AppwriteConfig.endpoint)
        .setProject(AppwriteConfig.projectId);

    databases = TablesDB(client);
    account = Account(client);
  }

  // Database operations
  Future<Row> createDocument({
    required String collectionId,
    required Map<String, dynamic> data,
    String? documentId,
  }) async {
    // return await databases.createRow(databaseId: databaseId, tableId: tableId, rowId: rowId, data: data)
    return await databases.createRow(
      databaseId: AppwriteConfig.databaseId,
      tableId: collectionId,
      rowId: documentId ?? ID.unique(),
      data: data,
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
}