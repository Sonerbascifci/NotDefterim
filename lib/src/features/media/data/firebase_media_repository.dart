import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/media_item.dart';
import '../domain/media_type.dart';
import '../domain/media_status.dart';
import '../domain/media_repository.dart';
import 'media_item_dto.dart';

/// Firebase implementation of [MediaRepository].
///
/// Uses Firestore for data persistence at path: /users/{uid}/media_items
class FirebaseMediaRepository implements MediaRepository {
  final FirebaseFirestore _firestore;
  final String _userId;

  FirebaseMediaRepository({
    required String userId,
    FirebaseFirestore? firestore,
  })  : _userId = userId,
        _firestore = firestore ?? FirebaseFirestore.instance;

  /// Reference to the user's media_items collection.
  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('users').doc(_userId).collection('media_items');

  @override
  Stream<List<MediaItem>> getMediaItems({
    required int year,
    MediaType? type,
    MediaStatus? status,
  }) {
    Query<Map<String, dynamic>> query = _collection.where('year', isEqualTo: year);

    if (type != null) {
      query = query.where('type', isEqualTo: type.name);
    }

    if (status != null) {
      query = query.where('status', isEqualTo: status.name);
    }

    return query.orderBy('updatedAt', descending: true).snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => MediaItemDto.fromFirestore(doc).toEntity())
              .toList(),
        );
  }

  @override
  Future<MediaItem?> getMediaItem(String id) async {
    final doc = await _collection.doc(id).get();
    if (!doc.exists) return null;
    return MediaItemDto.fromFirestore(doc).toEntity();
  }

  @override
  Future<void> upsertMediaItem(MediaItem item) async {
    final dto = MediaItemDto.fromEntity(item);
    
    if (item.id.isEmpty) {
      // Create new document
      await _collection.add(dto.toFirestore());
    } else {
      // Update existing document
      await _collection.doc(item.id).set(dto.toFirestore());
    }
  }

  @override
  Future<void> deleteMediaItem(String id) async {
    await _collection.doc(id).delete();
  }
}
