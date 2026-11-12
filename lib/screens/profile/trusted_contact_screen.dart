import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/trusted_contact.dart';
import '../../services/trusted_contact_service.dart';

class TrustedContactScreen extends StatefulWidget {
  const TrustedContactScreen({super.key});

  @override
  State<TrustedContactScreen> createState() => _TrustedContactScreenState();
}

class _TrustedContactScreenState extends State<TrustedContactScreen> {
  final _service = TrustedContactService();
  final _name = TextEditingController();
  final _relationship = TextEditingController();
  final _phone = TextEditingController();
  final _whatsapp = TextEditingController();
  final _email = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _loading = true;
  bool _saving = false;
  TrustedContact? _contact;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _name.dispose();
    _relationship.dispose();
    _phone.dispose();
    _whatsapp.dispose();
    _email.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final contact = await _service.fetch();
    _contact = contact;
    if (contact != null) {
      _name.text = contact.fullName;
      _relationship.text = contact.relationship ?? '';
      _phone.text = contact.phone ?? '';
      _whatsapp.text = contact.whatsapp ?? '';
      _email.text = contact.email ?? '';
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      await _service.save(
        fullName: _name.text,
        relationship: _relationship.text,
        phone: _phone.text,
        whatsapp: _whatsapp.text,
        email: _email.text,
      );
      await _load();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pessoa de confiança salva.')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _open(Uri uri) async {
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível abrir este recurso.')),
      );
    }
  }

  String _digits(String value) => value.replaceAll(RegExp(r'\D'), '');

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Pessoa de confiança')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Card(
            child: Padding(
              padding: EdgeInsets.all(18),
              child: Text(
                'Cadastre uma pessoa próxima para ter atalhos rápidos de ligação, WhatsApp e mensagem.',
              ),
            ),
          ),
          const SizedBox(height: 16),
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _name,
                  decoration: const InputDecoration(labelText: 'Nome', prefixIcon: Icon(Icons.person_outline)),
                  validator: (value) => value == null || value.trim().isEmpty ? 'Digite o nome.' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _relationship,
                  decoration: const InputDecoration(labelText: 'Parentesco / relação', prefixIcon: Icon(Icons.family_restroom)),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _phone,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: 'Telefone', prefixIcon: Icon(Icons.phone_outlined)),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _whatsapp,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: 'WhatsApp', prefixIcon: Icon(Icons.chat_outlined)),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'E-mail', prefixIcon: Icon(Icons.email_outlined)),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _saving ? null : _save,
                    icon: const Icon(Icons.save_outlined),
                    label: Text(_saving ? 'SALVANDO...' : 'SALVAR'),
                  ),
                ),
              ],
            ),
          ),
          if (_contact != null) ...[
            const SizedBox(height: 26),
            Text('Contato rápido', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                if (_phone.text.trim().isNotEmpty)
                  FilledButton.icon(
                    onPressed: () => _open(Uri(scheme: 'tel', path: _phone.text.trim())),
                    icon: const Icon(Icons.phone),
                    label: const Text('Ligar'),
                  ),
                if (_whatsapp.text.trim().isNotEmpty)
                  FilledButton.icon(
                    onPressed: () {
                      final digits = _digits(_whatsapp.text);
                      _open(Uri.parse('https://wa.me/$digits'));
                    },
                    icon: const Icon(Icons.chat),
                    label: const Text('WhatsApp'),
                  ),
                if (_phone.text.trim().isNotEmpty)
                  OutlinedButton.icon(
                    onPressed: () => _open(Uri(scheme: 'sms', path: _phone.text.trim())),
                    icon: const Icon(Icons.sms_outlined),
                    label: const Text('Mensagem'),
                  ),
              ],
            ),
            const SizedBox(height: 14),
            TextButton.icon(
              onPressed: () async {
                await _service.delete();
                _name.clear();
                _relationship.clear();
                _phone.clear();
                _whatsapp.clear();
                _email.clear();
                _contact = null;
                if (mounted) setState(() {});
              },
              icon: const Icon(Icons.delete_outline),
              label: const Text('Remover contato'),
            ),
          ],
        ],
      ),
    );
  }
}
