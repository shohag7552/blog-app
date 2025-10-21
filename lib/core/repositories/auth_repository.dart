import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:appwrite/models.dart';
import 'package:blog_project/core/configuratio/appwrite_config.dart';
import 'package:blog_project/core/services/appwrite_service.dart';
import '../di/service_locator.dart';
import '../models/user_model.dart';

class AuthRepository {
  // final Account _account = getIt<Account>();
  final AppwriteService _appwriteService = AppwriteService();
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = await _appwriteService.getCurrentUser();
      return UserModel(userId: user.$id, name: user.name, email: user.email, hashedPassword: user.password, createdAt: user.$createdAt);
    } on AppwriteException catch (e) {
      if (e.code == 401) {
        return null;
        // return UserModel(userId: '', name: '', email: '', createdAt: '');
      }
      rethrow;
    }
  }

  Future<void> register({required String email, required String password, required String name}) async {
    try {
      await _appwriteService.signUp(
        email: email,
        password: password,
        name: name,
      );

      // return await getCurrentUser();

    } on AppwriteException {
      rethrow;
    }
  }

  Future<UserModel?> login({required String email, required String password}) async {
    try {
      await _appwriteService.signIn(email: email, password: password);
      return await getCurrentUser();

    } on AppwriteException {
      rethrow;
    }
  }

  Future<bool> uploadUser({required UserModel user}) async {
    try {

      final data = {
        'userId': user.userId,
        'username': user.name,
        'email': user.email,
        'isActive': false,
        'hashedPassword': user.hashedPassword??'#',
      };

      // // 1. Check if user already exists
      // final result = await _appwriteService.listTable(
      //   collectionId: AppwriteConfig.usersCollection,
      //   queries: [Query.equal('userId', user.userId)],
      // );
      // print('===> User exists check: ${result.total}');

      UserModel? existingUser = await getUserById(user.userId);

      if (existingUser != null) {
        /// User exists → Update
        // final docId = result.rows.first.$id;
        await _appwriteService.updateTable(
          tableId: AppwriteConfig.usersCollection,
          rowId: existingUser.id,
          data: data,
        );
      } else {
        /// User doesn’t exist → Create
        await _appwriteService.createRow(
          collectionId: AppwriteConfig.usersCollection, data: data,
        );
      }

      return true;
    } catch (e) {
      log('==> Error uploading user: $e');
      throw Exception('Failed to uploading user: $e');
    }
  }

  Future<UserModel?> getUserById(String userId) async {
    try {
      log('==> Fetching user by ID: $userId');

      final result = await _appwriteService.listTable(
        tableId: AppwriteConfig.usersCollection,
        queries: [Query.equal('userId', userId)],
      );

      if (result.total > 0) {
        final doc = result.rows.first;
        print('===> Fetched user : ${doc.data}');
        return UserModel(
          id: doc.$id,
          userId: doc.data['userId'],
          name: doc.data['username'],
          email: doc.data['email'],
          hashedPassword: doc.data['hashedPassword'],
          createdAt: doc.$createdAt,
        );
      } else {
        return null;
      }
    } catch (e) {
      log('==> Error getting user by ID: $e');
      throw Exception('Failed to get user by ID: $e');
    }
  }

  Future<void> logout() async {
    try {
      await _appwriteService.signOut();
    } on AppwriteException {
      rethrow;
    }
  }

  Future<void> updateName({required String name}) async {
    try {
      await _appwriteService.updateName(name: name);
    } on AppwriteException {
      rethrow;
    }
  }

  Future<void> updatePassword({required String password, required String oldPassword}) async {
    try {
      await _appwriteService.updatePassword(
        password: password,
        oldPassword: oldPassword,
      );
    } on AppwriteException {
      rethrow;
    }
  }
}