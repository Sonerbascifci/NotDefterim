import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/goal.dart';
import '../../domain/goal_status.dart';
import '../providers/goal_provider.dart';
import 'package:not_defterim/src/core/presentation/widgets/app_animated_icon.dart';
import 'package:not_defterim/src/app/l10n/l10n_extension.dart';

/// Screen for adding a new goal.
class AddGoalScreen extends ConsumerStatefulWidget {
  const AddGoalScreen({super.key});

  @override
  ConsumerState<AddGoalScreen> createState() => _AddGoalScreenState();
}

class _AddGoalScreenState extends ConsumerState<AddGoalScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _targetController = TextEditingController();
  final _unitController = TextEditingController();
  final _iconController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _targetController.dispose();
    _unitController.dispose();
    _iconController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final now = DateTime.now();
    final goal = Goal(
      id: '',
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      status: GoalStatus.active,
      targetValue: double.parse(_targetController.text),
      currentValue: 0,
      unit: _unitController.text.trim(),
      icon: _iconController.text.trim().isEmpty
          ? null
          : _iconController.text.trim(),
      createdAt: now,
      updatedAt: now,
    );

    final success = await ref.read(goalNotifierProvider.notifier).upsertGoal(goal);

    if (success && mounted) {
      AppAnimatedIcon.showSuccess(context, context.l10n.goalAdded);
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(goalNotifierProvider).isLoading;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.newGoal),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Icon field
            TextFormField(
              controller: _iconController,
              enabled: !isLoading,
              decoration: InputDecoration(
                labelText: context.l10n.goalIcon,
                hintText: '🎯',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Title field
            TextFormField(
              controller: _titleController,
              enabled: !isLoading,
              decoration: InputDecoration(
                labelText: context.l10n.title,
                hintText: 'Learn English',
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

            // Description field
            TextFormField(
              controller: _descriptionController,
              enabled: !isLoading,
              maxLines: 2,
              decoration: InputDecoration(
                labelText: context.l10n.goalDescription,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Target and unit
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _targetController,
                    enabled: !isLoading,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: context.l10n.goalTargetValue,
                      hintText: '100',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return context.l10n.titleRequired;
                      }
                      if (double.tryParse(value) == null) {
                        return context.l10n.unexpectedError;
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _unitController,
                    enabled: !isLoading,
                    decoration: InputDecoration(
                      labelText: context.l10n.goalUnit,
                      hintText: context.l10n.goalUnitHint,
                      border: const OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return context.l10n.titleRequired;
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            FilledButton(
              onPressed: isLoading ? null : _save,
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(context.l10n.save),
            ),
          ],
        ),
      ),
    );
  }
}
