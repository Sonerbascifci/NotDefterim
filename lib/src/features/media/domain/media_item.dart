import 'media_type.dart';
import 'media_status.dart';

/// Represents a media item being tracked (movie, series, anime, or book).
///
/// This is a domain entity that holds the core data for media tracking.
/// All fields are immutable.
class MediaItem {
  /// Unique identifier (Firestore document ID).
  final String id;

  /// Title of the media item.
  final String title;

  /// Type of media (movie, series, anime, book).
  final MediaType type;

  /// Current tracking status.
  final MediaStatus status;

  /// Year the media was released or being tracked for.
  final int year;

  /// User rating (1-10), null if not rated.
  final int? rating;

  /// Optional notes/comments.
  final String? notes;

  /// When this item was added.
  final DateTime createdAt;

  /// When this item was last updated.
  final DateTime updatedAt;

  const MediaItem({
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

  /// Creates a copy with updated fields.
  MediaItem copyWith({
    String? id,
    String? title,
    MediaType? type,
    MediaStatus? status,
    int? year,
    int? rating,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MediaItem(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      status: status ?? this.status,
      year: year ?? this.year,
      rating: rating ?? this.rating,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MediaItem &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          type == other.type &&
          status == other.status &&
          year == other.year &&
          rating == other.rating &&
          notes == other.notes;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      type.hashCode ^
      status.hashCode ^
      year.hashCode ^
      rating.hashCode ^
      notes.hashCode;

  @override
  String toString() =>
      'MediaItem(id: $id, title: $title, type: $type, status: $status, year: $year)';
}
