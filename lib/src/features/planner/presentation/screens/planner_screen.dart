import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:animations/animations.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'add_plan_screen.dart';
import '../../domain/planned_item.dart';
import '../providers/planner_provider.dart';
import 'package:not_defterim/src/core/presentation/widgets/app_animated_icon.dart';
import 'package:not_defterim/src/app/l10n/l10n_extension.dart';

/// Planner screen - displays list of user's plans in a modern timeline view with week indicators and stats.
class PlannerScreen extends ConsumerWidget {
  const PlannerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final plansAsync = ref.watch(plansProvider);
    final stats = ref.watch(plannerStatsProvider);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: _StatsHeader(stats: stats),
            ),
            title: Text(
              context.l10n.plannerTitle,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            centerTitle: false,
          ),
          plansAsync.when(
            data: (plans) {
              if (plans.isEmpty) {
                return SliverFillRemaining(
                  child: _buildEmptyState(context, theme),
                );
              }

              final now = DateTime.now();
              final today = DateTime(now.year, now.month, now.day);
              final timelineItems = <_TimelineItem>[];

              int currentWeek = -1;

              for (int i = 0; i < 90; i++) {
                final date = today.add(Duration(days: i));
                
                final weekOfYear = _getWeekOfYear(date);
                if (weekOfYear != currentWeek) {
                  currentWeek = weekOfYear;
                  timelineItems.add(_TimelineItem.weekHeader(date));
                }

                final dailyItems = <PlannedItem>[];
                for (final plan in plans) {
                  if (plan.occursOn(date)) {
                    dailyItems.add(plan);
                  }
                }

                if (dailyItems.isNotEmpty) {
                  dailyItems.sort((a, b) {
                    final aTime = a.date.hour * 60 + a.date.minute;
                    final bTime = b.date.hour * 60 + b.date.minute;
                    return aTime.compareTo(bTime);
                  });
                  timelineItems.add(_TimelineItem.dayGroup(_DateGroup(date: date, items: dailyItems)));
                }
              }

              if (timelineItems.isEmpty) {
                return SliverFillRemaining(
                  child: _buildEmptyState(context, theme),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                sliver: AnimationConfiguration.synchronized(
                  child: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 375),
                          child: SlideAnimation(
                            verticalOffset: 50.0,
                            child: FadeInAnimation(
                              child: timelineItems[index].isWeekHeader
                                  ? _WeekHeader(date: timelineItems[index].date!)
                                  : _DayTimelineSection(group: timelineItems[index].dayGroup!),
                            ),
                          ),
                        );
                      },
                      childCount: timelineItems.length,
                    ),
                  ),
                ),
              );
            },
            loading: () => const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, _) => SliverFillRemaining(
              child: Center(child: Text('Hata: $error')),
            ),
          ),
        ],
      ),
      floatingActionButton: OpenContainer(
        transitionType: ContainerTransitionType.fadeThrough,
        openBuilder: (BuildContext context, VoidCallback _) {
          return const AddPlanScreen();
        },
        closedElevation: 6.0,
        closedShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        closedColor: theme.colorScheme.primaryContainer,
        closedBuilder: (BuildContext context, VoidCallback openContainer) {
          return FloatingActionButton.extended(
            onPressed: openContainer,
            icon: const Icon(Icons.add_task_rounded),
            label: Text(context.l10n.newPlan),
            elevation: 0,
          );
        },
      ),
    );
  }

  int _getWeekOfYear(DateTime date) {
    final firstDayOfYear = DateTime(date.year, 1, 1);
    final dayOfYear = date.difference(firstDayOfYear).inDays;
    return ((dayOfYear - (date.weekday - 1) + 10) / 7).floor();
  }

  Widget _buildEmptyState(BuildContext context, ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withAlpha(50),
                shape: BoxShape.circle,
              ),
              child: AppAnimatedIcon(
                iconPath: AppAnimatedIcons.notebook,
                size: 80,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              context.l10n.plannerEmpty,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              context.l10n.plannerEmptyHint,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatsHeader extends StatelessWidget {
  final PlannerStats stats;

  const _StatsHeader({required this.stats});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withAlpha(180),
            theme.colorScheme.secondary.withAlpha(200),
          ],
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Text(
          //   context.l10n.plannerTitle,
          //   style: theme.textTheme.headlineMedium?.copyWith(
          //     color: theme.colorScheme.onPrimary,
          //     fontWeight: FontWeight.bold,
          //   ),
          // ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.performance,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.onPrimary.withAlpha(200),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '${(stats.completionRate * 100).toInt()}',
                          style: theme.textTheme.displaySmall?.copyWith(
                            color: theme.colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '%',
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: theme.colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '${stats.completedTasks} / ${stats.totalTasks} ${context.l10n.goalStatusCompleted}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onPrimary.withAlpha(200),
                      ),
                    ),
                  ],
                ),
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 70,
                    height: 70,
                    child: CircularProgressIndicator(
                      value: stats.completionRate,
                      strokeWidth: 6,
                      backgroundColor: theme.colorScheme.onPrimary.withAlpha(50),
                      valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.onPrimary),
                    ),
                  ),
                  Icon(
                    Icons.emoji_events_outlined,
                    color: theme.colorScheme.onPrimary,
                    size: 28,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TimelineItem {
  final bool isWeekHeader;
  final DateTime? date;
  final _DateGroup? dayGroup;

  _TimelineItem.weekHeader(this.date) : isWeekHeader = true, dayGroup = null;
  _TimelineItem.dayGroup(this.dayGroup) : isWeekHeader = false, date = null;
}

class _WeekHeader extends StatelessWidget {
  final DateTime date;

  const _WeekHeader({required this.date});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isCurrentWeek = _isCurrentWeek(date);

    return Padding(
      padding: const EdgeInsets.only(top: 32, bottom: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isCurrentWeek 
                  ? theme.colorScheme.primary.withAlpha(30)
                  : theme.colorScheme.surfaceContainerHighest.withAlpha(100),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isCurrentWeek 
                    ? theme.colorScheme.primary.withAlpha(80)
                    : Colors.transparent,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.calendar_view_week,
                  size: 16,
                  color: isCurrentWeek ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                Text(
                  _getWeekLabel(context, date),
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isCurrentWeek ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              height: 1,
              color: theme.colorScheme.outlineVariant.withAlpha(50),
            ),
          ),
        ],
      ),
    );
  }

  bool _isCurrentWeek(DateTime date) {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    
    final targetDate = DateTime(date.year, date.month, date.day);
    return !targetDate.isBefore(DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day)) && 
           !targetDate.isAfter(DateTime(endOfWeek.year, endOfWeek.month, endOfWeek.day));
  }

  String _getWeekLabel(BuildContext context, DateTime date) {
    if (_isCurrentWeek(date)) return context.l10n.currentWeek;
    
    final nextWeek = DateTime.now().add(Duration(days: 8 - DateTime.now().weekday));
    if (date.year == nextWeek.year && date.month == nextWeek.month && date.day == nextWeek.day) {
      return context.l10n.nextWeek;
    }

    final monthName = DateFormat('MMMM', Localizations.localeOf(context).toString()).format(date);
    final weekOfMonth = ((date.day - 1) / 7).floor() + 1;
    return '$monthName, $weekOfMonth. ${context.l10n.week}';
  }
}

