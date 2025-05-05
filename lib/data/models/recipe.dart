class Recipe {
  final String id;
  final String name;
  final String desc;
  final List<String> steps;
  final List<String> ingredients;
  final Map<String, String> nutritions;

  Recipe({
    required this.id,
    required this.name,
    required this.desc,
    required this.ingredients,
    required this.steps,
    required this.nutritions,
  });

  factory Recipe.fromMap(String id, Map<String, dynamic> map) {
    return Recipe(
      id: id,
      name: map['name'] ?? '',
      desc: map['desc'] ?? '',
      ingredients: map['ingredients'] ?? '',
      steps: map['steps'] ?? '',
      nutritions: map['nutritions'] ?? '',
    );
  }
}
