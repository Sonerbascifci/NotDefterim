/// Status of a media item in the tracking list.
enum MediaStatus {
  planned,
  inProgress,
  completed,
  dropped;


  /// Returns the icon for this status.
  String get icon {
    switch (this) {
      case MediaStatus.planned:
        return '📋';
      case MediaStatus.inProgress:
        return '▶️';
      case MediaStatus.completed:
        return '✅';
      case MediaStatus.dropped:
        return '❌';
    }
  }
}
