import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/media_item.dart';
import '../domain/media_type.dart';
import '../domain/media_status.dart';

/// Data Transfer Object for MediaItem.
///
/// Handles conversion between Firestore documents and domain entities.
class MediaItemDto {
  final String id;
  final String title;
  final String type;
  final String status;
  final int year;
  final int? rating;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const MediaItemDto({
    required this.id,
    required this.title,
    required this.type,
    required this.status,
    required this.year,
    this.rating,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Creates a DTO from a Firestore document.
  factory MediaItemDto.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MediaItemDto(
      id: doc.id,
      title: data['title'] as String,
      type: data['type'] as String,
      status: data['status'] as String,
      year: data['year'] as int,
      rating: data['rating'] as int?,
      notes: data['notes'] as String?,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  /// Converts this DTO to a Firestore document map.
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'type': type,
      'status': status,
      'year': year,
      'rating': rating,
      'notes': notes,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  /// Creates a DTO from a domain entity.
  factory MediaItemDto.fromEntity(MediaItem entity) {
    return MediaItemDto(
      id: entity.id,
      title: entity.title,
      type: entity.type.name,
      status: entity.status.name,
      year: entity.year,
      rating: entity.rating,
      notes: entity.notes,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  /// Converts this DTO to a domain entity.
  MediaItem toEntity() {
    return MediaItem(
      id: id,
      title: title,
      type: MediaType.values.firstWhere((e) => e.name == type),
      status: MediaStatus.values.firstWhere((e) => e.name == status),
      year: year,
      rating: rating,
      notes: notes,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
