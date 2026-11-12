import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/brand_colors.dart';
import '../../models/activity_history.dart';
import '../../services/history_service.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final _service = HistoryService();
  int _days = 7;
  late Future<List<ActivityHistoryItem>> _future;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() {
    _future = _service.fetch(days: _days);
  }

  void _setDays(int days) {
    setState(() {
      _days = days;
      _reload();
    });
  }

  String _dayLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final itemDay = DateTime(date.year, date.month, date.day);
    if (itemDay == today) return 'Hoje';
    if (itemDay == today.subtract(const Duration(days: 1))) return 'Ontem';
    return DateFormat("dd 'de' MMMM", 'pt_BR').format(itemDay);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Histórico')),
      body: RefreshIndicator(
        onRefresh: () async => setState(_reload),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 6, 18, 24),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [BrandColors.blueSoft, Color(0xFFF8FBFF)],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFFDDEAF7)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 54,
                    height: 54,
                    decoration: const BoxDecoration(
                      color: BrandColors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.insights_rounded,
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
                          'Acompanhe sua rotina',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Veja lembretes e tarefas que você já concluiu.',
                          style: TextStyle(color: BrandColors.textMuted),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            SegmentedButton<int>(
              segments: const [
                ButtonSegment(value: 1, label: Text('Hoje')),
                ButtonSegment(value: 7, label: Text('7 dias')),
                ButtonSegment(value: 31, label: Text('Este mês')),
              ],
              selected: {_days},
              onSelectionChanged: (value) => _setDays(value.first),
              style: ButtonStyle(
                foregroundColor: WidgetStateProperty.resolveWith((states) {
                  return states.contains(WidgetState.selected)
                      ? BrandColors.blueStrong
                      : BrandColors.textMuted;
                }),
                backgroundColor: WidgetStateProperty.resolveWith((states) {
                  return states.contains(WidgetState.selected)
                      ? BrandColors.orangeSoft
                      : Colors.white;
                }),
              ),
            ),
            const SizedBox(height: 20),
            FutureBuilder<List<ActivityHistoryItem>>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.all(40),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (snapshot.hasError) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Text(
                        'Não foi possível carregar o histórico: ${snapshot.error}',
                      ),
                    ),
                  );
                }
                final items = snapshot.data ?? const [];
                if (items.isEmpty) {
                  return const Card(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Icon(
                            Icons.hourglass_empty_rounded,
                            color: BrandColors.orange,
                            size: 30,
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Nenhuma atividade concluída neste período.',
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final grouped = <String, List<ActivityHistoryItem>>{};
                for (final item in items) {
                  grouped.putIfAbsent(
                    _dayLabel(item.completedAt),
                    () => [],
                  ).add(item);
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: BrandColors.orangeSoft,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 46,
                            height: 46,
                            decoration: const BoxDecoration(
                              color: BrandColors.orange,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.verified_rounded,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              '${items.length} atividade${items.length == 1 ? '' : 's'} concluída${items.length == 1 ? '' : 's'}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(color: BrandColors.orangeStrong),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    ...grouped.entries.expand((entry) sync* {
                      yield Padding(
                        padding: const EdgeInsets.only(top: 12, bottom: 8),
                        child: Text(
                          entry.key,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      );
                      for (final item in entry.value) {
                        yield Card(
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 6,
                            ),
                            leading: Container(
                              width: 48,
                              height: 48,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: BrandColors.blueSoft,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Text(
                                item.emoji,
                                style: const TextStyle(fontSize: 26),
                              ),
                            ),
                            title: Text(
                              item.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            subtitle: Text(
                              DateFormat('HH:mm').format(item.completedAt),
                            ),
                            trailing: const Icon(
                              Icons.check_circle_rounded,
                              color: BrandColors.orange,
                              size: 28,
                            ),
                          ),
                        );
                      }
                    }),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
