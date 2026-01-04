import 'goal_status.dart';

/// Represents a user's goal for tracking progress.
class Goal {
  /// Unique identifier (Firestore document ID).
  final String id;

  /// Title of the goal.
  final String title;

  /// Optional description.
  final String? description;

  /// Current status of the goal.
  final GoalStatus status;

  /// Target value to achieve (e.g., 100 for 100%).
  final double targetValue;

  /// Current progress value.
  final double currentValue;

  /// Unit of measurement (e.g., "saat", "%", "kitap").
  final String unit;

  /// Icon emoji for the goal.
  final String? icon;

  /// When this goal was created.
  final DateTime createdAt;

  /// When this goal was last updated.
  final DateTime updatedAt;

  const Goal({
    required this.id,
    required this.title,
    this.description,
    required this.status,
    required this.targetValue,
    required this.currentValue,
    required this.unit,
    this.icon,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Progress as a percentage (0.0 to 1.0).
  double get progress {
    if (targetValue == 0) return 0;
    return (currentValue / targetValue).clamp(0.0, 1.0);
  }

  /// Progress as a percentage string.
  String get progressPercent => '${(progress * 100).toInt()}%';

  Goal copyWith({
    String? id,
    String? title,
    String? description,
    GoalStatus? status,
    double? targetValue,
    double? currentValue,
    String? unit,
    String? icon,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Goal(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      targetValue: targetValue ?? this.targetValue,
      currentValue: currentValue ?? this.currentValue,
      unit: unit ?? this.unit,
      icon: icon ?? this.icon,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Goal && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
