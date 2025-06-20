class Ingredient {
  final String id;
  final String name;
  final double quantity;
  final String unit; // e.g., "grams", "cups", "pieces"

  Ingredient({
    required this.id,
    required this.name,
    required this.quantity,
    required this.unit,
  });

  Ingredient copyWith({
    String? id,
    String? name,
    double? quantity,
    String? unit,
  }) {
    return Ingredient(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'quantity': quantity, 'unit': unit};
  }

  factory Ingredient.fromMap(Map<String, dynamic> map) {
    return Ingredient(
      id: map['id'],
      name: map['name'],
      quantity: map['quantity'],
      unit: map['unit'],
    );
  }
}
