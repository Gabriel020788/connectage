class TaskItem {
  const TaskItem({
    required this.id,
    required this.userId,
    required this.title,
    required this.type,
    required this.completed,
  });

  final String id;
  final String userId;
  final String title;
  final String type;
  final bool completed;

  factory TaskItem.fromMap(Map<String, dynamic> map) {
    return TaskItem(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      title: map['title'] as String,
      type: map['type'] as String,
      completed: (map['completed'] as bool?) ?? false,
    );
  }
}
