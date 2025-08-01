import '../models/recipe.dart';
import '../models/ingredient.dart';
import '../models/meal_plan.dart';

final recipes = [
  Recipe(
    id: 'r1',
    title: 'Spaghetti Bolognese',
    description: 'Classic spaghetti with rich meat sauce.',
    ingredients: [
      Ingredient(id: 'i1', name: 'Spaghetti', quantity: 200, unit: 'grams'),
      Ingredient(id: 'i2', name: 'Ground Beef', quantity: 300, unit: 'grams'),
      Ingredient(id: 'i3', name: 'Tomato Sauce', quantity: 1, unit: 'cup'),
    ],
  ),
  Recipe(
    id: 'r2',
    title: 'Chicken Caesar Salad',
    description: 'Crisp romaine with grilled chicken and Caesar dressing.',
    ingredients: [
      Ingredient(id: 'i4', name: 'Romaine Lettuce', quantity: 2, unit: 'cups'),
      Ingredient(
        id: 'i5',
        name: 'Grilled Chicken',
        quantity: 150,
        unit: 'grams',
      ),
      Ingredient(id: 'i6', name: 'Caesar Dressing', quantity: 3, unit: 'tbsp'),
    ],
  ),
  Recipe(
    id: 'r3',
    title: 'Vegetable Stir Fry',
    description: 'Quick stir-fried vegetables with soy sauce.',
    ingredients: [
      Ingredient(id: 'i7', name: 'Broccoli', quantity: 1, unit: 'cup'),
      Ingredient(id: 'i8', name: 'Carrots', quantity: 1, unit: 'cup'),
      Ingredient(id: 'i9', name: 'Soy Sauce', quantity: 2, unit: 'tbsp'),
    ],
  ),
];
final now = DateTime.now().toUtc();
DateTime setDate = DateTime.utc(now.year, now.month, now.day, 0, 0, 0, 0, 0);
final mealPlans = [
  MealPlan(
    id: 'm1',
    recipeId: 'r1',
    date: setDate.toIso8601String(), // today
    mealType: 'dinner',
  ),
  MealPlan(
    id: 'm2',
    recipeId: 'r2',
    date: setDate.toIso8601String(), // today
    mealType: 'lunch',
  ),
  MealPlan(
    id: 'm3',
    recipeId: 'r3',
    date: setDate.add(Duration(days: 1)).toIso8601String(),
    mealType: 'dinner',
  ),
];
