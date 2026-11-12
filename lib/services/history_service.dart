import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/activity_history.dart';

class HistoryService {
  final SupabaseClient _client = Supabase.instance.client;

  String get _userId => _client.auth.currentUser!.id;

  Future<void> add({
    required String sourceType,
    required String sourceId,
    required String title,
    required String activityType,
  }) async {
    await _client.from('activity_history').insert({
      'user_id': _userId,
      'source_type': sourceType,
      'source_id': sourceId,
      'title': title,
      'activity_type': activityType,
    });
  }

  Future<List<ActivityHistoryItem>> fetch({int days = 30}) async {
    final start = DateTime.now().subtract(Duration(days: days));
    final data = await _client
        .from('activity_history')
        .select()
        .eq('user_id', _userId)
        .gte('completed_at', start.toUtc().toIso8601String())
        .order('completed_at', ascending: false);

    return (data as List)
        .map((item) => ActivityHistoryItem.fromMap(item as Map<String, dynamic>))
        .toList();
  }
}
