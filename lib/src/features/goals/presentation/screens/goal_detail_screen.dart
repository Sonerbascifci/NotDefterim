import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/goal.dart';
import '../../domain/goal_log.dart';
import '../providers/goal_provider.dart';
import '../widgets/add_goal_log_dialog.dart';
import 'package:not_defterim/src/app/l10n/l10n_extension.dart';
import 'package:not_defterim/src/app/l10n/l10n_enums.dart';

/// Goal detail screen with timeline of logs.
class GoalDetailScreen extends ConsumerWidget {
  final String goalId;

  const GoalDetailScreen({super.key, required this.goalId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final goalAsync = ref.watch(goalProvider(goalId));
    final logsAsync = ref.watch(goalLogsProvider(goalId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hedef Detayı'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _confirmDelete(context, ref),
          ),
        ],
      ),
      body: goalAsync.when(
        data: (goal) {
          if (goal == null) {
            return Center(child: Text(context.l10n.goalNotFound));
          }
          return _buildContent(context, ref, goal, logsAsync, theme);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Hata: $error')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddLogDialog(context, ref),
        icon: const Icon(Icons.add),
        label: Text(context.l10n.addProgress),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    Goal goal,
    AsyncValue<List<GoalLog>> logsAsync,
    ThemeData theme,
  ) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Header card
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                if (goal.icon != null)
                  Text(goal.icon!, style: const TextStyle(fontSize: 48)),
                if (goal.icon != null) const SizedBox(height: 12),
                Text(
                  goal.title,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (goal.description != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    goal.description!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
                const SizedBox(height: 20),
                // Progress circle-like display
                SizedBox(
                  width: 120,
                  height: 120,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 120,
                        height: 120,
                        child: CircularProgressIndicator(
                          value: goal.progress,
                          strokeWidth: 12,
                          backgroundColor:
                              theme.colorScheme.surfaceContainerHighest,
                        ),
                      ),
                      Text(
                        goal.progressPercent,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '${goal.currentValue.toStringAsFixed(1)} / ${goal.targetValue.toStringAsFixed(1)} ${goal.unit}',
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Chip(
                  label: Text(goal.status.displayName(context)),
                  avatar: Text(goal.status.icon),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Timeline header
        Text(
          '📅 ${context.l10n.progressHistory}',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),

        // Logs timeline
        logsAsync.when(
          data: (logs) {
            if (logs.isEmpty) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Center(
                    child: Text(
                      context.l10n.noProgressHistory,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              );
            }
            return Column(
              children: logs.map((log) => _LogTile(log: log, unit: goal.unit)).toList(),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Text('Hata: $error'),
        ),
      ],
    );
  }

  Future<void> _showAddLogDialog(BuildContext context, WidgetRef ref) async {
    final result = await showDialog<GoalLog>(
      context: context,
      builder: (context) => AddGoalLogDialog(goalId: goalId),
    );

    if (result != null) {
      final success =
          await ref.read(goalNotifierProvider.notifier).addGoalLog(result);
      if (success && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.progressAdded)),
        );
      }
    }
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.goalDeleteConfirmationTitle),
        content: Text(
          context.l10n.goalDeleteConfirmationContent,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.l10n.delete),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success =
          await ref.read(goalNotifierProvider.notifier).deleteGoal(goalId);
      if (success && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.goalDeleted)),
        );
        context.pop();
      }
    }
  }
}

/// Log entry tile for timeline.
class _LogTile extends StatelessWidget {
  final GoalLog log;
  final String unit;

  const _LogTile({required this.log, required this.unit});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateStr = _formatDate(log.createdAt);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            shape: BoxShape.circle,
          ),
          child: const Center(child: Text('📝')),
        ),
        title: Text('+${log.value.toStringAsFixed(1)} $unit'),
        subtitle: log.note != null ? Text(log.note!) : null,
        trailing: Text(
          dateStr,
          style: theme.textTheme.bodySmall,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }
}
