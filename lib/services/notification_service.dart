import 'dart:async';
import 'dart:io';

import 'package:alarm/alarm.dart';
import 'package:alarm/utils/alarm_set.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/reminder.dart';

class NotificationService {
  NotificationService._();

  static final instance = NotificationService._();

  static const _fullScreenChannel =
      MethodChannel('br.com.connectage/full_screen_intent');

  final FlutterTts _tts = FlutterTts();
  StreamSubscription<AlarmSet>? _ringSubscription;

  Future<void> initialize() async {
    await Alarm.init();
    if (Platform.isAndroid) {
      await Permission.notification.request();
      await Permission.scheduleExactAlarm.request();
      await _ensureFullScreenIntentPermission();
    }

    await _tts.setLanguage('pt-BR');
    await _tts.setSpeechRate(0.46);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);

    _ringSubscription ??= Alarm.ringing.listen((alarmSet) async {
      for (final alarm in alarmSet.alarms) {
        final title = _removeEmoji(alarm.notificationSettings.title);
        final body = _removeEmoji(alarm.notificationSettings.body);
        await _tts.stop();
        await _tts.speak('$title. $body');
      }
    });
  }

  Future<void> schedule(Reminder reminder) async {
    if (Platform.isAndroid) {
      await _ensureFullScreenIntentPermission();
    }

    var scheduled = reminder.scheduledAt;
    final now = DateTime.now();

    if (reminder.recurrence == 'daily') {
      while (!scheduled.isAfter(now)) {
        scheduled = scheduled.add(const Duration(days: 1));
      }
    } else if (!scheduled.isAfter(now)) {
      return;
    }

    final id = _notificationId(reminder.id);
    await Alarm.stop(id);

    final settings = AlarmSettings(
      id: id,
      dateTime: scheduled,
      loopAudio: true,
      vibrate: true,
      androidFullScreenIntent: true,
      androidSnoozeDuration: const Duration(minutes: 10),
      volumeSettings: VolumeSettings.fade(
        volume: 0.9,
        fadeDuration: const Duration(seconds: 3),
        volumeEnforced: true,
      ),
      notificationSettings: NotificationSettings(
        title: '${reminder.emoji} Hora do ${reminder.typeLabel.toLowerCase()}',
        body: reminder.title,
        stopButton: reminder.type == 'medication' ? 'Tomei' : 'Concluído',
        androidSnoozeButton: 'Adiar 10 minutos',
      ),
    );

    await Alarm.set(alarmSettings: settings);
  }

  Future<void> cancel(String reminderId) async {
    await Alarm.stop(_notificationId(reminderId));
  }

  Future<void> speakTest(String text) async {
    await _tts.stop();
    await _tts.speak(_removeEmoji(text));
  }

  Future<void> _ensureFullScreenIntentPermission() async {
    if (!Platform.isAndroid) return;

    try {
      final allowed =
          await _fullScreenChannel.invokeMethod<bool>('canUseFullScreenIntent') ??
              true;
      if (!allowed) {
        await _fullScreenChannel
            .invokeMethod<void>('requestFullScreenIntentPermission');
      }
    } on PlatformException {
      // Androids antigos não possuem esta permissão especial.
      // O alarme continua funcionando com som e notificação normalmente.
    }
  }

  String _removeEmoji(String value) {
    final buffer = StringBuffer();
    for (final rune in value.runes) {
      final isEmoji =
          (rune >= 0x1F300 && rune <= 0x1FAFF) ||
          (rune >= 0x2600 && rune <= 0x27BF) ||
          rune == 0xFE0F;
      if (!isEmoji) buffer.writeCharCode(rune);
    }
    return buffer.toString().replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  int _notificationId(String uuid) {
    final clean = uuid.replaceAll('-', '');
    return int.parse(clean.substring(0, 8), radix: 16) & 0x7fffffff;
  }
}
