import 'planned_item.dart';

/// Abstract interface for planner data operations.
abstract class PlannerRepository {
  /// Gets all plans for the current user.
  Stream<List<PlannedItem>> getPlans();

  /// Gets a single plan by ID.
  Future<PlannedItem?> getPlan(String id);

  /// Creates or updates a plan.
  Future<void> upsertPlan(PlannedItem plan);

  /// Deletes a plan by ID.
  Future<void> deletePlan(String id);

  /// Toggles the completion status of a non-recurring plan.
  Future<void> toggleCompletion(String id, bool isCompleted);

  /// Toggles the completion status of a specific instance of a recurring plan.
  Future<void> toggleInstanceCompletion(String id, DateTime date, bool isCompleted);
}
