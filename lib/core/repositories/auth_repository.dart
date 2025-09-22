import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:blog_project/core/services/appwrite_service.dart';
import '../di/service_locator.dart';
import '../models/user_model.dart';

class AuthRepository {
  // final Account _account = getIt<Account>();
  final AppwriteService _appwriteService = AppwriteService();
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = await _appwriteService.getCurrentUser();
      return UserModel(userId: user.$id, name: user.name, email: user.email, createdAt: user.$createdAt);
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