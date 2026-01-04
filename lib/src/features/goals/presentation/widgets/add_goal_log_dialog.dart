import 'package:flutter/material.dart';

import '../../domain/goal_log.dart';
import 'package:not_defterim/src/app/l10n/l10n_extension.dart';

/// Dialog for adding a goal log entry.
class AddGoalLogDialog extends StatefulWidget {
  final String goalId;

  const AddGoalLogDialog({super.key, required this.goalId});

  @override
  State<AddGoalLogDialog> createState() => _AddGoalLogDialogState();
}

class _AddGoalLogDialogState extends State<AddGoalLogDialog> {
  final _formKey = GlobalKey<FormState>();
  final _valueController = TextEditingController();
  final _noteController = TextEditingController();

  @override
  void dispose() {
    _valueController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final log = GoalLog(
      id: '',
      goalId: widget.goalId,
      value: double.parse(_valueController.text),
      note: _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
      createdAt: DateTime.now(),
    );

    Navigator.pop(context, log);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.l10n.addProgress),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _valueController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              autofocus: true,
              decoration: InputDecoration(
                labelText: context.l10n.amount,
                hintText: '1.5',
                border: const OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Değer gerekli';
                }
                if (double.tryParse(value) == null) {
                  return context.l10n.unexpectedError;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _noteController,
              maxLines: 2,
              decoration: InputDecoration(
                labelText: context.l10n.notesOptional,
                hintText: context.l10n.notesHint,
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(context.l10n.cancel),
        ),
        FilledButton(
          onPressed: _submit,
          child: Text(context.l10n.add),
        ),
      ],
    );
  }
}
