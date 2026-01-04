// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'Not Defterim';

  @override
  String get dashboardTitle => 'Panel';

  @override
  String get mediaTitle => 'Arşiv';

  @override
  String get goalsTitle => 'Hedefler';

  @override
  String get settingsTitle => 'Ayarlar';

  @override
  String get plannerTitle => 'Ajanda';

  @override
  String get welcomeMessage => 'Hoş geldin!';

  @override
  String welcomeBack(String email) {
    return 'Tekrar hoş geldin, $email';
  }

  @override
  String get goodMorning => 'Günaydın! ☀️';

  @override
  String get goodDay => 'İyi günler! 🌤️';

  @override
  String get goodEvening => 'İyi akşamlar! 🌙';

  @override
  String get totalArchive => 'Toplam Arşiv';

  @override
  String get activeGoal => 'Aktif Hedef';

  @override
  String get mediaBreakdown => 'Arşiv Dağılımı';

  @override
  String get goalsProgress => 'Hedef İlerlemesi';

  @override
  String get plannerProgress => 'Haftalık Plan';

  @override
  String get total => 'Toplam';

  @override
  String get completed => 'Tamamlanan';

  @override
  String get remaining => 'Kalan';

  @override
  String get theme => 'Tema';

  @override
  String get themeSystem => 'Sistem';

  @override
  String get themeLight => 'Açık';

  @override
  String get themeDark => 'Koyu';

  @override
  String get language => 'Dil';

  @override
  String get logout => 'Çıkış Yap';

  @override
  String get noContentYet => 'Henüz bir içerik eklenmemiş';

  @override
  String get noGoalYet => 'Henüz hedef eklenmemiş';

  @override
  String get plannerEmpty => 'Ajandanız Boş';

  @override
  String get add => 'Ekle';

  @override
  String get save => 'Kaydet';

  @override
  String get cancel => 'İptal';

  @override
  String get delete => 'Sil';

  @override
  String get edit => 'Düzenle';

  @override
  String get details => 'Detay';

  @override
  String get update => 'Güncelle';

  @override
  String get successAdded => 'Başarıyla eklendi';

  @override
  String get successUpdated => 'Başarıyla güncellendi';

  @override
  String get successDeleted => 'Başarıyla silindi';

  @override
  String get unexpectedError => 'Beklenmedik bir hata oluştu';

  @override
  String get retry => 'Tekrar Dene';

  @override
  String get filterAllTypes => 'Tüm Türler';

  @override
  String get filterAllStatus => 'Tüm Durumlar';

  @override
  String get filterYear => 'Yıl';

  @override
  String get type => 'Tür';

  @override
  String get status => 'Durum';

  @override
  String get rating => 'Puan';

  @override
  String get noRating => 'Puansız';

  @override
  String get notes => 'Notlar';

  @override
  String get notesOptional => 'Notlar (opsiyonel)';

  @override
  String get notesHint => 'Yorumlarınız veya notlarınız';

  @override
  String get title => 'Başlık';

  @override
  String get titleRequired => 'Başlık gerekli';

  @override
  String get titleHint => 'Film, dizi veya kitap adı';

  @override
  String get newContent => 'Yeni İçerik';

  @override
  String get contentAdded => 'Arşive eklendi';

  @override
  String get contentDeleted => 'Arşivden silindi';

  @override
  String get contentNotFound => 'İçerik bulunamadı';

  @override
  String get deleteConfirmationTitle => 'Silmek istediğinize emin misiniz?';

  @override
  String get deleteConfirmationContent => 'Bu işlem geri alınamaz.';

  @override
  String get changesSaved => 'Değişiklikler kaydedildi';

  @override
  String get mediaTypeMovie => 'Film';

  @override
  String get mediaTypeSeries => 'Dizi';

  @override
  String get mediaTypeAnime => 'Anime';

  @override
  String get mediaTypeBook => 'Kitap';

  @override
  String get mediaStatusPlanned => 'Planlandı';

  @override
  String get mediaStatusInProgress => 'Devam Ediyor';

  @override
  String get mediaStatusCompleted => 'Tamamlandı';

  @override
  String get mediaStatusDropped => 'Bırakıldı';

  @override
  String get goalStatusActive => 'Aktif';

  @override
  String get goalStatusCompleted => 'Tamamlandı';

  @override
  String get goalStatusPaused => 'Duraklatıldı';

  @override
  String get goalStatusArchived => 'Arşivlendi';

  @override
  String get newGoal => 'Yeni Hedef';

  @override
  String get goalDescription => 'Açıklama (opsiyonel)';

  @override
  String get goalTargetValue => 'Hedef Değer';

  @override
  String get goalCurrentValue => 'Mevcut Değer';

  @override
  String get goalUnit => 'Birim';

  @override
  String get goalUnitHint => 'Örn: Sayfa, Bölüm, Dakika';

  @override
  String get goalIcon => 'İkon';

  @override
  String get goalAdded => 'Hedef eklendi';

  @override
  String get goalDeleted => 'Hedef silindi';

  @override
  String get goalNotFound => 'Hedef bulunamadı';

  @override
  String get goalDeleteConfirmationTitle => 'Hedefi Sil';

  @override
  String get goalDeleteConfirmationContent =>
      'Bu hedef ve tüm ilerleme kayıtları silinecek. Emin misiniz?';

  @override
  String get progressHistory => 'İlerleme Geçmişi';

  @override
  String get noProgressHistory =>
      'Henüz ilerleme kaydı yok.\n\"İlerleme Ekle\" butonuna tıklayın.';

  @override
  String get addProgress => 'İlerleme Ekle';

  @override
  String get progressAdded => 'İlerleme kaydedildi';

  @override
  String get amount => 'Miktar (Artış)';

  @override
  String get date => 'Tarih';

  @override
  String get time => 'Saat';

  @override
  String get recurrence => 'Tekrar';

  @override
  String get newPlan => 'Yeni Plan';

  @override
  String get editPlan => 'Planı Düzenle';

  @override
  String get planAdded => 'Plan eklendi';

  @override
  String get planUpdated => 'Plan güncellendi';

  @override
  String get planTitleHint => 'Kitabı bitir, Film izle vb.';

  @override
  String get recurrenceWeekly => 'Haftalık Tekrarla';

  @override
  String get recurrenceWeeklyDesc => 'Seçili günlerde her hafta oluşturulur';

  @override
  String get endDate => 'Bitiş Tarihi';

  @override
  String get startDate => 'Başlangıç Tarihi';

  @override
  String get noDateSelected => 'Seçilmedi (Süresiz)';

  @override
  String get selectDayError => 'Lütfen en az bir gün seçin';

  @override
  String get averageProgress => 'Ortalama İlerleme';

  @override
  String get plannerSummary => 'Ajanda Özeti';

  @override
  String get mediaEmptyStateHint => 'Film, dizi, anime veya kitap ekleyin';

  @override
  String get goalsEmptyStateHint => 'Kişisel gelişim hedeflerinizi ekleyin';

  @override
  String get plannerEmptyHint =>
      'Gelecek haftalar için henüz bir plan yapmamışsınız.';

  @override
  String get tomorrow => 'Yarın';

  @override
  String get today => 'Bugün';

  @override
  String get about => 'Hakkında';

  @override
  String get appDescription =>
      'Film, dizi, anime, kitap takibi ve kişisel hedefler için not defteriniz.';

  @override
  String get version => 'Sürüm';

  @override
  String weekDays(String day) {
    String _temp0 = intl.Intl.selectLogic(day, {
      '1': 'Pzt',
      '2': 'Sal',
      '3': 'Çar',
      '4': 'Per',
      '5': 'Cum',
      '6': 'Cmt',
      '7': 'Paz',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String weekDaysLong(String day) {
    String _temp0 = intl.Intl.selectLogic(day, {
      '1': 'Pazartesi',
      '2': 'Salı',
      '3': 'Çarşamba',
      '4': 'Perşembe',
      '5': 'Cuma',
      '6': 'Cumartesi',
      '7': 'Pazar',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String get performance => 'Performansın';

  @override
  String get currentWeek => 'Bu Hafta';

  @override
  String get nextWeek => 'Gelecek Hafta';

  @override
  String get week => 'Hafta';

  @override
  String get deletePlanTitle => 'Planı Sil';

  @override
  String get deletePlanContent =>
      'Bu planı silmek istediğinize emin misiniz? Bu işlem geri alınamaz.';

  @override
  String get noInternetConnection => 'İnternet Bağlantısı Yok';

  @override
  String get checkConnection =>
      'Lütfen internet bağlantınızı kontrol edin ve tekrar deneyin.';
}
