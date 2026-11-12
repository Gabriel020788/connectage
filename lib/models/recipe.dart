class Recipe {
  const Recipe({
    required this.title,
    required this.category,
    required this.minutes,
    required this.imageIndex,
    required this.ingredients,
    required this.steps,
  });

  final String title;
  final String category;
  final int minutes;
  final int imageIndex;
  final List<String> ingredients;
  final List<String> steps;
}
