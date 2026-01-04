import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/goal_log.dart';

/// DTO for GoalLog entity.
class GoalLogDto {
  final String id;
  final String goalId;
  final double value;
  final String? note;
  final DateTime createdAt;

  const GoalLogDto({
    required this.id,
    required this.goalId,
    required this.value,
    this.note,
    required this.createdAt,
  });

  factory GoalLogDto.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return GoalLogDto(
      id: doc.id,
      goalId: data['goalId'] as String,
      value: (data['value'] as num).toDouble(),
      note: data['note'] as String?,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'goalId': goalId,
      'value': value,
      'note': note,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory GoalLogDto.fromEntity(GoalLog entity) {
    return GoalLogDto(
      id: entity.id,
      goalId: entity.goalId,
      value: entity.value,
      note: entity.note,
      createdAt: entity.createdAt,
    );
  }

  GoalLog toEntity() {
    return GoalLog(
      id: id,
      goalId: goalId,
      value: value,
      note: note,
      createdAt: createdAt,
    );
  }
}
