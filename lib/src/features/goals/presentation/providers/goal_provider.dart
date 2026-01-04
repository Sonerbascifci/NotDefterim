import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/firebase_goal_repository.dart';
import '../../domain/goal.dart';
import '../../domain/goal_log.dart';
import '../../domain/goal_repository.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

/// Provider for the [GoalRepository] implementation.
final goalRepositoryProvider = Provider<GoalRepository?>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return null;
  return FirebaseGoalRepository(userId: user.uid);
});

/// Stream provider for all goals.
final goalsProvider = StreamProvider<List<Goal>>((ref) {
  final repository = ref.watch(goalRepositoryProvider);
  if (repository == null) return const Stream.empty();
  return repository.getGoals();
});

/// Provider for a single goal by ID.
final goalProvider = FutureProvider.family<Goal?, String>((ref, id) async {
  final repository = ref.watch(goalRepositoryProvider);
  if (repository == null) return null;
  return repository.getGoal(id);
});

/// Stream provider for goal logs.
final goalLogsProvider = StreamProvider.family<List<GoalLog>, String>((ref, goalId) {
  final repository = ref.watch(goalRepositoryProvider);
  if (repository == null) return const Stream.empty();
  return repository.getGoalLogs(goalId);
});

/// Notifier for goal CRUD operations.
class GoalNotifier extends StateNotifier<AsyncValue<void>> {
  final GoalRepository _repository;

  GoalNotifier(this._repository) : super(const AsyncValue.data(null));

  Future<bool> upsertGoal(Goal goal) async {
    state = const AsyncValue.loading();
    try {
      await _repository.upsertGoal(goal);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  Future<bool> deleteGoal(String id) async {
    state = const AsyncValue.loading();
    try {
      await _repository.deleteGoal(id);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  Future<bool> addGoalLog(GoalLog log) async {
    state = const AsyncValue.loading();
    try {
      await _repository.addGoalLog(log);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}

/// Provider for [GoalNotifier].
final goalNotifierProvider =
    StateNotifierProvider<GoalNotifier, AsyncValue<void>>((ref) {
  final repository = ref.watch(goalRepositoryProvider);
  if (repository == null) {
    throw UnimplementedError('User must be authenticated');
  }
  return GoalNotifier(repository);
});
