import 'package:flutter/material.dart';

import '../../models/task_item.dart';
import '../../services/task_service.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final _service = TaskService();
  late Future<List<TaskItem>> _future;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() {
    _future = _service.fetchAll();
  }

  Future<void> _add() async {
    final controller = TextEditingController();
    String type = 'task';
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Adicionar item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                autofocus: true,
                decoration: const InputDecoration(labelText: 'Descrição'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: type,
                decoration: const InputDecoration(labelText: 'Lista'),
                items: const [
                  DropdownMenuItem(value: 'task', child: Text('✅ Tarefas')),
                  DropdownMenuItem(value: 'shopping', child: Text('🛒 Compras')),
                ],
                onChanged: (value) => setDialogState(() => type = value!),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Adicionar'),
            ),
          ],
        ),
      ),
    );

    final title = controller.text.trim();
    controller.dispose();
    if (result == true && title.isNotEmpty) {
      await _service.create(title: title, type: type);
      if (mounted) setState(_reload);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tarefas e compras')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.add),
        label: const Text('Adicionar'),
      ),
      body: FutureBuilder<List<TaskItem>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar: ${snapshot.error}'));
          }
          final items = snapshot.data ?? const [];
          if (items.isEmpty) {
            return const Center(child: Text('Nenhuma tarefa cadastrada.'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (_, index) {
              final item = items[index];
              return Card(
                child: CheckboxListTile(
                  value: item.completed,
                  title: Text(
                    '${item.type == 'shopping' ? '🛒' : '✅'} ${item.title}',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          decoration: item.completed
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                  ),
                  secondary: IconButton(
                    tooltip: 'Excluir',
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () async {
                      await _service.delete(item.id);
                      if (mounted) setState(_reload);
                    },
                  ),
                  onChanged: (value) async {
                    await _service.setCompleted(item, value ?? false);
                    if (mounted) setState(_reload);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
