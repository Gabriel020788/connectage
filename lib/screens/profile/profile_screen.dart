import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/brand_colors.dart';
import '../../services/auth_service.dart';
import '../../services/notification_service.dart';
import '../../services/profile_service.dart';
import '../../widgets/brand_logo.dart';
import 'trusted_contact_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _service = ProfileService();
  final _name = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  DateTime? _birthDate;
  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    try {
      final profile = await _service.fetch();
      final authUser = Supabase.instance.client.auth.currentUser;

      _name.text = (profile?['full_name'] as String?)?.trim().isNotEmpty == true
          ? (profile!['full_name'] as String)
          : ((authUser?.userMetadata?['full_name'] as String?) ?? '');

      final birthDateText = profile?['birth_date'] as String?;
      if (birthDateText != null && birthDateText.isNotEmpty) {
        _birthDate = DateTime.tryParse(birthDateText);
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _pickBirthDate() async {
    final now = DateTime.now();
    final result = await showDatePicker(
      context: context,
      firstDate: DateTime(1900),
      lastDate: now,
      initialDate: _birthDate ?? DateTime(now.year - 60, now.month, now.day),
      helpText: 'Selecione sua data de nascimento',
      cancelText: 'CANCELAR',
      confirmText: 'CONFIRMAR',
    );

    if (result != null) setState(() => _birthDate = result);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_birthDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Informe sua data de nascimento.')),
      );
      return;
    }

    setState(() => _saving = true);
    try {
      await _service.update(fullName: _name.text, birthDate: _birthDate!);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Dados atualizados com sucesso.')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Não foi possível atualizar: $e')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _changePassword() async {
    final controller = TextEditingController();
    final password = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Alterar senha'),
        content: TextField(
          controller: controller,
          obscureText: true,
          decoration: const InputDecoration(labelText: 'Nova senha'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (password == null || password.length < 6) return;
    await AuthService().changePassword(password);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Senha atualizada.')),
    );
  }

  int? get _age {
    final birthDate = _birthDate;
    if (birthDate == null) return null;
    final today = DateTime.now();
    var age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    final age = _age;

    return Scaffold(
      appBar: AppBar(title: const Text('Minha conta')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 6, 18, 24),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  BrandColors.blueSoft,
                  Color(0xFFF8FBFF),
                  BrandColors.orangeSoft,
                ],
              ),
              borderRadius: BorderRadius.circular(26),
              border: Border.all(color: const Color(0xFFDDEAF7)),
            ),
            child: Column(
              children: [
                const BrandLogo(height: 108),
                const SizedBox(height: 8),
                Text(
                  _name.text.isEmpty ? 'Minha conta' : _name.text,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                if (user?.email != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    user!.email!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: BrandColors.textMuted),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 20),
          Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: BrandColors.blueSoft,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.badge_outlined,
                            color: BrandColors.blue,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Meus dados',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    TextFormField(
                      controller: _name,
                      decoration: const InputDecoration(
                        labelText: 'Nome',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                              ? 'Digite seu nome.'
                              : null,
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      initialValue: user?.email ?? '',
                      enabled: false,
                      decoration: const InputDecoration(
                        labelText: 'E-mail',
                        prefixIcon: Icon(Icons.email_outlined),
                        helperText: 'O e-mail não é alterado nesta versão.',
                      ),
                    ),
                    const SizedBox(height: 14),
                    OutlinedButton.icon(
                      onPressed: _pickBirthDate,
                      icon: const Icon(Icons.cake_outlined),
                      label: Text(
                        _birthDate == null
                            ? 'INFORMAR DATA DE NASCIMENTO'
                            : 'Nascimento: ${DateFormat('dd/MM/yyyy').format(_birthDate!)}',
                      ),
                    ),
                    if (age != null) ...[
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: BrandColors.orangeSoft,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          'Idade: $age anos',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(color: BrandColors.orangeStrong),
                        ),
                      ),
                    ],
                    const SizedBox(height: 18),
                    ElevatedButton.icon(
                      onPressed: _saving ? null : _save,
                      icon: const Icon(Icons.save_outlined),
                      label: Text(
                        _saving ? 'SALVANDO...' : 'SALVAR ALTERAÇÕES',
                      ),
                    ),
                    const SizedBox(height: 10),
                    OutlinedButton.icon(
                      onPressed: _changePassword,
                      icon: const Icon(Icons.lock_reset),
                      label: const Text('ALTERAR SENHA'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          _ProfileActionCard(
            icon: Icons.family_restroom_rounded,
            iconColor: BrandColors.orange,
            iconBackground: BrandColors.orangeSoft,
            title: 'Pessoa de confiança',
            subtitle: 'Cadastrar familiar ou contato próximo',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const TrustedContactScreen(),
              ),
            ),
          ),
          _ProfileActionCard(
            icon: Icons.volume_up_rounded,
            iconColor: BrandColors.blue,
            iconBackground: BrandColors.blueSoft,
            title: 'Testar leitura em voz alta',
            subtitle: 'Ouça como o ConnectAge fala durante os alarmes',
            onTap: () => NotificationService.instance.speakTest(
              'ConnectAge. Este é um teste de leitura em voz alta. Hora de cuidar da sua rotina.',
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F6FB),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  color: BrandColors.blue,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'As dicas e receitas do ConnectAge são sugestões gerais de bem-estar e não substituem orientação médica ou nutricional individual.',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          OutlinedButton.icon(
            onPressed: () => AuthService().signOut(),
            icon: const Icon(Icons.logout_rounded),
            label: const Text('SAIR DA CONTA'),
          ),
        ],
      ),
    );
  }
}

class _ProfileActionCard extends StatelessWidget {
  const _ProfileActionCard({
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: iconBackground,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(icon, size: 28, color: iconColor),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(
          Icons.chevron_right_rounded,
          color: BrandColors.orange,
        ),
        onTap: onTap,
      ),
    );
  }
}
