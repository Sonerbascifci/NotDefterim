import 'package:flutter/widgets.dart';
import '../../features/media/domain/media_type.dart';
import '../../features/media/domain/media_status.dart';
import '../../features/goals/domain/goal_status.dart';
import 'app_localizations.dart';

extension MediaTypeL10n on MediaType {
  String displayName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case MediaType.movie:
        return l10n.mediaTypeMovie;
      case MediaType.series:
        return l10n.mediaTypeSeries;
      case MediaType.anime:
        return l10n.mediaTypeAnime;
      case MediaType.book:
        return l10n.mediaTypeBook;
    }
  }
}

extension MediaStatusL10n on MediaStatus {
  String displayName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case MediaStatus.planned:
        return l10n.mediaStatusPlanned;
      case MediaStatus.inProgress:
        return l10n.mediaStatusInProgress;
      case MediaStatus.completed:
        return l10n.mediaStatusCompleted;
      case MediaStatus.dropped:
        return l10n.mediaStatusDropped;
    }
  }
}

extension GoalStatusL10n on GoalStatus {
  String displayName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case GoalStatus.active:
        return l10n.goalStatusActive;
      case GoalStatus.completed:
        return l10n.goalStatusCompleted;
      case GoalStatus.paused:
        return l10n.goalStatusPaused;
      case GoalStatus.archived:
        return l10n.goalStatusArchived;
    }
  }
}
