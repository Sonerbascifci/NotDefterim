import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../domain/planned_item.dart';
import '../providers/planner_provider.dart';
import 'package:not_defterim/src/core/presentation/widgets/app_animated_icon.dart';
import 'package:not_defterim/src/app/l10n/l10n_extension.dart';

class AddPlanScreen extends ConsumerStatefulWidget {
  final PlannedItem? initialPlan;
  const AddPlanScreen({super.key, this.initialPlan});

  @override
  ConsumerState<AddPlanScreen> createState() => _AddPlanScreenState();
}

class _AddPlanScreenState extends ConsumerState<AddPlanScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  DateTime _selectedDate = DateTime.now();
  DateTime? _endDate;
  TimeOfDay _selectedTime = TimeOfDay.now();
  
  bool _isRecurring = false;
  final List<int> _recurrenceDays = [];


  @override
  void initState() {
    super.initState();
    if (widget.initialPlan != null) {
      final plan = widget.initialPlan!;
      _titleController.text = plan.title;
      _descriptionController.text = plan.description ?? '';
      _selectedDate = plan.date;
      _selectedTime = TimeOfDay.fromDateTime(plan.date);
      _endDate = plan.endDate;
      _isRecurring = plan.isRecurring;
      if (plan.recurrenceDays != null) {
        _recurrenceDays.addAll(plan.recurrenceDays!);
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, {bool isEndDate = false}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isEndDate ? (_endDate ?? _selectedDate.add(const Duration(days: 30))) : _selectedDate,
      firstDate: isEndDate ? _selectedDate : DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isEndDate) {
          _endDate = picked;
        } else {
          _selectedDate = picked;
          if (_endDate != null && _endDate!.isBefore(_selectedDate)) {
            _endDate = null;
          }
        }
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_isRecurring && _recurrenceDays.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.selectDayError)),
      );
      return;
    }

    final finalDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    final plan = (widget.initialPlan ?? PlannedItem(
      id: '',
      title: '',
      date: DateTime.now(),
      createdAt: DateTime.now(),
    )).copyWith(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      date: finalDateTime,
      endDate: _isRecurring ? _endDate : null,
      isRecurring: _isRecurring,
      recurrenceDays: _isRecurring ? List.from(_recurrenceDays) : null,
    );

    final success = await ref.read(plannerNotifierProvider.notifier).upsertPlan(plan);

    if (success && mounted) {
      AppAnimatedIcon.showSuccess(
        context,
        widget.initialPlan == null ? context.l10n.planAdded : context.l10n.planUpdated,
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(plannerNotifierProvider).isLoading;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.initialPlan == null ? context.l10n.newPlan : context.l10n.editPlan),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              enabled: !isLoading,
              decoration: InputDecoration(
                labelText: context.l10n.title,
                hintText: context.l10n.planTitleHint,
                border: const OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return context.l10n.titleRequired;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              enabled: !isLoading,
              maxLines: 2,
              decoration: InputDecoration(
                labelText: context.l10n.notesOptional,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(context.l10n.startDate),
                    subtitle: Text(DateFormat('d MMMM yyyy').format(_selectedDate)),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: isLoading ? null : () => _selectDate(context),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(context.l10n.time),
                    subtitle: Text(_selectedTime.format(context)),
                    trailing: const Icon(Icons.access_time),
                    onTap: isLoading ? null : () => _selectTime(context),
                  ),
                ),
              ],
            ),
            const Divider(height: 32),
            SwitchListTile(
              title: Text(context.l10n.recurrenceWeekly),
              subtitle: Text(context.l10n.recurrenceWeeklyDesc),
              value: _isRecurring,
              onChanged: isLoading ? null : (val) => setState(() => _isRecurring = val),
            ),
            if (_isRecurring) ...[
              const SizedBox(height: 8),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(context.l10n.endDate),
                subtitle: Text(_endDate == null
                    ? context.l10n.noDateSelected
                    : DateFormat('d MMMM yyyy').format(_endDate!)),
                trailing: const Icon(Icons.event),
                onTap: isLoading ? null : () => _selectDate(context, isEndDate: true),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List.generate(7, (index) {
                  final dayNumber = index + 1;
                  final isSelected = _recurrenceDays.contains(dayNumber);
                  return FilterChip(
                    label: Text(context.l10n.weekDays(dayNumber.toString())),
                    selected: isSelected,
                    onSelected: isLoading
                        ? null
                        : (selected) {
                            setState(() {
                              if (selected) {
                                _recurrenceDays.add(dayNumber);
                              } else {
                                _recurrenceDays.remove(dayNumber);
                              }
                            });
                          },
                  );
                }),
              ),
            ],
            const SizedBox(height: 32),
            FilledButton(
              onPressed: isLoading ? null : _save,
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : Text(widget.initialPlan == null ? context.l10n.save : context.l10n.changesSaved),
            ),
          ],
        ),
      ),
    );
  }
}
