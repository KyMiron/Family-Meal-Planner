import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/recipe.dart';
import '../models/ingredient.dart';
import '../models/meal_plan.dart';
import '../data/seed_data.dart';
import 'package:uuid/uuid.dart';
import 'database_models.dart' as dm;

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._();
  static Database? _db;

  DatabaseHelper._();

  factory DatabaseHelper() => _instance;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'meal_planner.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ${dm.recipes}
    ''');

    await db.execute('''
      CREATE TABLE ${dm.ingredients}
    ''');

    await db.execute('''
      CREATE TABLE ${dm.mealPlan}
    ''');
  }

  Future<void> resetDatabase() async {
    final dbClient = await db;
    await dbClient.execute('''
      DROP TABLE IF EXISTS recipes
    ''');
    await dbClient.execute('''
      CREATE TABLE ${dm.recipes}
    ''');
    await dbClient.execute('''
      DROP TABLE IF EXISTS ingredients
    ''');
    await dbClient.execute('''
      CREATE TABLE ${dm.ingredients}
    ''');
    await dbClient.execute('''
      DROP TABLE IF EXISTS mealplans
    ''');
    await dbClient.execute('''
      CREATE TABLE ${dm.mealPlan}
    ''');
  }

  Future<void> seedDatabase() async {
    for (final r in recipes) {
      insertRecipe(r);
    }
    for (final m in mealPlans) {
      saveMealPlan(m);
    }
  }

  Future<List> getTable(String tableName) async {
    final dbClient = await db;
    final recipesData = await dbClient.query(tableName);
    return recipesData;
  }

  // Recipe operations
  Future<void> insertRecipe(Recipe recipe) async {
    final dbClient = await db;
    await dbClient.insert('recipes', recipe.toMap());
    for (final ing in recipe.ingredients) {
      await dbClient.insert('ingredients', {
        ...ing.toMap(),
        'recipeId': recipe.id,
      });
    }
  }

  Future<List<Recipe>> getAllRecipes() async {
    final dbClient = await db;
    final recipesData = await dbClient.query('recipes');
    final List<Recipe> recipes = [];

    for (final recipeMap in recipesData) {
      final List<Ingredient> ingredients = [];
      final ingData = await dbClient.query(
        'ingredients',
        where: 'recipeId = ?',
        whereArgs: [recipeMap['id']],
      );
      for (final i in ingData) {
        ingredients.add(Ingredient.fromMap(i));
      }
      recipes.add(Recipe.fromMap({...recipeMap}, ingredients));
    }
    return recipes;
  }

  Future<void> deleteRecipe(String id) async {
    final dbClient = await db;
    await dbClient.delete('recipes', where: 'id = ?', whereArgs: [id]);
    await dbClient.delete(
      'ingredients',
      where: 'recipeId = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateRecipe(Recipe recipe) async {
    final dbClient = await db;
    await dbClient.update(
      'recipes',
      recipe.toMap(),
      where: 'id = ?',
      whereArgs: [recipe.id],
    );
    await dbClient.delete(
      'ingredients',
      where: 'recipeId = ?',
      whereArgs: [recipe.id],
    );
    for (final ing in recipe.ingredients) {
      final newIng = ing.copyWith(id: const Uuid().v4());

      await dbClient.insert('ingredients', {
        ...newIng.toMap(),
        'recipeId': recipe.id,
      });
    }
  }

  Future<void> saveMealPlan(MealPlan mealPlan) async {
    final dbClient = await db; // your openDatabase() method
    await dbClient.insert('mealplans', {...mealPlan.toMap()});
  }

  Future<void> updateMealPlan(MealPlan meal) async {
    final dbClient = await db;
    await dbClient.update(
      'mealplans',
      meal.toMap(),
      where: 'id = ?',
      whereArgs: [meal.id],
    );
  }

  Future<List<MealPlan>> getMealPlansByDate(String date) async {
    final dbClient = await db;
    final result = await dbClient.query(
      'mealplans',
      where: 'date = ?',
      whereArgs: [date],
    );

    return result.map((e) => MealPlan.fromMap(e)).toList();
  }

  Future<MealPlan?> getMealPlanByID(String id) async {
    final dbClient = await db;
    final result = await dbClient.query(
      'mealplans',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return MealPlan.fromMap(result.first);
    }
    return null;
  }

  Future<List<MealPlan>> getAllMealPlans() async {
    final dbClient = await db;
    final result = await dbClient.query('mealplans');
    return result.map((e) => MealPlan.fromMap(e)).toList();
  }
}
