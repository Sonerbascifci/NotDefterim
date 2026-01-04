import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:not_defterim/src/features/media/domain/media_type.dart';
import 'package:not_defterim/src/features/media/domain/media_status.dart';
import 'package:not_defterim/src/features/media/presentation/providers/media_provider.dart';
import 'package:not_defterim/src/features/goals/presentation/providers/goal_provider.dart';
import 'package:not_defterim/src/features/goals/domain/goal_status.dart';

/// Summary data for the dashboard.
class DashboardSummary {
  final int totalMedia;
  final int completedMedia;
  final int inProgressMedia;
  final Map<MediaType, int> mediaByType;
  final int totalGoals;
  final int activeGoals;
  final int completedGoals;
  final double overallGoalProgress;

  const DashboardSummary({
    required this.totalMedia,
    required this.completedMedia,
    required this.inProgressMedia,
    required this.mediaByType,
    required this.totalGoals,
    required this.activeGoals,
    required this.completedGoals,
    required this.overallGoalProgress,
  });

  static const empty = DashboardSummary(
    totalMedia: 0,
    completedMedia: 0,
    inProgressMedia: 0,
    mediaByType: {},
    totalGoals: 0,
    activeGoals: 0,
    completedGoals: 0,
    overallGoalProgress: 0,
  );
}

/// Provider for dashboard summary data.
/// Aggregates data from media and goals providers.
final dashboardSummaryProvider = Provider<AsyncValue<DashboardSummary>>((ref) {
  final mediaAsync = ref.watch(mediaListProvider);
  final goalsAsync = ref.watch(goalsProvider);

  // If either is loading, return loading
  if (mediaAsync.isLoading || goalsAsync.isLoading) {
    return const AsyncValue.loading();
  }

  // If there's an error, return empty summary
  final mediaList = mediaAsync.valueOrNull ?? [];
  final goalsList = goalsAsync.valueOrNull ?? [];

  // Calculate media stats
  final totalMedia = mediaList.length;
  final completedMedia = mediaList
      .where((m) => m.status == MediaStatus.completed)
      .length;
  final inProgressMedia = mediaList
      .where((m) => m.status == MediaStatus.inProgress)
      .length;

  final mediaByType = <MediaType, int>{};
  for (final type in MediaType.values) {
    mediaByType[type] = mediaList.where((m) => m.type == type).length;
  }

  // Calculate goals stats
  final totalGoals = goalsList.length;
  final activeGoals = goalsList
      .where((g) => g.status == GoalStatus.active)
      .length;
  final completedGoals = goalsList
      .where((g) => g.status == GoalStatus.completed)
      .length;

  // Overall progress for active goals
  double overallProgress = 0;
  final activeGoalsList = goalsList.where((g) => g.status == GoalStatus.active);
  if (activeGoalsList.isNotEmpty) {
    overallProgress = activeGoalsList
        .map((g) => g.progress)
        .reduce((a, b) => a + b) / activeGoalsList.length;
  }

  return AsyncValue.data(DashboardSummary(
    totalMedia: totalMedia,
    completedMedia: completedMedia,
    inProgressMedia: inProgressMedia,
    mediaByType: mediaByType,
    totalGoals: totalGoals,
    activeGoals: activeGoals,
    completedGoals: completedGoals,
    overallGoalProgress: overallProgress,
  ));
});
