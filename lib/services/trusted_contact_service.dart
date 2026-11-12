import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/trusted_contact.dart';

class TrustedContactService {
  final SupabaseClient _client = Supabase.instance.client;

  String get _userId => _client.auth.currentUser!.id;

  Future<TrustedContact?> fetch() async {
    final data = await _client
        .from('trusted_contacts')
        .select()
        .eq('user_id', _userId)
        .maybeSingle();
    return data == null ? null : TrustedContact.fromMap(data);
  }

  Future<void> save({
    required String fullName,
    String? relationship,
    String? phone,
    String? whatsapp,
    String? email,
  }) async {
    await _client.from('trusted_contacts').upsert({
      'user_id': _userId,
      'full_name': fullName.trim(),
      'relationship': _clean(relationship),
      'phone': _clean(phone),
      'whatsapp': _clean(whatsapp),
      'email': _clean(email),
    }, onConflict: 'user_id');
  }

  Future<void> delete() async {
    await _client.from('trusted_contacts').delete().eq('user_id', _userId);
  }

  String? _clean(String? value) {
    final text = value?.trim();
    return text == null || text.isEmpty ? null : text;
  }
}
