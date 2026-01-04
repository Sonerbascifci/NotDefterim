import 'goal.dart';
import 'goal_log.dart';

/// Abstract repository interface for goal operations.
abstract class GoalRepository {
  /// Gets all goals for the current user.
  Stream<List<Goal>> getGoals();

  /// Gets a single goal by ID.
  Future<Goal?> getGoal(String id);

  /// Creates or updates a goal.
  Future<void> upsertGoal(Goal goal);

  /// Deletes a goal by ID.
  Future<void> deleteGoal(String id);

  /// Gets logs for a specific goal, ordered by createdAt descending.
  Stream<List<GoalLog>> getGoalLogs(String goalId);

  /// Adds a log entry for a goal.
  /// Also updates the goal's currentValue.
  Future<void> addGoalLog(GoalLog log);

  /// Deletes a goal log.
  Future<void> deleteGoalLog(String logId);
}
