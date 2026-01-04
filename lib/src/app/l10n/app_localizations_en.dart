// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'NoteBook';

  @override
  String get dashboardTitle => 'Dashboard';

  @override
  String get mediaTitle => 'Archive';

  @override
  String get goalsTitle => 'Goals';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get plannerTitle => 'Planner';

  @override
  String get welcomeMessage => 'Welcome!';

  @override
  String welcomeBack(String email) {
    return 'Welcome back, $email';
  }

  @override
  String get goodMorning => 'Good morning! ☀️';

  @override
  String get goodDay => 'Good day! 🌤️';

  @override
  String get goodEvening => 'Good evening! 🌙';

  @override
  String get totalArchive => 'Total Archive';

  @override
  String get activeGoal => 'Active Goal';

  @override
  String get mediaBreakdown => 'Media Breakdown';

  @override
  String get goalsProgress => 'Goals Progress';

  @override
  String get plannerProgress => 'Weekly Plan';

  @override
  String get total => 'Total';

  @override
  String get completed => 'Completed';

  @override
  String get remaining => 'Remaining';

  @override
  String get theme => 'Theme';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get language => 'Language';

  @override
  String get logout => 'Logout';

  @override
  String get noContentYet => 'No content added yet';

  @override
  String get noGoalYet => 'No goals added yet';

  @override
  String get plannerEmpty => 'Your Planner is Empty';

  @override
  String get add => 'Add';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get details => 'Details';

  @override
  String get update => 'Update';

  @override
  String get successAdded => 'Successfully added';

  @override
  String get successUpdated => 'Successfully updated';

  @override
  String get successDeleted => 'Successfully deleted';

  @override
  String get unexpectedError => 'An unexpected error occurred';

  @override
  String get retry => 'Retry';

  @override
  String get filterAllTypes => 'All Types';

  @override
  String get filterAllStatus => 'All Statuses';

  @override
  String get filterYear => 'Year';

  @override
  String get type => 'Type';

  @override
  String get status => 'Status';

  @override
  String get rating => 'Rating';

  @override
  String get noRating => 'No Rating';

  @override
  String get notes => 'Notes';

  @override
  String get notesOptional => 'Notes (optional)';

  @override
  String get notesHint => 'Your comments or notes';

  @override
  String get title => 'Title';

  @override
  String get titleRequired => 'Title is required';

  @override
  String get titleHint => 'Name of movie, series or book';

  @override
  String get newContent => 'New Content';

  @override
  String get contentAdded => 'Added to archive';

  @override
  String get contentDeleted => 'Deleted from archive';

  @override
  String get contentNotFound => 'Content not found';

  @override
  String get deleteConfirmationTitle => 'Are you sure you want to delete?';

  @override
  String get deleteConfirmationContent => 'This action cannot be undone.';

  @override
  String get changesSaved => 'Changes saved';

  @override
  String get mediaTypeMovie => 'Movie';

  @override
  String get mediaTypeSeries => 'Series';

  @override
  String get mediaTypeAnime => 'Anime';

  @override
  String get mediaTypeBook => 'Book';

  @override
  String get mediaStatusPlanned => 'Planned';

  @override
  String get mediaStatusInProgress => 'In Progress';

  @override
  String get mediaStatusCompleted => 'Completed';

  @override
  String get mediaStatusDropped => 'Dropped';

  @override
  String get goalStatusActive => 'Active';

  @override
  String get goalStatusCompleted => 'Completed';

  @override
  String get goalStatusPaused => 'Paused';

  @override
  String get goalStatusArchived => 'Archived';

  @override
  String get newGoal => 'New Goal';

  @override
  String get goalDescription => 'Description (optional)';

  @override
  String get goalTargetValue => 'Target Value';

  @override
  String get goalCurrentValue => 'Current Value';

  @override
  String get goalUnit => 'Unit';

  @override
  String get goalUnitHint => 'Ex: Page, Episode, Minute';

  @override
  String get goalIcon => 'Icon';

  @override
  String get goalAdded => 'Goal added';

  @override
  String get goalDeleted => 'Goal deleted';

  @override
  String get goalNotFound => 'Goal not found';

  @override
  String get goalDeleteConfirmationTitle => 'Delete Goal';

  @override
  String get goalDeleteConfirmationContent =>
      'This goal and all progress logs will be deleted. Are you sure?';

  @override
  String get progressHistory => 'Progress History';

  @override
  String get noProgressHistory =>
      'No progress logs yet.\nClick \"Add Progress\" button.';

  @override
  String get addProgress => 'Add Progress';

  @override
  String get progressAdded => 'Progress logged';

  @override
  String get amount => 'Amount';

  @override
  String get date => 'Date';

  @override
  String get time => 'Time';

  @override
  String get recurrence => 'Recurrence';

  @override
  String get newPlan => 'New Plan';

  @override
  String get editPlan => 'Edit Plan';

  @override
  String get planAdded => 'Plan added';

  @override
  String get planUpdated => 'Plan updated';

  @override
  String get planTitleHint => 'Finish book, Watch movie etc.';

  @override
  String get recurrenceWeekly => 'Repeat Weekly';

  @override
  String get recurrenceWeeklyDesc => 'Created weekly on selected days';

  @override
  String get endDate => 'End Date';

  @override
  String get startDate => 'Start Date';

  @override
  String get noDateSelected => 'Not set (Indefinite)';

  @override
  String get selectDayError => 'Please select at least one day';

  @override
  String get averageProgress => 'Average Progress';

  @override
  String get plannerSummary => 'Planner Summary';

  @override
  String get mediaEmptyStateHint => 'Add a movie, series, anime or book';

  @override
  String get goalsEmptyStateHint => 'Add your personal development goals';

  @override
  String get plannerEmptyHint =>
      'You haven\'t made any plans for the upcoming weeks yet.';

  @override
  String get tomorrow => 'Tomorrow';

  @override
  String get today => 'Today';

  @override
  String get about => 'About';

  @override
  String get appDescription =>
      'Your personal notebook for tracking movies, series, books and goals.';

  @override
  String get version => 'Version';

  @override
  String weekDays(String day) {
    String _temp0 = intl.Intl.selectLogic(day, {
      '1': 'Mon',
      '2': 'Tue',
      '3': 'Wed',
      '4': 'Thu',
      '5': 'Fri',
      '6': 'Sat',
      '7': 'Sun',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String weekDaysLong(String day) {
    String _temp0 = intl.Intl.selectLogic(day, {
      '1': 'Monday',
      '2': 'Tuesday',
      '3': 'Wednesday',
      '4': 'Thursday',
      '5': 'Friday',
      '6': 'Saturday',
      '7': 'Sunday',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String get performance => 'Performance';

  @override
  String get currentWeek => 'This Week';

  @override
  String get nextWeek => 'Next Week';

  @override
  String get week => 'Week';

  @override
  String get deletePlanTitle => 'Delete Plan';

  @override
  String get deletePlanContent =>
      'Are you sure you want to delete this plan? This action cannot be undone.';

  @override
  String get noInternetConnection => 'No Internet Connection';

  @override
  String get checkConnection =>
      'Please check your internet connection and try again.';
}
