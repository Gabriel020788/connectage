import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileService {
  final SupabaseClient _client = Supabase.instance.client;

  String get _userId => _client.auth.currentUser!.id;

  Future<Map<String, dynamic>?> fetch() async {
    final data = await _client
        .from('profiles')
        .select('full_name, birth_date')
        .eq('id', _userId)
        .maybeSingle();

    return data;
  }

  Future<void> update({
    required String fullName,
    required DateTime birthDate,
  }) async {
    final birthDateText = _dateOnly(birthDate);

    await _client
        .from('profiles')
        .update({
          'full_name': fullName.trim(),
          'birth_date': birthDateText,
        })
        .eq('id', _userId);

    await _client.auth.updateUser(
      UserAttributes(
        data: {
          'full_name': fullName.trim(),
          'birth_date': birthDateText,
        },
      ),
    );
  }

  String _dateOnly(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }
}
