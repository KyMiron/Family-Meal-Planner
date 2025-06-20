class MealPlan {
  final String id;
  final String date; // ISO format: "2025-06-18"
  final String recipeId;

  MealPlan({required this.id, required this.date, required this.recipeId});

  Map<String, dynamic> toMap() {
    return {'id': id, 'date': date, 'recipeId': recipeId};
  }

  factory MealPlan.fromMap(Map<String, dynamic> map) {
    return MealPlan(
      id: map['id'],
      date: map['date'],
      recipeId: map['recipeId'],
    );
  }
}
