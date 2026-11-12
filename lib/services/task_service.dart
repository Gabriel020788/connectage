import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/task_item.dart';
import 'history_service.dart';

class TaskService {
  final SupabaseClient _client = Supabase.instance.client;
  final HistoryService _history = HistoryService();

  String get _userId => _client.auth.currentUser!.id;

  Future<List<TaskItem>> fetchAll() async {
    final data = await _client
        .from('tasks')
        .select()
        .eq('user_id', _userId)
        .order('created_at', ascending: false);

    return (data as List)
        .map((item) => TaskItem.fromMap(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> create({required String title, required String type}) async {
    await _client.from('tasks').insert({
      'user_id': _userId,
      'title': title.trim(),
      'type': type,
    });
  }

  Future<void> setCompleted(TaskItem item, bool completed) async {
    if (completed && !item.completed) {
      await _history.add(
        sourceType: 'task',
        sourceId: item.id,
        title: item.title,
        activityType: item.type,
      );
    }

    await _client
        .from('tasks')
        .update({'completed': completed})
        .eq('id', item.id)
        .eq('user_id', _userId);
  }

  Future<void> delete(String id) async {
    await _client.from('tasks').delete().eq('id', id).eq('user_id', _userId);
  }
}
