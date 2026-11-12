import 'package:flutter/material.dart';

import '../../core/brand_colors.dart';
import '../../data/recipe_data.dart';
import '../../widgets/sprite_image.dart';
import 'recipe_detail_screen.dart';

class RecipesScreen extends StatelessWidget {
  const RecipesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Receitas')),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(18, 6, 18, 24),
        itemCount: recipes.length + 1,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          if (index == 0) {
            return Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [BrandColors.orangeSoft, Color(0xFFFFFAF4)],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFFFFDFC0)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 54,
                    height: 54,
                    decoration: const BoxDecoration(
                      color: BrandColors.orange,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.restaurant_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ideias simples para o dia a dia',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Receitas práticas com ingredientes fáceis de encontrar.',
                          style: TextStyle(color: BrandColors.textMuted),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          final recipe = recipes[index - 1];
          return Card(
            clipBehavior: Clip.antiAlias,
            margin: EdgeInsets.zero,
            child: InkWell(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => RecipeDetailScreen(recipe: recipe),
                ),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 126,
                    height: 122,
                    child: SpriteImage(index: recipe.imageIndex),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(14, 14, 8, 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            recipe.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 8,
                            runSpacing: 6,
                            children: [
                              _RecipeTag(
                                icon: Icons.restaurant_menu_rounded,
                                label: recipe.category,
                              ),
                              _RecipeTag(
                                icon: Icons.schedule_rounded,
                                label: '${recipe.minutes} min',
                                orange: true,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Icon(
                      Icons.chevron_right_rounded,
                      color: BrandColors.orange,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _RecipeTag extends StatelessWidget {
  const _RecipeTag({
    required this.icon,
    required this.label,
    this.orange = false,
  });

  final IconData icon;
  final String label;
  final bool orange;

  @override
  Widget build(BuildContext context) {
    final foreground = orange ? BrandColors.orangeStrong : BrandColors.blueStrong;
    final background = orange ? BrandColors.orangeSoft : BrandColors.blueSoft;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: foreground),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: foreground,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
