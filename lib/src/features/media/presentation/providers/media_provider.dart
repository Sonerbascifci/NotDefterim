import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/firebase_media_repository.dart';
import '../../domain/media_item.dart';
import '../../domain/media_type.dart';
import '../../domain/media_status.dart';
import '../../domain/media_repository.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

/// Provider for the [MediaRepository] implementation.
///
/// Requires authenticated user to access media items.
final mediaRepositoryProvider = Provider<MediaRepository?>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return null;
  return FirebaseMediaRepository(userId: user.uid);
});

/// Filter parameters for media list queries.
class MediaFilter {
  final int year;
  final MediaType? type;
  final MediaStatus? status;

  const MediaFilter({
    required this.year,
    this.type,
    this.status,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MediaFilter &&
          runtimeType == other.runtimeType &&
          year == other.year &&
          type == other.type &&
          status == other.status;

  @override
  int get hashCode => year.hashCode ^ type.hashCode ^ status.hashCode;
}

/// Provider for the current selected year filter.
final selectedYearProvider = StateProvider<int>((ref) {
  return DateTime.now().year;
});

/// Provider for the current selected type filter.
final selectedTypeProvider = StateProvider<MediaType?>((ref) => null);

/// Provider for the current selected status filter.
final selectedStatusProvider = StateProvider<MediaStatus?>((ref) => null);

/// Provider for the current media filter combination.
final mediaFilterProvider = Provider<MediaFilter>((ref) {
  return MediaFilter(
    year: ref.watch(selectedYearProvider),
    type: ref.watch(selectedTypeProvider),
    status: ref.watch(selectedStatusProvider),
  );
});

/// Stream provider for the filtered media list.
final mediaListProvider = StreamProvider<List<MediaItem>>((ref) {
  final repository = ref.watch(mediaRepositoryProvider);
  if (repository == null) return const Stream.empty();

  final filter = ref.watch(mediaFilterProvider);
  return repository.getMediaItems(
    year: filter.year,
    type: filter.type,
    status: filter.status,
  );
});

/// Provider for a single media item by ID.
final mediaItemProvider = FutureProvider.family<MediaItem?, String>((ref, id) async {
  final repository = ref.watch(mediaRepositoryProvider);
  if (repository == null) return null;
  return repository.getMediaItem(id);
});

/// Notifier for media item CRUD operations.
class MediaNotifier extends StateNotifier<AsyncValue<void>> {
  final MediaRepository _repository;

  MediaNotifier(this._repository) : super(const AsyncValue.data(null));

  /// Creates or updates a media item.
  Future<bool> upsertMediaItem(MediaItem item) async {
    state = const AsyncValue.loading();
    try {
      await _repository.upsertMediaItem(item);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  /// Deletes a media item.
  Future<bool> deleteMediaItem(String id) async {
    state = const AsyncValue.loading();
    try {
      await _repository.deleteMediaItem(id);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}

/// Provider for [MediaNotifier].
final mediaNotifierProvider =
    StateNotifierProvider<MediaNotifier, AsyncValue<void>>((ref) {
  final repository = ref.watch(mediaRepositoryProvider);
  if (repository == null) {
    throw UnimplementedError('User must be authenticated');
  }
  return MediaNotifier(repository);
});
