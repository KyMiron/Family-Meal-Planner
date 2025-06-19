import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';
import 'package:meal_planner/models/recipe.dart';
import 'package:meal_planner/models/ingredient.dart';
import 'package:meal_planner/services/database_helper.dart';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  // Initialize FFI before anything else
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  final db = DatabaseHelper();
  final uuid = Uuid();

  group('DatabaseHelper Tests', () {
    late String recipeId;
    late Recipe testRecipe;

    setUp(() {
      recipeId = uuid.v4();
      testRecipe = Recipe(
        id: recipeId,
        title: 'Test Lasagna',
        description: 'Layered pasta dish',
        imagePath: null,
        ingredients: [
          Ingredient(
            id: uuid.v4(),
            name: 'Pasta Sheets',
            quantity: 12,
            unit: 'pieces',
          ),
          Ingredient(
            id: uuid.v4(),
            name: 'Ricotta Cheese',
            quantity: 1.5,
            unit: 'cups',
          ),
        ],
      );
    });

    test('Insert and retrieve recipe', () async {
      await db.insertRecipe(testRecipe);
      List<Recipe> allRecipes = await db.getAllRecipes();
      final found = allRecipes.firstWhere((r) => r.id == recipeId);

      expect(found.title, equals('Test Lasagna'));
      expect(found.ingredients.length, equals(2));
      expect(found.ingredients[0].name, equals('Pasta Sheets'));
    });

    test('Delete recipe', () async {
      await db.deleteRecipe(recipeId);
      List<Recipe> allRecipes = await db.getAllRecipes();
      final exists = allRecipes.any((r) => r.id == recipeId);
      expect(exists, isFalse);
    });
  });
}
