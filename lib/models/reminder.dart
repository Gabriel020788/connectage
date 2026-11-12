class Reminder {
  const Reminder({
    required this.id,
    required this.userId,
    required this.title,
    required this.type,
    required this.scheduledAt,
    required this.recurrence,
    required this.completed,
    this.notes,
  });

  final String id;
  final String userId;
  final String title;
  final String type;
  final DateTime scheduledAt;
  final String recurrence;
  final bool completed;
  final String? notes;

  factory Reminder.fromMap(Map<String, dynamic> map) {
    return Reminder(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      title: map['title'] as String,
      type: map['type'] as String,
      scheduledAt: DateTime.parse(map['scheduled_at'] as String).toLocal(),
      recurrence: (map['recurrence'] as String?) ?? 'none',
      completed: (map['completed'] as bool?) ?? false,
      notes: map['notes'] as String?,
    );
  }

  String get emoji => switch (type) {
        'medication' => '💊',
        'appointment' => '🩺',
        'water' => '💧',
        'walk' => '🚶',
        _ => '📅',
      };

  String get typeLabel => switch (type) {
        'medication' => 'Medicamento',
        'appointment' => 'Consulta',
        'water' => 'Água',
        'walk' => 'Caminhada',
        _ => 'Compromisso',
      };
}
