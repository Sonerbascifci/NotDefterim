import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:animations/animations.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'add_goal_screen.dart';

import '../../domain/goal.dart';
import '../../domain/goal_status.dart';
import '../providers/goal_provider.dart';
import 'package:not_defterim/src/core/presentation/widgets/app_animated_icon.dart';
import 'package:not_defterim/src/app/l10n/l10n_extension.dart';

/// Goals screen - displays list of user's goals with progress.
class GoalsScreen extends ConsumerWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final goalsAsync = ref.watch(goalsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.goalsTitle),
      ),
      body: goalsAsync.when(
        data: (goals) {
          if (goals.isEmpty) {
            return _buildEmptyState(context, theme);
          }

          // Group by status
          final activeGoals =
              goals.where((g) => g.status == GoalStatus.active).toList();
          final completedGoals =
              goals.where((g) => g.status == GoalStatus.completed).toList();
          final otherGoals = goals
              .where((g) =>
                  g.status != GoalStatus.active &&
                  g.status != GoalStatus.completed)
              .toList();

          return ListView(
            padding: const EdgeInsets.all(16),
            children: AnimationConfiguration.toStaggeredList(
              duration: const Duration(milliseconds: 375),
              childAnimationBuilder: (widget) => SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: widget,
                ),
              ),
              children: [
                if (activeGoals.isNotEmpty) ...[
                  _buildSectionHeader(context, '🎯 ${context.l10n.goalStatusActive}', theme),
                  const SizedBox(height: 8),
                  ...activeGoals.map((goal) => _GoalCard(goal: goal)),
                  const SizedBox(height: 16),
                ],
                if (completedGoals.isNotEmpty) ...[
                  _buildSectionHeader(context, '✅ ${context.l10n.goalStatusCompleted}', theme),
                  const SizedBox(height: 8),
                  ...completedGoals.map((goal) => _GoalCard(goal: goal)),
                  const SizedBox(height: 16),
                ],
                if (otherGoals.isNotEmpty) ...[
                  _buildSectionHeader(context, '📦 ${context.l10n.goalStatusArchived}', theme),
                  const SizedBox(height: 8),
                  ...otherGoals.map((goal) => _GoalCard(goal: goal)),
                ],
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('${context.l10n.unexpectedError}: $error')),
      ),
      floatingActionButton: OpenContainer(
        transitionType: ContainerTransitionType.fadeThrough,
        openBuilder: (BuildContext context, VoidCallback _) {
          return const AddGoalScreen();
        },
        closedElevation: 6.0,
        closedShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        closedColor: theme.colorScheme.primaryContainer,
        closedBuilder: (BuildContext context, VoidCallback openContainer) {
          return FloatingActionButton.extended(
            onPressed: openContainer,
            icon: const Icon(Icons.add_rounded),
            label: Text(context.l10n.newGoal),
            elevation: 0,
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppAnimatedIcon(
            iconPath: AppAnimatedIcons.target,
            size: 120,
          ),
          const SizedBox(height: 16),
          Text(
            context.l10n.noGoalYet,
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            context.l10n.goalsEmptyStateHint,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
      BuildContext context, String title, ThemeData theme) {
    return Text(
      title,
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

/// Card widget for displaying a goal with progress.
class _GoalCard extends StatelessWidget {
  final Goal goal;

  const _GoalCard({required this.goal});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => context.push('/goals/${goal.id}'),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (goal.icon != null)
                    Text(goal.icon!, style: const TextStyle(fontSize: 24)),
                  if (goal.icon != null) const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      goal.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      goal.progressPercent,
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: goal.progress,
                borderRadius: BorderRadius.circular(4),
              ),
              const SizedBox(height: 8),
              Text(
                '${goal.currentValue.toStringAsFixed(1)} / ${goal.targetValue.toStringAsFixed(1)} ${goal.unit}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
