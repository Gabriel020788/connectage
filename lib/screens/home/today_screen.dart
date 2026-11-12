import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/brand_colors.dart';
import '../../data/recipe_data.dart';
import '../../data/wellness_data.dart';
import '../../models/reminder.dart';
import '../../services/profile_service.dart';
import '../../services/reminder_service.dart';
import '../../widgets/brand_logo.dart';
import '../../widgets/reminder_card.dart';
import '../../widgets/sprite_image.dart';
import '../recipes/recipe_detail_screen.dart';
import '../reminders/reminder_form_screen.dart';
import '../reminders/reminders_screen.dart';
import '../tasks/tasks_screen.dart';
import '../wellness/wellness_detail_screen.dart';

class TodayScreen extends StatefulWidget {
  const TodayScreen({super.key});

  @override
  State<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  final _service = ReminderService();
  final _profileService = ProfileService();
  late Future<List<Reminder>> _future;
  int? _age;

  @override
  void initState() {
    super.initState();
    _reload();
    unawaited(_service.reschedulePendingNotifications());
    unawaited(_loadAge());
  }

  void _reload() {
    _future = _service.fetchToday();
  }

  Future<void> _loadAge() async {
    final profile = await _profileService.fetch();
    final birthText = profile?['birth_date'] as String?;
    final birthDate = birthText == null ? null : DateTime.tryParse(birthText);
    if (birthDate == null || !mounted) return;
    final today = DateTime.now();
    var age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    setState(() => _age = age);
  }

  Future<void> _addReminder() async {
    final changed = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => const ReminderFormScreen()),
    );
    if (changed == true && mounted) setState(_reload);
  }

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    final name = (user?.userMetadata?['full_name'] as String?)?.trim();
    final firstName = name == null || name.isEmpty
        ? 'Olá'
        : 'Olá, ${name.split(' ').first}';
    final dateText =
        DateFormat("EEEE, dd 'de' MMMM", 'pt_BR').format(DateTime.now());
    final suggestions = wellnessSuggestionsForAge(_age);

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            setState(_reload);
            await _loadAge();
          },
          child: ListView(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 24),
            children: [
              Row(
                children: [
                  const BrandLogo(height: 58),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: BrandColors.orangeSoft,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.favorite_rounded,
                          color: BrandColors.orange,
                          size: 20,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'Seu dia',
                          style: TextStyle(
                            color: BrandColors.orangeStrong,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      BrandColors.blueSoft,
                      Color(0xFFF8FBFF),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(26),
                  border: Border.all(color: const Color(0xFFDDEAF7)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 54,
                      height: 54,
                      decoration: const BoxDecoration(
                        color: BrandColors.blue,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.waving_hand_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            firstName,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 3),
                          Text(
                            dateText,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: BrandColors.textMuted),
                          ),
                          if (_age != null) ...[
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Dicas personalizadas para $_age anos',
                                style: const TextStyle(
                                  color: BrandColors.blueStrong,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              _SectionTitle(
                icon: Icons.alarm_rounded,
                title: 'Seus lembretes de hoje',
                accentColor: BrandColors.blue,
              ),
              const SizedBox(height: 12),
              FutureBuilder<List<Reminder>>(
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.all(32),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  if (snapshot.hasError) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Text(
                          'Não foi possível carregar os lembretes: ${snapshot.error}',
                        ),
                      ),
                    );
                  }
                  final items = snapshot.data ?? const [];
                  if (items.isEmpty) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 46,
                              height: 46,
                              decoration: const BoxDecoration(
                                color: BrandColors.orangeSoft,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.check_rounded,
                                color: BrandColors.orange,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Text(
                                'Tudo certo por enquanto. Você não tem lembretes pendentes para hoje.',
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return Column(
                    children: items
                        .map(
                          (item) => ReminderCard(
                            reminder: item,
                            onComplete: () async {
                              await _service.complete(item);
                              if (mounted) setState(_reload);
                            },
                          ),
                        )
                        .toList(),
                  );
                },
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: _addReminder,
                icon: const Icon(Icons.add_alarm_rounded),
                label: const Text('ADICIONAR LEMBRETE'),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const RemindersScreen(),
                          ),
                        );
                        if (mounted) setState(_reload);
                      },
                      icon: const Icon(Icons.list_alt_rounded),
                      label: const Text('LEMBRETES'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const TasksScreen(),
                        ),
                      ),
                      icon: const Icon(Icons.checklist_rounded),
                      label: const Text('TAREFAS'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              _SectionTitle(
                icon: Icons.auto_awesome_rounded,
                title: 'Para você hoje',
                accentColor: BrandColors.orange,
              ),
              const SizedBox(height: 4),
              Text(
                'Toque em uma sugestão para conhecer benefícios e dicas práticas.',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: BrandColors.textMuted),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 292,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: suggestions.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final item = suggestions[index];
                    return SizedBox(
                      width: 252,
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        margin: EdgeInsets.zero,
                        child: InkWell(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => WellnessDetailScreen(
                                suggestion: item,
                              ),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  SizedBox(
                                    height: 142,
                                    width: double.infinity,
                                    child: SpriteImage(index: item.imageIndex),
                                  ),
                                  Positioned(
                                    top: 10,
                                    right: 10,
                                    child: Container(
                                      padding: const EdgeInsets.all(7),
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.arrow_forward_rounded,
                                        size: 20,
                                        color: BrandColors.orange,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(14, 12, 14, 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.title,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        item.description,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: BrandColors.textMuted,
                                        ),
                                      ),
                                      const Spacer(),
                                      const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            'SAIBA MAIS',
                                            style: TextStyle(
                                              color: BrandColors.orangeStrong,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                          SizedBox(width: 4),
                                          Icon(
                                            Icons.chevron_right_rounded,
                                            color: BrandColors.orange,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 30),
              _SectionTitle(
                icon: Icons.restaurant_rounded,
                title: 'Receitas em destaque',
                accentColor: BrandColors.blue,
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 232,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final recipe = recipes[index];
                    return SizedBox(
                      width: 222,
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        margin: EdgeInsets.zero,
                        child: InkWell(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  RecipeDetailScreen(recipe: recipe),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 136,
                                width: double.infinity,
                                child: SpriteImage(index: recipe.imageIndex),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      recipe.title,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style:
                                          Theme.of(context).textTheme.titleMedium,
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.schedule_rounded,
                                          size: 18,
                                          color: BrandColors.orange,
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          '${recipe.minutes} min',
                                          style: const TextStyle(
                                            color: BrandColors.textMuted,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F6FB),
                  borderRadius: BorderRadius.circular(16),
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
                        'As sugestões de bem-estar e receitas são gerais e não substituem orientação individual de profissionais de saúde.',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.icon,
    required this.title,
    required this.accentColor,
  });

  final IconData icon;
  final String title;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: accentColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: accentColor, size: 24),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
      ],
    );
  }
}
