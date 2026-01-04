import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/goal.dart';
import '../domain/goal_status.dart';

/// DTO for Goal entity.
class GoalDto {
  final String id;
  final String title;
  final String? description;
  final String status;
  final double targetValue;
  final double currentValue;
  final String unit;
  final String? icon;
  final DateTime createdAt;
  final DateTime updatedAt;

  const GoalDto({
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

  factory GoalDto.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return GoalDto(
      id: doc.id,
      title: data['title'] as String,
      description: data['description'] as String?,
      status: data['status'] as String,
      targetValue: (data['targetValue'] as num).toDouble(),
      currentValue: (data['currentValue'] as num).toDouble(),
      unit: data['unit'] as String,
      icon: data['icon'] as String?,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'status': status,
      'targetValue': targetValue,
      'currentValue': currentValue,
      'unit': unit,
      'icon': icon,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  factory GoalDto.fromEntity(Goal entity) {
    return GoalDto(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      status: entity.status.name,
      targetValue: entity.targetValue,
      currentValue: entity.currentValue,
      unit: entity.unit,
      icon: entity.icon,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  Goal toEntity() {
    return Goal(
      id: id,
      title: title,
      description: description,
      status: GoalStatus.values.firstWhere((e) => e.name == status),
      targetValue: targetValue,
      currentValue: currentValue,
      unit: unit,
      icon: icon,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
