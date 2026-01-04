import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:not_defterim/src/features/auth/presentation/providers/auth_provider.dart';
import 'package:not_defterim/src/core/services/notification_service.dart';
import '../../data/firebase_planner_repository.dart';
import '../../domain/planned_item.dart';
import '../../domain/planner_repository.dart';

/// Provider for the PlannerRepository.
final plannerRepositoryProvider = Provider<PlannerRepository?>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return null;
  return FirebasePlannerRepository(userId: user.uid);
});

/// Stream provider for all plans.
final plansProvider = StreamProvider<List<PlannedItem>>((ref) {
  final repository = ref.watch(plannerRepositoryProvider);
  if (repository == null) return const Stream.empty();
  return repository.getPlans();
});

/// Notifier for Planner CRUD operations.
class PlannerNotifier extends StateNotifier<AsyncValue<void>> {
  final PlannerRepository _repository;
  final NotificationService _notificationService = NotificationService();

  PlannerNotifier(this._repository) : super(const AsyncValue.data(null));

  Future<bool> upsertPlan(PlannedItem plan) async {
    state = const AsyncValue.loading();
    try {
      await _repository.upsertPlan(plan);
      
      // Schedule notification for the plan
      await _scheduleNotificationForPlan(plan);
      
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  Future<bool> deletePlan(String id) async {
    state = const AsyncValue.loading();
    try {
      // Cancel notification before deleting
      final notificationId = NotificationService.getNotificationId(id);
      await _notificationService.cancelNotification(notificationId);
      
      await _repository.deletePlan(id);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  Future<void> _scheduleNotificationForPlan(PlannedItem plan) async {
    // Cancel any existing notification for this plan
    final notificationId = NotificationService.getNotificationId(plan.id);
    await _notificationService.cancelNotification(notificationId);
    
    // Only schedule if the plan is in the future
    if (plan.date.isAfter(DateTime.now())) {
      await _notificationService.scheduleNotification(
        id: notificationId,
        title: '⏰ Plan Hatırlatıcı',
        body: plan.title,
        scheduledTime: plan.date,
        payload: plan.id,
      );
    }
  }

  Future<bool> toggleCompletion(String id, bool isCompleted) async {
    try {
      await _repository.toggleCompletion(id, isCompleted);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> toggleInstanceCompletion(
      String id, DateTime date, bool isCompleted) async {
    try {
      await _repository.toggleInstanceCompletion(id, date, isCompleted);
      return true;
    } catch (e) {
      return false;
    }
  }
}

/// Provider for PlannerNotifier.
final plannerNotifierProvider =
    StateNotifierProvider<PlannerNotifier, AsyncValue<void>>((ref) {
  final repository = ref.watch(plannerRepositoryProvider);
  if (repository == null) {
    throw UnimplementedError('User must be authenticated');
  }
  return PlannerNotifier(repository);
});

/// Model for planner statistics.
class PlannerStats {
  final int totalTasks;
  final int completedTasks;
  final double completionRate;

  PlannerStats({
    required this.totalTasks,
    required this.completedTasks,
  }) : completionRate = totalTasks > 0 ? completedTasks / totalTasks : 0;
}

/// Provider for planner statistics in the next 90 days.
final plannerStatsProvider = Provider<PlannerStats>((ref) {
  final plansAsync = ref.watch(plansProvider);
  return plansAsync.maybeWhen(
    data: (plans) {
      if (plans.isEmpty) return PlannerStats(totalTasks: 0, completedTasks: 0);

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      int total = 0;
      int completed = 0;

      // Calculate for the 90 day window
      for (int i = 0; i < 90; i++) {
        final date = today.add(Duration(days: i));
        for (final plan in plans) {
          if (plan.occursOn(date)) {
            total++;
            if (plan.isCompletedOn(date)) {
              completed++;
            }
          }
        }
      }

      return PlannerStats(totalTasks: total, completedTasks: completed);
    },
    orElse: () => PlannerStats(totalTasks: 0, completedTasks: 0),
  );
});
