import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../services/reminder_service.dart';

class ReminderFormScreen extends StatefulWidget {
  const ReminderFormScreen({super.key});

  @override
  State<ReminderFormScreen> createState() => _ReminderFormScreenState();
}

class _ReminderFormScreenState extends State<ReminderFormScreen> {
  final _title = TextEditingController();
  final _notes = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _service = ReminderService();

  String _type = 'medication';
  String _recurrence = 'none';
  DateTime _date = DateTime.now();
  TimeOfDay _time = TimeOfDay.now();
  bool _loading = false;

  @override
  void dispose() {
    _title.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final result = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 730)),
      initialDate: _date,
    );
    if (result != null) setState(() => _date = result);
  }

  Future<void> _pickTime() async {
    final result = await showTimePicker(context: context, initialTime: _time);
    if (result != null) setState(() => _time = result);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      final scheduledAt = DateTime(
        _date.year,
        _date.month,
        _date.day,
        _time.hour,
        _time.minute,
      );

      await _service.create(
        title: _title.text,
        type: _type,
        scheduledAt: scheduledAt,
        recurrence: _recurrence,
        notes: _notes.text,
      );

      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Não foi possível salvar: $e')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Novo lembrete')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DropdownButtonFormField<String>(
                  initialValue: _type,
                  decoration: const InputDecoration(labelText: 'Tipo'),
                  items: const [
                    DropdownMenuItem(
                      value: 'medication',
                      child: Text('💊 Medicamento'),
                    ),
                    DropdownMenuItem(
                      value: 'appointment',
                      child: Text('🩺 Consulta'),
                    ),
                    DropdownMenuItem(
                      value: 'water',
                      child: Text('💧 Beber água'),
                    ),
                    DropdownMenuItem(
                      value: 'walk',
                      child: Text('🚶 Caminhada'),
                    ),
                    DropdownMenuItem(
                      value: 'commitment',
                      child: Text('📅 Compromisso'),
                    ),
                  ],
                  onChanged: (value) => setState(() => _type = value!),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _title,
                  decoration: const InputDecoration(
                    labelText: 'O que você quer lembrar?',
                  ),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Digite um título.'
                      : null,
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: _pickDate,
                  icon: const Icon(Icons.calendar_today_outlined),
                  label: Text(
                    'Data: ${DateFormat('dd/MM/yyyy').format(_date)}',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: _pickTime,
                  icon: const Icon(Icons.access_time),
                  label: Text(
                    'Horário: ${_time.format(context)}',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: _recurrence,
                  decoration: const InputDecoration(labelText: 'Repetir'),
                  items: const [
                    DropdownMenuItem(value: 'none', child: Text('Não repetir')),
                    DropdownMenuItem(
                      value: 'daily',
                      child: Text('Todos os dias'),
                    ),
                  ],
                  onChanged: (value) => setState(() => _recurrence = value!),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _notes,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Observação (opcional)',
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: _loading ? null : _save,
                  icon: const Icon(Icons.save_outlined),
                  label: Text(_loading ? 'Salvando...' : 'SALVAR LEMBRETE'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
