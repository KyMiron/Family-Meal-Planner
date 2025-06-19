import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/recipe.dart';
import '../models/ingredient.dart';

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
      CREATE TABLE recipes (
        id TEXT PRIMARY KEY,
        title TEXT,
        description TEXT,
        imagePath TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE ingredients (
        id TEXT PRIMARY KEY,
        recipeId TEXT,
        name TEXT,
        quantity REAL,
        unit TEXT,
        FOREIGN KEY(recipeId) REFERENCES recipes(id) ON DELETE CASCADE
      )
    ''');
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

  // Optional: Update logic
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
      await dbClient.insert('ingredients', {
        ...ing.toMap(),
        'recipeId': recipe.id,
      });
    }
  }
}
