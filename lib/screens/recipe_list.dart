import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../services/database_helper.dart';
import 'recipe_editor.dart';

class RecipeListScreen extends StatefulWidget {
  const RecipeListScreen({super.key});

  @override
  State<RecipeListScreen> createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  final _db = DatabaseHelper();
  late Future<List<Recipe>> _recipesFuture;

  @override
  void initState() {
    super.initState();
    _loadRecipes();
  }

  void _loadRecipes() {
    setState(() {
      _recipesFuture = _db.getAllRecipes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Recipe>>(
        future: _recipesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No recipes found."));
          }

          final recipes = snapshot.data!;
          return ListView.builder(
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              final recipe = recipes[index];
              return ListTile(
                title: Text(recipe.title),
                subtitle: Text(recipe.description),
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          RecipeEditorScreen(existingRecipe: recipe),
                    ),
                  );
                  _loadRecipes(); // refresh after editing
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const RecipeEditorScreen()),
          );
          _loadRecipes(); // Refresh after returning
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