class _DateGroup {
  final DateTime date;
  final List<PlannedItem> items;
  _DateGroup({required this.date, required this.items});
}

class _DayTimelineSection extends StatelessWidget {
  final _DateGroup group;

  const _DayTimelineSection({required this.group});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isToday = _isToday(group.date);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 12),
          child: Row(
            children: [
              Container(
                width: 48,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isToday 
                      ? theme.colorScheme.primary 
                      : theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      DateFormat('dd').format(group.date),
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: isToday 
                            ? theme.colorScheme.onPrimary 
                            : theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      context.l10n.weekDays(group.date.weekday.toString()).toUpperCase(),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: isToday 
                            ? theme.colorScheme.onPrimary.withAlpha(200) 
                            : theme.colorScheme.onSurfaceVariant.withAlpha(180),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getFriendlyDate(context, group.date),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isToday ? theme.colorScheme.primary : null,
                    ),
                  ),
                  Text(
                    DateFormat('MMMM yyyy', Localizations.localeOf(context).toString()).format(group.date),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        ...List.generate(group.items.length, (index) {
          return _TimelinePlanTile(
            item: group.items[index],
            date: group.date,
            isLast: index == group.items.length - 1,
          );
        }),
      ],
    );
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  String _getFriendlyDate(BuildContext context, DateTime date) {
    if (_isToday(date)) return context.l10n.today;
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    if (date.year == tomorrow.year && date.month == tomorrow.month && date.day == tomorrow.day) {
      return context.l10n.tomorrow;
    }
    return context.l10n.weekDaysLong(date.weekday.toString());
  }
}

