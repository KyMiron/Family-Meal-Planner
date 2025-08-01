import 'package:flutter/material.dart';
import 'package:meal_planner/models/meal_plan.dart';
import '../services/database_helper.dart';
import 'package:intl/intl.dart';

class MealSelectDialog extends StatefulWidget {
  final String selectedDate;
  const MealSelectDialog({super.key, required this.selectedDate});

  @override
  State<MealSelectDialog> createState() => _MealSelectDialogState();
}

class _MealSelectDialogState extends State<MealSelectDialog> {
  final _db = DatabaseHelper();

  List<MealPlan> mealPlans = [];
  Map<String, String> recipes = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMealPlanInfo();
  }

  Future<void> _loadMealPlanInfo() async {
    mealPlans = await _db.getMealPlansByDate(widget.selectedDate);
    final recipeMaps = await _db.getAllRecipes();
    recipes = {for (var r in recipeMaps) r.id: r.title};
    setState(() {
      isLoading = false;
    });
  }

  void _selectMealPlan(String plan) {
    Navigator.pop(context, plan); // return selected plan
  }

  void _addNew() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Meal Plans for ${DateFormat("MMM/d").format(DateTime.parse(widget.selectedDate))}",
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : mealPlans.isEmpty
            ? const Text("No meal plans for this date.")
            : ListView.builder(
                shrinkWrap: true,
                itemCount: mealPlans.length,
                itemBuilder: (context, index) {
                  final plan = mealPlans[index];
                  return ListTile(
                    title: Text(recipes[plan.recipeId] ?? 'meal'),
                    subtitle: Text(plan.mealType),
                    onTap: () => _selectMealPlan(plan.id),
                  );
                },
              ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, 'cancel'), // Cancel
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: _addNew, // Add new meal plan
          child: const Text("Add New"),
        ),
      ],
    );
  }
}
