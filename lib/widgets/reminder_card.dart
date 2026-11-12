import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/reminder.dart';

class ReminderCard extends StatelessWidget {
  const ReminderCard({
    super.key,
    required this.reminder,
    required this.onComplete,
    this.onDelete,
  });

  final Reminder reminder;
  final VoidCallback onComplete;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final time = DateFormat('HH:mm').format(reminder.scheduledAt);

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(reminder.emoji, style: const TextStyle(fontSize: 30)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$time • ${reminder.typeLabel}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        reminder.title,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      if (reminder.recurrence == 'daily') ...[
                        const SizedBox(height: 6),
                        const Text('Repete todos os dias'),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onComplete,
              icon: const Icon(Icons.check_circle_outline),
              label: const Text('Marcar como concluído'),
            ),
            if (onDelete != null)
              TextButton.icon(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline),
                label: const Text('Excluir lembrete'),
              ),
          ],
        ),
      ),
    );
  }
}
