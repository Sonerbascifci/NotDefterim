import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('tr'),
  ];

  /// Uygulamanın ana başlığı
  ///
  /// In tr, this message translates to:
  /// **'Not Defterim'**
  String get appTitle;

  /// No description provided for @dashboardTitle.
  ///
  /// In tr, this message translates to:
  /// **'Panel'**
  String get dashboardTitle;

  /// No description provided for @mediaTitle.
  ///
  /// In tr, this message translates to:
  /// **'Arşiv'**
  String get mediaTitle;

  /// No description provided for @goalsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Hedefler'**
  String get goalsTitle;

  /// No description provided for @settingsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Ayarlar'**
  String get settingsTitle;

  /// No description provided for @plannerTitle.
  ///
  /// In tr, this message translates to:
  /// **'Ajanda'**
  String get plannerTitle;

  /// No description provided for @welcomeMessage.
  ///
  /// In tr, this message translates to:
  /// **'Hoş geldin!'**
  String get welcomeMessage;

  /// No description provided for @welcomeBack.
  ///
  /// In tr, this message translates to:
  /// **'Tekrar hoş geldin, {email}'**
  String welcomeBack(String email);

  /// No description provided for @goodMorning.
  ///
  /// In tr, this message translates to:
  /// **'Günaydın! ☀️'**
  String get goodMorning;

  /// No description provided for @goodDay.
  ///
  /// In tr, this message translates to:
  /// **'İyi günler! 🌤️'**
  String get goodDay;

  /// No description provided for @goodEvening.
  ///
  /// In tr, this message translates to:
  /// **'İyi akşamlar! 🌙'**
  String get goodEvening;

  /// No description provided for @totalArchive.
  ///
  /// In tr, this message translates to:
  /// **'Toplam Arşiv'**
  String get totalArchive;

  /// No description provided for @activeGoal.
  ///
  /// In tr, this message translates to:
  /// **'Aktif Hedef'**
  String get activeGoal;

  /// No description provided for @mediaBreakdown.
  ///
  /// In tr, this message translates to:
  /// **'Arşiv Dağılımı'**
  String get mediaBreakdown;

  /// No description provided for @goalsProgress.
  ///
  /// In tr, this message translates to:
  /// **'Hedef İlerlemesi'**
  String get goalsProgress;

  /// No description provided for @plannerProgress.
  ///
  /// In tr, this message translates to:
  /// **'Haftalık Plan'**
  String get plannerProgress;

  /// No description provided for @total.
  ///
  /// In tr, this message translates to:
  /// **'Toplam'**
  String get total;

  /// No description provided for @completed.
  ///
  /// In tr, this message translates to:
  /// **'Tamamlanan'**
  String get completed;

  /// No description provided for @remaining.
  ///
  /// In tr, this message translates to:
  /// **'Kalan'**
  String get remaining;

  /// No description provided for @theme.
  ///
  /// In tr, this message translates to:
  /// **'Tema'**
  String get theme;

  /// No description provided for @themeSystem.
  ///
  /// In tr, this message translates to:
  /// **'Sistem'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In tr, this message translates to:
  /// **'Açık'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In tr, this message translates to:
  /// **'Koyu'**
  String get themeDark;

  /// No description provided for @language.
  ///
  /// In tr, this message translates to:
  /// **'Dil'**
  String get language;

  /// No description provided for @logout.
  ///
  /// In tr, this message translates to:
  /// **'Çıkış Yap'**
  String get logout;

  /// No description provided for @noContentYet.
  ///
  /// In tr, this message translates to:
  /// **'Henüz bir içerik eklenmemiş'**
  String get noContentYet;

  /// No description provided for @noGoalYet.
  ///
  /// In tr, this message translates to:
  /// **'Henüz hedef eklenmemiş'**
  String get noGoalYet;

  /// No description provided for @plannerEmpty.
  ///
  /// In tr, this message translates to:
  /// **'Ajandanız Boş'**
  String get plannerEmpty;

  /// No description provided for @add.
  ///
  /// In tr, this message translates to:
  /// **'Ekle'**
  String get add;

  /// No description provided for @save.
  ///
  /// In tr, this message translates to:
  /// **'Kaydet'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In tr, this message translates to:
  /// **'İptal'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In tr, this message translates to:
  /// **'Sil'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In tr, this message translates to:
  /// **'Düzenle'**
  String get edit;

  /// No description provided for @details.
  ///
  /// In tr, this message translates to:
  /// **'Detay'**
  String get details;

  /// No description provided for @update.
  ///
  /// In tr, this message translates to:
  /// **'Güncelle'**
  String get update;

  /// No description provided for @successAdded.
  ///
  /// In tr, this message translates to:
  /// **'Başarıyla eklendi'**
  String get successAdded;

  /// No description provided for @successUpdated.
  ///
  /// In tr, this message translates to:
  /// **'Başarıyla güncellendi'**
  String get successUpdated;

  /// No description provided for @successDeleted.
  ///
  /// In tr, this message translates to:
  /// **'Başarıyla silindi'**
  String get successDeleted;

  /// No description provided for @unexpectedError.
  ///
  /// In tr, this message translates to:
  /// **'Beklenmedik bir hata oluştu'**
  String get unexpectedError;

  /// No description provided for @retry.
  ///
  /// In tr, this message translates to:
  /// **'Tekrar Dene'**
  String get retry;

  /// No description provided for @filterAllTypes.
  ///
  /// In tr, this message translates to:
  /// **'Tüm Türler'**
  String get filterAllTypes;

  /// No description provided for @filterAllStatus.
  ///
  /// In tr, this message translates to:
  /// **'Tüm Durumlar'**
  String get filterAllStatus;

  /// No description provided for @filterYear.
  ///
  /// In tr, this message translates to:
  /// **'Yıl'**
  String get filterYear;

  /// No description provided for @type.
  ///
  /// In tr, this message translates to:
  /// **'Tür'**
  String get type;

  /// No description provided for @status.
  ///
  /// In tr, this message translates to:
  /// **'Durum'**
  String get status;

  /// No description provided for @rating.
  ///
  /// In tr, this message translates to:
  /// **'Puan'**
  String get rating;

  /// No description provided for @noRating.
  ///
  /// In tr, this message translates to:
  /// **'Puansız'**
  String get noRating;

  /// No description provided for @notes.
  ///
  /// In tr, this message translates to:
  /// **'Notlar'**
  String get notes;

  /// No description provided for @notesOptional.
  ///
  /// In tr, this message translates to:
  /// **'Notlar (opsiyonel)'**
  String get notesOptional;

  /// No description provided for @notesHint.
  ///
  /// In tr, this message translates to:
  /// **'Yorumlarınız veya notlarınız'**
  String get notesHint;

  /// No description provided for @title.
  ///
  /// In tr, this message translates to:
  /// **'Başlık'**
  String get title;

  /// No description provided for @titleRequired.
  ///
  /// In tr, this message translates to:
  /// **'Başlık gerekli'**
  String get titleRequired;

  /// No description provided for @titleHint.
  ///
  /// In tr, this message translates to:
  /// **'Film, dizi veya kitap adı'**
  String get titleHint;

  /// No description provided for @newContent.
  ///
  /// In tr, this message translates to:
  /// **'Yeni İçerik'**
  String get newContent;

  /// No description provided for @contentAdded.
  ///
  /// In tr, this message translates to:
  /// **'Arşive eklendi'**
  String get contentAdded;

  /// No description provided for @contentDeleted.
  ///
  /// In tr, this message translates to:
  /// **'Arşivden silindi'**
  String get contentDeleted;

  /// No description provided for @contentNotFound.
  ///
  /// In tr, this message translates to:
  /// **'İçerik bulunamadı'**
  String get contentNotFound;

  /// No description provided for @deleteConfirmationTitle.
  ///
  /// In tr, this message translates to:
  /// **'Silmek istediğinize emin misiniz?'**
  String get deleteConfirmationTitle;

  /// No description provided for @deleteConfirmationContent.
  ///
  /// In tr, this message translates to:
  /// **'Bu işlem geri alınamaz.'**
  String get deleteConfirmationContent;

  /// No description provided for @changesSaved.
  ///
  /// In tr, this message translates to:
  /// **'Değişiklikler kaydedildi'**
  String get changesSaved;

  /// No description provided for @mediaTypeMovie.
  ///
  /// In tr, this message translates to:
  /// **'Film'**
  String get mediaTypeMovie;

  /// No description provided for @mediaTypeSeries.
  ///
  /// In tr, this message translates to:
  /// **'Dizi'**
  String get mediaTypeSeries;

  /// No description provided for @mediaTypeAnime.
  ///
  /// In tr, this message translates to:
  /// **'Anime'**
  String get mediaTypeAnime;

  /// No description provided for @mediaTypeBook.
  ///
  /// In tr, this message translates to:
  /// **'Kitap'**
  String get mediaTypeBook;

  /// No description provided for @mediaStatusPlanned.
  ///
  /// In tr, this message translates to:
  /// **'Planlandı'**
  String get mediaStatusPlanned;

  /// No description provided for @mediaStatusInProgress.
  ///
  /// In tr, this message translates to:
  /// **'Devam Ediyor'**
  String get mediaStatusInProgress;

  /// No description provided for @mediaStatusCompleted.
  ///
  /// In tr, this message translates to:
  /// **'Tamamlandı'**
  String get mediaStatusCompleted;

  /// No description provided for @mediaStatusDropped.
  ///
  /// In tr, this message translates to:
  /// **'Bırakıldı'**
  String get mediaStatusDropped;

  /// No description provided for @goalStatusActive.
  ///
  /// In tr, this message translates to:
  /// **'Aktif'**
  String get goalStatusActive;

  /// No description provided for @goalStatusCompleted.
  ///
  /// In tr, this message translates to:
  /// **'Tamamlandı'**
  String get goalStatusCompleted;

  /// No description provided for @goalStatusPaused.
  ///
  /// In tr, this message translates to:
  /// **'Duraklatıldı'**
  String get goalStatusPaused;

  /// No description provided for @goalStatusArchived.
  ///
  /// In tr, this message translates to:
  /// **'Arşivlendi'**
  String get goalStatusArchived;

  /// No description provided for @newGoal.
  ///
  /// In tr, this message translates to:
  /// **'Yeni Hedef'**
  String get newGoal;

  /// No description provided for @goalDescription.
  ///
  /// In tr, this message translates to:
  /// **'Açıklama (opsiyonel)'**
  String get goalDescription;

  /// No description provided for @goalTargetValue.
  ///
  /// In tr, this message translates to:
  /// **'Hedef Değer'**
  String get goalTargetValue;

  /// No description provided for @goalCurrentValue.
  ///
  /// In tr, this message translates to:
  /// **'Mevcut Değer'**
  String get goalCurrentValue;

  /// No description provided for @goalUnit.
  ///
  /// In tr, this message translates to:
  /// **'Birim'**
  String get goalUnit;

  /// No description provided for @goalUnitHint.
  ///
  /// In tr, this message translates to:
  /// **'Örn: Sayfa, Bölüm, Dakika'**
  String get goalUnitHint;

  /// No description provided for @goalIcon.
  ///
  /// In tr, this message translates to:
  /// **'İkon'**
  String get goalIcon;

  /// No description provided for @goalAdded.
  ///
  /// In tr, this message translates to:
  /// **'Hedef eklendi'**
  String get goalAdded;

  /// No description provided for @goalDeleted.
  ///
  /// In tr, this message translates to:
  /// **'Hedef silindi'**
  String get goalDeleted;

  /// No description provided for @goalNotFound.
  ///
  /// In tr, this message translates to:
  /// **'Hedef bulunamadı'**
  String get goalNotFound;

  /// No description provided for @goalDeleteConfirmationTitle.
  ///
  /// In tr, this message translates to:
  /// **'Hedefi Sil'**
  String get goalDeleteConfirmationTitle;

  /// No description provided for @goalDeleteConfirmationContent.
  ///
  /// In tr, this message translates to:
  /// **'Bu hedef ve tüm ilerleme kayıtları silinecek. Emin misiniz?'**
  String get goalDeleteConfirmationContent;

  /// No description provided for @progressHistory.
  ///
  /// In tr, this message translates to:
  /// **'İlerleme Geçmişi'**
  String get progressHistory;

  /// No description provided for @noProgressHistory.
  ///
  /// In tr, this message translates to:
  /// **'Henüz ilerleme kaydı yok.\n\"İlerleme Ekle\" butonuna tıklayın.'**
  String get noProgressHistory;

  /// No description provided for @addProgress.
  ///
  /// In tr, this message translates to:
  /// **'İlerleme Ekle'**
  String get addProgress;

  /// No description provided for @progressAdded.
  ///
  /// In tr, this message translates to:
  /// **'İlerleme kaydedildi'**
  String get progressAdded;

  /// No description provided for @amount.
  ///
  /// In tr, this message translates to:
  /// **'Miktar (Artış)'**
  String get amount;

  /// No description provided for @date.
  ///
  /// In tr, this message translates to:
  /// **'Tarih'**
  String get date;

  /// No description provided for @time.
  ///
  /// In tr, this message translates to:
  /// **'Saat'**
  String get time;

  /// No description provided for @recurrence.
  ///
  /// In tr, this message translates to:
  /// **'Tekrar'**
  String get recurrence;

  /// No description provided for @newPlan.
  ///
  /// In tr, this message translates to:
  /// **'Yeni Plan'**
  String get newPlan;

  /// No description provided for @editPlan.
  ///
  /// In tr, this message translates to:
  /// **'Planı Düzenle'**
  String get editPlan;

  /// No description provided for @planAdded.
  ///
  /// In tr, this message translates to:
  /// **'Plan eklendi'**
  String get planAdded;

  /// No description provided for @planUpdated.
  ///
  /// In tr, this message translates to:
  /// **'Plan güncellendi'**
  String get planUpdated;

  /// No description provided for @planTitleHint.
  ///
  /// In tr, this message translates to:
  /// **'Kitabı bitir, Film izle vb.'**
  String get planTitleHint;

  /// No description provided for @recurrenceWeekly.
  ///
  /// In tr, this message translates to:
  /// **'Haftalık Tekrarla'**
  String get recurrenceWeekly;

  /// No description provided for @recurrenceWeeklyDesc.
  ///
  /// In tr, this message translates to:
  /// **'Seçili günlerde her hafta oluşturulur'**
  String get recurrenceWeeklyDesc;

  /// No description provided for @endDate.
  ///
  /// In tr, this message translates to:
  /// **'Bitiş Tarihi'**
  String get endDate;

  /// No description provided for @startDate.
  ///
  /// In tr, this message translates to:
  /// **'Başlangıç Tarihi'**
  String get startDate;

  /// No description provided for @noDateSelected.
  ///
  /// In tr, this message translates to:
  /// **'Seçilmedi (Süresiz)'**
  String get noDateSelected;

  /// No description provided for @selectDayError.
  ///
  /// In tr, this message translates to:
  /// **'Lütfen en az bir gün seçin'**
  String get selectDayError;

  /// No description provided for @averageProgress.
  ///
  /// In tr, this message translates to:
  /// **'Ortalama İlerleme'**
  String get averageProgress;

  /// No description provided for @plannerSummary.
  ///
  /// In tr, this message translates to:
  /// **'Ajanda Özeti'**
  String get plannerSummary;

  /// No description provided for @mediaEmptyStateHint.
  ///
  /// In tr, this message translates to:
  /// **'Film, dizi, anime veya kitap ekleyin'**
  String get mediaEmptyStateHint;

  /// No description provided for @goalsEmptyStateHint.
  ///
  /// In tr, this message translates to:
  /// **'Kişisel gelişim hedeflerinizi ekleyin'**
  String get goalsEmptyStateHint;

  /// No description provided for @plannerEmptyHint.
  ///
  /// In tr, this message translates to:
  /// **'Gelecek haftalar için henüz bir plan yapmamışsınız.'**
  String get plannerEmptyHint;

  /// No description provided for @tomorrow.
  ///
  /// In tr, this message translates to:
  /// **'Yarın'**
  String get tomorrow;

  /// No description provided for @today.
  ///
  /// In tr, this message translates to:
  /// **'Bugün'**
  String get today;

  /// No description provided for @about.
  ///
  /// In tr, this message translates to:
  /// **'Hakkında'**
  String get about;

  /// No description provided for @appDescription.
  ///
  /// In tr, this message translates to:
  /// **'Film, dizi, anime, kitap takibi ve kişisel hedefler için not defteriniz.'**
  String get appDescription;

  /// No description provided for @version.
  ///
  /// In tr, this message translates to:
  /// **'Sürüm'**
  String get version;

  /// No description provided for @weekDays.
  ///
  /// In tr, this message translates to:
  /// **'{day, select, 1{Pzt} 2{Sal} 3{Çar} 4{Per} 5{Cum} 6{Cmt} 7{Paz} other{}}'**
  String weekDays(String day);

  /// No description provided for @weekDaysLong.
  ///
  /// In tr, this message translates to:
  /// **'{day, select, 1{Pazartesi} 2{Salı} 3{Çarşamba} 4{Perşembe} 5{Cuma} 6{Cumartesi} 7{Pazar} other{}}'**
  String weekDaysLong(String day);

  /// No description provided for @performance.
  ///
  /// In tr, this message translates to:
  /// **'Performansın'**
  String get performance;

  /// No description provided for @currentWeek.
  ///
  /// In tr, this message translates to:
  /// **'Bu Hafta'**
  String get currentWeek;

  /// No description provided for @nextWeek.
  ///
  /// In tr, this message translates to:
  /// **'Gelecek Hafta'**
  String get nextWeek;

  /// No description provided for @week.
  ///
  /// In tr, this message translates to:
  /// **'Hafta'**
  String get week;

  /// No description provided for @deletePlanTitle.
  ///
  /// In tr, this message translates to:
  /// **'Planı Sil'**
  String get deletePlanTitle;

  /// No description provided for @deletePlanContent.
  ///
  /// In tr, this message translates to:
  /// **'Bu planı silmek istediğinize emin misiniz? Bu işlem geri alınamaz.'**
  String get deletePlanContent;

  /// No description provided for @noInternetConnection.
  ///
  /// In tr, this message translates to:
  /// **'İnternet Bağlantısı Yok'**
  String get noInternetConnection;

  /// No description provided for @checkConnection.
  ///
  /// In tr, this message translates to:
  /// **'Lütfen internet bağlantınızı kontrol edin ve tekrar deneyin.'**
  String get checkConnection;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
