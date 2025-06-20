import 'ingredient.dart';

class Recipe {
  final String id;
  final String title;
  final String description;
  final List<Ingredient> ingredients;
  final String? imagePath; // Local file path

  Recipe({
    required this.id,
    required this.title,
    required this.description,
    this.ingredients = const [],
    this.imagePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imagePath': imagePath,
      //'ingredients': ingredients.map((i) => i.toMap()).toList(),
    };
  }

  factory Recipe.fromMap(
    Map<String, dynamic> map,
    List<Ingredient> ingredients,
  ) => Recipe(
    id: map['id'],
    title: map['title'],
    description: map['description'],
    imagePath: map['imagePath'],
    ingredients: ingredients,
  );
}
