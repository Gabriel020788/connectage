class ActivityHistoryItem {
  const ActivityHistoryItem({
    required this.id,
    required this.title,
    required this.activityType,
    required this.sourceType,
    required this.completedAt,
  });

  final String id;
  final String title;
  final String activityType;
  final String sourceType;
  final DateTime completedAt;

  factory ActivityHistoryItem.fromMap(Map<String, dynamic> map) {
    return ActivityHistoryItem(
      id: map['id'] as String,
      title: map['title'] as String,
      activityType: map['activity_type'] as String,
      sourceType: map['source_type'] as String,
      completedAt: DateTime.parse(map['completed_at'] as String).toLocal(),
    );
  }

  String get emoji => switch (activityType) {
        'medication' => '💊',
        'appointment' => '🩺',
        'water' => '💧',
        'walk' => '🚶',
        'shopping' => '🛒',
        'task' => '✅',
        _ => '📅',
      };
}
