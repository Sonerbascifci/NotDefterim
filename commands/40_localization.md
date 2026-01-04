# commands/40_localization.md
## Goal
Uygulamaya profesyonel localization (i18n) altyapısı eklemek.
- TR ve EN ile başla
- Material 3 + go_router + Riverpod ile uyumlu
- String’ler tek yerden yönetilsin, çoğul/parametreli metinler desteklensin

## Decisions
- Flutter’ın resmi çözümü: `flutter_localizations` + `gen-l10n` + `intl`
- ARB dosyaları ile string yönetimi
- Locale seçimi: varsayılan `system`, Settings ekranından manuel override opsiyonu

## Steps
1) pubspec.yaml
- dependencies:
  - flutter_localizations (SDK)
  - intl
- flutter:
  - generate: true

2) l10n.yaml ekle (root’a)
- `arb-dir: lib/src/app/l10n`
- `template-arb-file: app_tr.arb`
- `output-localization-file: app_localizations.dart`
- `output-class: AppLocalizations`
- `synthetic-package: false` (isteğe bağlı; repo tercihine göre)

3) ARB dosyalarını oluştur
- `lib/src/app/l10n/app_tr.arb`
- `lib/src/app/l10n/app_en.arb`
Örnek anahtarlar:
- appTitle
- dashboardTitle
- mediaTitle
- goalsTitle
- settingsTitle
- offlineBanner
- retry
- unexpectedError

4) App wiring (MaterialApp.router)
- `localizationsDelegates` ve `supportedLocales` ekle
- `locale` alanını Settings’teki seçime bağla (Riverpod üzerinden)
- `localeResolutionCallback` ile fallback kurgula

5) Settings ekranına dil seçimi ekle
- seçenekler: System, Türkçe, English
- kalıcılık opsiyonel: shared_preferences ya da Firestore user/settings (sonraki milestone olabilir)

6) Kullanım standardı
- UI içinde string’ler **sadece**: `context.l10n.someKey`
- Doğrudan sabit string yazma (debug hariç)
- Parametreli mesajlar (örn. yearSummaryTitle) ve pluralizasyonu ARB tarafında tanımla

## Files to create/update
- + l10n.yaml
- + lib/src/app/l10n/app_tr.arb
- + lib/src/app/l10n/app_en.arb
- + lib/src/app/l10n/l10n_extension.dart (BuildContext extension)
- * lib/src/app/app.dart (MaterialApp.router localization wiring)
- * lib/src/features/settings/presentation/settings_screen.dart (language picker)

## Acceptance checklist
- Uygulama açıldığında sistem diline göre TR/EN otomatik seçiliyor
- Settings’ten dil değişince anında UI değişiyor
- ARB’dan gelen en az 10 string UI’da kullanılıyor
- Kodda “hard-coded” UI string kalmıyor (kritik ekranlarda)

## Commands
- Generate: `flutter gen-l10n`
- Run: `flutter run`
