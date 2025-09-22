
import 'package:equatable/equatable.dart';

class CategoryModel extends Equatable {
  final String categoryId;
  final String name;
  final String description;
  final String color;

  const CategoryModel({
    required this.categoryId,
    required this.name,
    required this.description,
    required this.color,
  });

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      categoryId: map['\$id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      color: map['color'] ?? '#000000',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'color': color,
    };
  }

  @override
  List<Object?> get props => [categoryId, name, description, color];
}