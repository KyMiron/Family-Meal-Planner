import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/ingredient.dart';
import '../models/recipe.dart';
import '../services/database_helper.dart';

class RecipeEditorScreen extends StatefulWidget {
  const RecipeEditorScreen({super.key, this.existingRecipe});

  @override
  State<RecipeEditorScreen> createState() => _RecipeEditorScreenState();

  final Recipe? existingRecipe;
}

class _RecipeEditorScreenState extends State<RecipeEditorScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _ingredients = <Ingredient>[];
  final _db = DatabaseHelper();

  void _addIngredientDialog() {
    final nameCtrl = TextEditingController();
    final qtyCtrl = TextEditingController();
    final unitCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Add Ingredient"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: "Name"),
            ),
            TextField(
              controller: qtyCtrl,
              decoration: const InputDecoration(labelText: "Quantity"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: unitCtrl,
              decoration: const InputDecoration(labelText: "Unit"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              final ing = Ingredient(
                id: const Uuid().v4(),
                name: nameCtrl.text,
                quantity: double.tryParse(qtyCtrl.text) ?? 0,
                unit: unitCtrl.text,
              );
              setState(() => _ingredients.add(ing));
              Navigator.pop(context);
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  void _editIngredientDialog(int index, Ingredient ingredient) {
    final nameCtrl = TextEditingController(text: ingredient.name);
    final qtyCtrl = TextEditingController(text: ingredient.quantity.toString());
    final unitCtrl = TextEditingController(text: ingredient.unit);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Ingredient"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: "Name"),
            ),
            TextField(
              controller: qtyCtrl,
              decoration: const InputDecoration(labelText: "Quantity"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: unitCtrl,
              decoration: const InputDecoration(labelText: "Unit"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _ingredients[index] = Ingredient(
                  id: ingredient.id,
                  name: nameCtrl.text,
                  quantity: double.tryParse(qtyCtrl.text) ?? 0,
                  unit: unitCtrl.text,
                );
              });
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void _saveRecipe() async {
    final recipe = Recipe(
      id: widget.existingRecipe?.id ?? const Uuid().v4(),
      title: _titleController.text,
      description: _descriptionController.text,
      imagePath: null,
      ingredients: _ingredients,
    );

    if (widget.existingRecipe == null) {
      await _db.insertRecipe(recipe);
    } else {
      await _db.updateRecipe(recipe);
    }
    if (context.mounted) Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    if (widget.existingRecipe != null) {
      _titleController.text = widget.existingRecipe!.title;
      _descriptionController.text = widget.existingRecipe!.description;
      _ingredients.addAll(widget.existingRecipe!.ingredients);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.existingRecipe != null
            ? const Text("Edit Recipe")
            : Text("New Recipe"),
        actions: widget.existingRecipe != null
            ? [
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    await _db.deleteRecipe(widget.existingRecipe!.id);
                    if (context.mounted) Navigator.pop(context);
                  },
                ),
              ]
            : null,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: "Recipe Title"),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: "Description"),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            const Text(
              "Ingredients",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ..._ingredients.asMap().entries.map((entry) {
              final index = entry.key;
              final ingredient = entry.value;

              return ListTile(
                title: Text(ingredient.name),
                subtitle: Text("${ingredient.quantity} ${ingredient.unit}"),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    setState(() => _ingredients.removeAt(index));
                  },
                ),
                onTap: () {
                  _editIngredientDialog(index, ingredient);
                },
              );
            }),

            TextButton.icon(
              onPressed: _addIngredientDialog,
              icon: const Icon(Icons.add),
              label: const Text("Add Ingredient"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveRecipe,
              child: const Text("Save Recipe"),
            ),
          ],
        ),
      ),
    );
  }
}
