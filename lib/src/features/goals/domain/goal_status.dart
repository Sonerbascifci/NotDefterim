/// Status of a goal.
enum GoalStatus {
  active,
  completed,
  paused,
  archived;


  /// Returns the icon for this status.
  String get icon {
    switch (this) {
      case GoalStatus.active:
        return '🎯';
      case GoalStatus.completed:
        return '✅';
      case GoalStatus.paused:
        return '⏸️';
      case GoalStatus.archived:
        return '📦';
    }
  }
}
