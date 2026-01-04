/// Represents a log entry for goal progress.
class GoalLog {
  /// Unique identifier.
  final String id;

  /// ID of the goal this log belongs to.
  final String goalId;

  /// Value added to goal progress.
  final double value;

  /// Optional note about this progress.
  final String? note;

  /// When this log was created.
  final DateTime createdAt;

  const GoalLog({
    required this.id,
    required this.goalId,
    required this.value,
    this.note,
    required this.createdAt,
  });

  GoalLog copyWith({
    String? id,
    String? goalId,
    double? value,
    String? note,
    DateTime? createdAt,
  }) {
    return GoalLog(
      id: id ?? this.id,
      goalId: goalId ?? this.goalId,
      value: value ?? this.value,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GoalLog && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
