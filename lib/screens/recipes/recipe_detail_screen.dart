import 'package:flutter/material.dart';

import '../../models/recipe.dart';
import '../../widgets/sprite_image.dart';

class RecipeDetailScreen extends StatelessWidget {
  const RecipeDetailScreen({super.key, required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(recipe.title)),
      body: ListView(
        children: [
          AspectRatio(
            aspectRatio: 16 / 10,
            child: SpriteImage(index: recipe.imageIndex),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  children: [
                    Chip(label: Text(recipe.category)),
                    Chip(label: Text('${recipe.minutes} min')),
                  ],
                ),
                const SizedBox(height: 14),
                Text('Ingredientes', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                ...recipe.ingredients.map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 7),
                      child: Text('• $item'),
                    )),
                const SizedBox(height: 18),
                Text('Modo de preparo', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                ...recipe.steps.indexed.map((entry) => Padding(
                      padding: const EdgeInsets.only(bottom: 9),
                      child: Text('${entry.$1 + 1}. ${entry.$2}'),
                    )),
                const SizedBox(height: 18),
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'Sugestão culinária geral. Ajuste ingredientes às suas necessidades, alergias e orientações profissionais.',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
