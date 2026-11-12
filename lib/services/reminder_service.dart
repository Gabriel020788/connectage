import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/reminder.dart';
import 'history_service.dart';
import 'notification_service.dart';

class ReminderService {
  final SupabaseClient _client = Supabase.instance.client;
  final HistoryService _history = HistoryService();

  String get _userId => _client.auth.currentUser!.id;

  Future<List<Reminder>> fetchAll() async {
    final data = await _client
        .from('reminders')
        .select()
        .eq('user_id', _userId)
        .eq('completed', false)
        .order('scheduled_at');

    return (data as List)
        .map((item) => Reminder.fromMap(item as Map<String, dynamic>))
        .toList();
  }

  Future<List<Reminder>> fetchToday() async {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);
    final end = start.add(const Duration(days: 1));

    final data = await _client
        .from('reminders')
        .select()
        .eq('user_id', _userId)
        .eq('completed', false)
        .order('scheduled_at');

    final reminders = (data as List)
        .map((item) => Reminder.fromMap(item as Map<String, dynamic>))
        .where((item) {
          final isToday =
              !item.scheduledAt.isBefore(start) && item.scheduledAt.isBefore(end);
          final dailyAlreadyStarted =
              item.recurrence == 'daily' && item.scheduledAt.isBefore(end);
          return isToday || dailyAlreadyStarted;
        })
        .toList();

    reminders.sort((a, b) {
      final aMinutes = a.scheduledAt.hour * 60 + a.scheduledAt.minute;
      final bMinutes = b.scheduledAt.hour * 60 + b.scheduledAt.minute;
      return aMinutes.compareTo(bMinutes);
    });
    return reminders;
  }

  Future<Reminder> create({
    required String title,
    required String type,
    required DateTime scheduledAt,
    required String recurrence,
    String? notes,
  }) async {
    final data = await _client
        .from('reminders')
        .insert({
          'user_id': _userId,
          'title': title.trim(),
          'type': type,
          'scheduled_at': scheduledAt.toUtc().toIso8601String(),
          'recurrence': recurrence,
          'notes': notes?.trim().isEmpty == true ? null : notes?.trim(),
        })
        .select()
        .single();

    final reminder = Reminder.fromMap(data);
    await NotificationService.instance.schedule(reminder);
    return reminder;
  }

  Future<void> reschedulePendingNotifications() async {
    final reminders = await fetchAll();
    for (final reminder in reminders) {
      try {
        await NotificationService.instance.schedule(reminder);
      } catch (_) {
        // O lembrete permanece salvo mesmo quando o Android bloqueia um alarme.
      }
    }
  }

  Future<void> complete(Reminder reminder) async {
    await _history.add(
      sourceType: 'reminder',
      sourceId: reminder.id,
      title: reminder.title,
      activityType: reminder.type,
    );

    await NotificationService.instance.cancel(reminder.id);

    if (reminder.recurrence == 'daily') {
      var next = reminder.scheduledAt.add(const Duration(days: 1));
      final now = DateTime.now();
      while (!next.isAfter(now)) {
        next = next.add(const Duration(days: 1));
      }
      final updated = await _client
          .from('reminders')
          .update({
            'scheduled_at': next.toUtc().toIso8601String(),
            'completed': false,
          })
          .eq('id', reminder.id)
          .eq('user_id', _userId)
          .select()
          .single();
      await NotificationService.instance.schedule(Reminder.fromMap(updated));
    } else {
      await _client
          .from('reminders')
          .update({'completed': true})
          .eq('id', reminder.id)
          .eq('user_id', _userId);
    }
  }

  Future<void> delete(String id) async {
    await _client.from('reminders').delete().eq('id', id).eq('user_id', _userId);
    await NotificationService.instance.cancel(id);
  }
}
