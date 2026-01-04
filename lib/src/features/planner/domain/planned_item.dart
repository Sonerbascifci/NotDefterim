/// Represents a scheduled activity or task in the organizer.
class PlannedItem {
  /// Unique identifier.
  final String id;

  /// Title of the planned item.
  final String title;

  /// Optional description or notes.
  final String? description;

  /// Scheduled date and time.
  /// For recurring items, this represents the start date and the time of the task.
  final DateTime date;

  /// Optional end date for recurring items.
  final DateTime? endDate;

  /// Whether the plan has been completed.
  /// Used for non-recurring items.
  final bool isCompleted;

  /// Whether this plan repeats weekly.
  final bool isRecurring;

  /// List of weekdays for recurrence (1 = Monday, 7 = Sunday).
  final List<int>? recurrenceDays;

  /// List of dates when this recurring item was completed.
  final List<DateTime> completedDates;

  /// Optional ID of the linked MediaItem or Goal.
  final String? referenceId;

  /// Type of reference: 'media', 'goal', or 'task'.
  final String? referenceType;

  /// When this plan was created.
  final DateTime createdAt;

  const PlannedItem({
    required this.id,
    required this.title,
    this.description,
    required this.date,
    this.endDate,
    this.isCompleted = false,
    this.isRecurring = false,
    this.recurrenceDays,
    this.completedDates = const [],
    this.referenceId,
    this.referenceType,
    required this.createdAt,
  });

  PlannedItem copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? date,
    DateTime? endDate,
    bool? isCompleted,
    bool? isRecurring,
    List<int>? recurrenceDays,
    List<DateTime>? completedDates,
    String? referenceId,
    String? referenceType,
    DateTime? createdAt,
  }) {
    return PlannedItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      endDate: endDate ?? this.endDate,
      isCompleted: isCompleted ?? this.isCompleted,
      isRecurring: isRecurring ?? this.isRecurring,
      recurrenceDays: recurrenceDays ?? this.recurrenceDays,
      completedDates: completedDates ?? this.completedDates,
      referenceId: referenceId ?? this.referenceId,
      referenceType: referenceType ?? this.referenceType,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlannedItem && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  /// Checks if this item occurs on a specific date.
  bool occursOn(DateTime date) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    if (!isRecurring) {
      final normalizedPlanDate = DateTime(this.date.year, this.date.month, this.date.day);
      return normalizedDate.isAtSameMomentAs(normalizedPlanDate);
    }

    // For recurring: must be after or on start date AND weekday must match
    if (normalizedDate.isBefore(DateTime(this.date.year, this.date.month, this.date.day))) {
      return false;
    }

    // Must be before or on end date
    if (endDate != null) {
      final normalizedEndDate = DateTime(endDate!.year, endDate!.month, endDate!.day);
      if (normalizedDate.isAfter(normalizedEndDate)) {
        return false;
      }
    }
    
    return recurrenceDays?.contains(normalizedDate.weekday) ?? false;
  }

  /// Checks if this item is completed for a specific date.
  bool isCompletedOn(DateTime date) {
    if (!isRecurring) return isCompleted;
    
    final normalizedDate = DateTime(date.year, date.month, date.day);
    return completedDates.any((d) => 
      DateTime(d.year, d.month, d.day).isAtSameMomentAs(normalizedDate)
    );
  }
}
