import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/goal.dart';
import '../domain/goal_log.dart';
import '../domain/goal_repository.dart';
import 'goal_dto.dart';
import 'goal_log_dto.dart';

/// Firebase implementation of [GoalRepository].
class FirebaseGoalRepository implements GoalRepository {
  final FirebaseFirestore _firestore;
  final String _userId;

  FirebaseGoalRepository({
    required String userId,
    FirebaseFirestore? firestore,
  })  : _userId = userId,
        _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _goalsCollection =>
      _firestore.collection('users').doc(_userId).collection('goals');

  CollectionReference<Map<String, dynamic>> get _logsCollection =>
      _firestore.collection('users').doc(_userId).collection('goal_logs');

  @override
  Stream<List<Goal>> getGoals() {
    return _goalsCollection
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => GoalDto.fromFirestore(doc).toEntity())
            .toList());
  }

  @override
  Future<Goal?> getGoal(String id) async {
    final doc = await _goalsCollection.doc(id).get();
    if (!doc.exists) return null;
    return GoalDto.fromFirestore(doc).toEntity();
  }

  @override
  Future<void> upsertGoal(Goal goal) async {
    final dto = GoalDto.fromEntity(goal);
    if (goal.id.isEmpty) {
      await _goalsCollection.add(dto.toFirestore());
    } else {
      await _goalsCollection.doc(goal.id).set(dto.toFirestore());
    }
  }

  @override
  Future<void> deleteGoal(String id) async {
    await _goalsCollection.doc(id).delete();
    // Also delete related logs
    final logs = await _logsCollection.where('goalId', isEqualTo: id).get();
    for (final doc in logs.docs) {
      await doc.reference.delete();
    }
  }

  @override
  Stream<List<GoalLog>> getGoalLogs(String goalId) {
    return _logsCollection
        .where('goalId', isEqualTo: goalId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => GoalLogDto.fromFirestore(doc).toEntity())
            .toList());
  }

  @override
  Future<void> addGoalLog(GoalLog log) async {
    final dto = GoalLogDto.fromEntity(log);
    await _logsCollection.add(dto.toFirestore());

    // Update goal's currentValue
    final goalDoc = await _goalsCollection.doc(log.goalId).get();
    if (goalDoc.exists) {
      final goal = GoalDto.fromFirestore(goalDoc).toEntity();
      final updatedGoal = goal.copyWith(
        currentValue: goal.currentValue + log.value,
        updatedAt: DateTime.now(),
      );
      await _goalsCollection.doc(log.goalId).set(
            GoalDto.fromEntity(updatedGoal).toFirestore(),
          );
    }
  }

  @override
  Future<void> deleteGoalLog(String logId) async {
    await _logsCollection.doc(logId).delete();
  }
}
