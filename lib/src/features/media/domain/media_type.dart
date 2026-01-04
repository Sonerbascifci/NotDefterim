/// Types of media that can be tracked.
enum MediaType {
  movie,
  series,
  anime,
  book;


  /// Returns the emoji icon for this media type.
  String get icon {
    switch (this) {
      case MediaType.movie:
        return '🎬';
      case MediaType.series:
        return '📺';
      case MediaType.anime:
        return '🎌';
      case MediaType.book:
        return '📚';
    }
  }
}
