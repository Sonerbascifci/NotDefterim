import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/planned_item.dart';

/// DTO for PlannedItem to handle Firestore serialization.
class PlannedItemDto {
  final String id;
  final String title;
  final String? description;
  final DateTime date;
  final DateTime? endDate;
  final bool isCompleted;
  final bool isRecurring;
  final List<int>? recurrenceDays;
  final List<DateTime> completedDates;
  final String? referenceId;
  final String? referenceType;
  final DateTime createdAt;

  const PlannedItemDto({
    required this.id,
    required this.title,
    this.description,
    required this.date,
    this.endDate,
    required this.isCompleted,
    required this.isRecurring,
    this.recurrenceDays,
    required this.completedDates,
    this.referenceId,
    this.referenceType,
    required this.createdAt,
  });

  factory PlannedItemDto.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PlannedItemDto(
      id: doc.id,
      title: data['title'] as String,
      description: data['description'] as String?,
      date: (data['date'] as Timestamp).toDate(),
      endDate: (data['endDate'] as Timestamp?)?.toDate(),
      isCompleted: data['isCompleted'] as bool? ?? false,
      isRecurring: data['isRecurring'] as bool? ?? false,
      recurrenceDays: (data['recurrenceDays'] as List<dynamic>?)?.cast<int>(),
      completedDates: (data['completedDates'] as List<dynamic>?)
              ?.map((t) => (t as Timestamp).toDate())
              .toList() ??
          [],
      referenceId: data['referenceId'] as String?,
      referenceType: data['referenceType'] as String?,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'date': Timestamp.fromDate(date),
      'endDate': endDate != null ? Timestamp.fromDate(endDate!) : null,
      'isCompleted': isCompleted,
      'isRecurring': isRecurring,
      'recurrenceDays': recurrenceDays,
      'completedDates': completedDates.map((d) => Timestamp.fromDate(d)).toList(),
      'referenceId': referenceId,
      'referenceType': referenceType,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory PlannedItemDto.fromEntity(PlannedItem entity) {
    return PlannedItemDto(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      date: entity.date,
      endDate: entity.endDate,
      isCompleted: entity.isCompleted,
      isRecurring: entity.isRecurring,
      recurrenceDays: entity.recurrenceDays,
      completedDates: entity.completedDates,
      referenceId: entity.referenceId,
      referenceType: entity.referenceType,
      createdAt: entity.createdAt,
    );
  }

  PlannedItem toEntity() {
    return PlannedItem(
      id: id,
      title: title,
      description: description,
      date: date,
      endDate: endDate,
      isCompleted: isCompleted,
      isRecurring: isRecurring,
      recurrenceDays: recurrenceDays,
      completedDates: completedDates,
      referenceId: referenceId,
      referenceType: referenceType,
      createdAt: createdAt,
    );
  }
}
