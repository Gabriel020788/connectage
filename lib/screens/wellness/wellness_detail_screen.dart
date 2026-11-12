import 'package:flutter/material.dart';

import '../../data/wellness_data.dart';
import '../../widgets/sprite_image.dart';

class WellnessDetailScreen extends StatelessWidget {
  const WellnessDetailScreen({
    super.key,
    required this.suggestion,
  });

  final WellnessSuggestion suggestion;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(suggestion.title)),
      body: ListView(
        children: [
          AspectRatio(
            aspectRatio: 16 / 10,
            child: SpriteImage(index: suggestion.imageIndex),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  suggestion.description,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 24),
                _SectionTitle(
                  icon: Icons.favorite_outline,
                  text: 'Benefícios',
                ),
                const SizedBox(height: 10),
                ...suggestion.benefits.map(
                  (item) => _Bullet(text: item),
                ),
                const SizedBox(height: 22),
                _SectionTitle(
                  icon: Icons.lightbulb_outline,
                  text: 'Como colocar em prática',
                ),
                const SizedBox(height: 10),
                ...suggestion.howTo.indexed.map(
                  (entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 14,
                          child: Text('${entry.$1 + 1}'),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            entry.$2,
                            style: const TextStyle(fontSize: 17),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.info_outline),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Atenção',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 6),
                              Text(suggestion.attention),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Conteúdo educativo geral. As sugestões não substituem avaliação, diagnóstico ou orientação individual de profissionais de saúde.',
                  style: TextStyle(fontSize: 13),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 28),
        const SizedBox(width: 10),
        Text(text, style: Theme.of(context).textTheme.titleLarge),
      ],
    );
  }
}

class _Bullet extends StatelessWidget {
  const _Bullet({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 7),
            child: Icon(Icons.circle, size: 8),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 17),
            ),
          ),
        ],
      ),
    );
  }
}