class _TimelinePlanTile extends ConsumerWidget {
  final PlannedItem item;
  final DateTime date;
  final bool isLast;

  const _TimelinePlanTile({
    required this.item,
    required this.date,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isCompleted = item.isCompleted;
    final timeStr = DateFormat('HH:mm').format(item.date);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 48,
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    width: 2,
                    color: theme.colorScheme.outlineVariant.withAlpha(100),
                  ),
                ),
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: isCompleted 
                        ? Colors.green 
                        : (item.isRecurring ? Colors.orange : theme.colorScheme.primary),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: theme.colorScheme.surface,
                      width: 2,
                    ),
                    boxShadow: [
                      if (!isCompleted)
                        BoxShadow(
                          color: (item.isRecurring ? Colors.orange : theme.colorScheme.primary).withAlpha(100),
                          blurRadius: 4,
                          spreadRadius: 1,
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    width: isLast ? 0 : 2,
                    color: theme.colorScheme.outlineVariant.withAlpha(100),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isCompleted 
                      ? theme.colorScheme.surfaceContainerHighest.withAlpha(100)
                      : theme.colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isCompleted 
                        ? Colors.transparent 
                        : theme.colorScheme.outlineVariant.withAlpha(50),
                  ),
                ),
                child: Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          timeStr,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isCompleted ? theme.colorScheme.outline : theme.colorScheme.primary,
                          ),
                        ),
                        if (item.isRecurring)
                          const Icon(Icons.repeat_rounded, size: 12, color: Colors.blueGrey),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Container(
                      width: 1,
                      height: 24,
                      color: theme.colorScheme.outlineVariant.withAlpha(100),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            item.title,
                            style: theme.textTheme.titleMedium?.copyWith(
                              decoration: isCompleted ? TextDecoration.lineThrough : null,
                              color: isCompleted ? theme.colorScheme.outline : null,
                              fontWeight: isCompleted ? FontWeight.normal : FontWeight.w600,
                            ),
                          ),
                          if (item.description != null)
                            Text(
                              item.description!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                        ],
                      ),
                    ),
                    _getTrailingWidget(item),
                    const SizedBox(width: 8),
                    Checkbox(
                      value: isCompleted,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      onChanged: (value) => _toggleCompletion(ref),
                    ),
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert_rounded, size: 20),
                      onSelected: (value) {
                        if (value == 'edit') {
                          context.push('/planner/add', extra: item);
                        } else if (value == 'delete') {
                          _showDeleteConfirmation(context, ref);
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit_rounded, size: 20),
                              SizedBox(width: 8),
                              Text(context.l10n.edit),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete_outline, size: 20, color: Colors.red),
                              SizedBox(width: 8),
                              Text(context.l10n.delete, style: const TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _toggleCompletion(WidgetRef ref) {
    if (item.isRecurring) {
      ref
          .read(plannerNotifierProvider.notifier)
          .toggleInstanceCompletion(item.id, date, !item.isCompletedOn(date));
    } else {
      ref
          .read(plannerNotifierProvider.notifier)
          .toggleCompletion(item.id, !item.isCompleted);
    }
  }

  Future<void> _showDeleteConfirmation(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.deletePlanTitle),
        content: Text(context.l10n.deletePlanContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(context.l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: Text(context.l10n.delete),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(plannerNotifierProvider.notifier).deletePlan(item.id);
    }
  }

  Widget _getTrailingWidget(PlannedItem item) {
    String emoji = '📝';
    if (item.referenceType == 'media') emoji = '🎬';
    if (item.referenceType == 'goal') emoji = '🎯';
    
    return Text(
      emoji, 
      style: const TextStyle(fontSize: 16),
    );
  }
}
