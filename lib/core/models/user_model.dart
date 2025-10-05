// lib/models/user_model.dart
import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String userId;
  final String name;
  final String email;
  final String? bio;
  final String? avatarUrl;
  final String createdAt;
  final String? hashedPassword;

  const UserModel({
    this.id = '',
    required this.userId,
    required this.name,
    required this.email,
    this.bio,
    this.avatarUrl,
    required this.createdAt,
    this.hashedPassword,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['\$id'] ?? '',
      userId: map['userId'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      bio: map['bio'],
      avatarUrl: map['avatarUrl'],
      createdAt: map['createdAt'],
      hashedPassword: map['hashed_password'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'bio': bio,
      'avatarUrl': avatarUrl,
      'createdAt': createdAt,
    };
  }

  @override
  List<Object?> get props => [userId, name, email, bio, avatarUrl, createdAt];
}


