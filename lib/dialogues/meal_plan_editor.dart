import 'package:flutter/material.dart';
import 'package:meal_planner/models/recipe.dart';
import 'package:meal_planner/models/meal_plan.dart';
import '../services/database_helper.dart';
import 'package:uuid/uuid.dart';

class MealPlanEditor extends StatefulWidget {
  const MealPlanEditor({
    super.key,
    required this.selectedDate,
    this.mealPlanId,
  });

  @override
  State<MealPlanEditor> createState() => _MealPlanEditorState();

  final String selectedDate;
  final String? mealPlanId;
}

class _MealPlanEditorState extends State<MealPlanEditor> {
  final _db = DatabaseHelper();

  List<Recipe> recipes = [];
  MealPlan? existing;
  String? selectedType;
  String? selectedRecipe;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMealPlanInfo();
  }

  Future<void> _loadMealPlanInfo() async {
    recipes = await _db.getAllRecipes();
    if (widget.mealPlanId != null) {
      existing = await _db.getMealPlanByID(widget.mealPlanId!);
    }

    setState(() {
      if (existing != null) {
        selectedType = existing!.mealType;
        selectedRecipe = existing!.recipeId;
      }
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Add Meal Plan"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButton<String>(
            hint: const Text("Meal Type"),
            value: selectedType,
            isExpanded: true,
            items: ['breakfast', 'lunch', 'dinner']
                .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                .toList(),
            onChanged: (val) => setState(() => selectedType = val),
          ),
          DropdownButton<String>(
            hint: const Text("Recipe"),
            value: selectedRecipe,
            isExpanded: true,
            items: recipes.map((r) {
              return DropdownMenuItem(value: r.id, child: Text(r.title));
            }).toList(),
            onChanged: (val) => setState(() => selectedRecipe = val),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () async {
            if (selectedType != null && selectedRecipe != null) {
              final mealPlan = MealPlan(
                id: existing?.id ?? const Uuid().v4(),
                date: widget.selectedDate,
                recipeId: selectedRecipe!,
                mealType: selectedType!,
              );
              if (existing != null) {
                _db.updateMealPlan(
                  MealPlan(
                    id: existing!.id,
                    date: existing!.date,
                    recipeId: selectedRecipe!,
                    mealType: selectedType!,
                  ),
                );
              } else {
                _db.saveMealPlan(mealPlan);
              }
              Navigator.pop(context);
            }
          },
          child: const Text("Save"),
        ),
      ],
    );
  }
}
