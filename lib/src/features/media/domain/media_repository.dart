import 'media_item.dart';
import 'media_type.dart';
import 'media_status.dart';

/// Abstract repository interface for media item operations.
///
/// Defines the contract for CRUD operations on media items.
/// The data layer provides the concrete implementation.
abstract class MediaRepository {
  /// Gets a list of media items with optional filters.
  ///
  /// [year] filters by year (required).
  /// [type] filters by media type (optional).
  /// [status] filters by status (optional).
  Stream<List<MediaItem>> getMediaItems({
    required int year,
    MediaType? type,
    MediaStatus? status,
  });

  /// Gets a single media item by ID.
  Future<MediaItem?> getMediaItem(String id);

  /// Creates or updates a media item.
  ///
  /// If the item has an empty ID, a new document is created.
  /// Otherwise, the existing document is updated.
  Future<void> upsertMediaItem(MediaItem item);

  /// Deletes a media item by ID.
  Future<void> deleteMediaItem(String id);
}
