# commands/42_custom_loading_and_error_pages.md
## Goal
Uygulama genelinde tutarlı “loading” ve “error” UI standardı kurmak.
- Custom loading (spinner değil: modern, premium)
- Hata sayfaları:
  - Route-level error page (go_router errorBuilder)
  - Feature-level empty/error states
- Riverpod AsyncValue için tek tip render

## Decisions
- Loading: 
  - `AppLoadingView` (full-screen)
  - `AppLoadingOverlay` (buton basıldıktan sonra overlay)
  - `SkeletonCard` (liste ekranları için)
- Error:
  - `AppErrorView` (ikon + mesaj + retry)
  - `RouteErrorScreen` (404/unknown route + fallback)
- go_router:
  - `errorBuilder` ile global route error page
- AsyncValue:
  - `AsyncValueView<T>` wrapper: loading/error/data/empty tek yerden yönetilir

## Steps
1) Core UI components oluştur
- `lib/src/core/widgets/app_loading_view.dart`
- `lib/src/core/widgets/app_loading_overlay.dart`
- `lib/src/core/widgets/skeletons/skeleton_list.dart`
- `lib/src/core/widgets/app_error_view.dart`
- `lib/src/core/widgets/app_empty_view.dart` (empty state standardı)

2) Error mapping (domain failure -> UI message)
- `lib/src/core/errors/failure.dart` (domain ile uyumlu tip)
- `lib/src/core/errors/error_mapper.dart`
  - FirebaseException, Dio/Http, unknown -> kullanıcı dostu mesaj
  - l10n string anahtarlarına bağla (commands/40 ile)

3) AsyncValue wrapper
- `lib/src/core/widgets/async_value_view.dart`
  - `AsyncValue<T>` alır
  - states:
    - loading -> skeleton veya loading view
    - error -> AppErrorView (retry callback zorunlu)
    - data -> builder
    - empty -> AppEmptyView (opsiyonel predicate)

4) go_router global error page
- Router config’e `errorBuilder` ekle:
  - `RouteErrorScreen(error: state.error)`
- `RouteErrorScreen` içinde:
  - “Ana sayfaya dön” butonu
  - Debug modda error details (collapsed)

5) Feature ekranlarına uygula (örnek 1-2 ekran)
- Dashboard/Media list ekranında:
  - AsyncValueView kullan
  - Empty state: “Henüz kayıt yok, + ile ekle”
  - Error: retry -> provider refresh

6) Custom loading tasarım dili
- Material 3
- Büyük başlık + küçük açıklama
- Hafif animasyon (çok abartma)
- Dark mode ile uyumlu

7) Test
- Widget tests:
  - AsyncValue loading => skeleton gösteriyor
  - AsyncValue error => retry callback çalışıyor
  - RouteErrorScreen render oluyor

## Files to create/update
- + lib/src/core/widgets/app_loading_view.dart
- + lib/src/core/widgets/app_loading_overlay.dart
- + lib/src/core/widgets/skeletons/skeleton_list.dart
- + lib/src/core/widgets/app_error_view.dart
- + lib/src/core/widgets/app_empty_view.dart
- + lib/src/core/widgets/async_value_view.dart
- + lib/src/core/errors/failure.dart
- + lib/src/core/errors/error_mapper.dart
- + lib/src/app/route_error_screen.dart
- * lib/src/app/router.dart (errorBuilder entegrasyonu)
- * En az 1 feature ekranı (AsyncValueView’e geçiş)

## Acceptance checklist
- Route hatasında (yanlış path) RouteErrorScreen çıkıyor
- En az bir list ekranında:
  - loading: skeleton
  - empty: empty view
  - error: retry’lı error view
- Dark mode’da tüm view’lar doğru görünüyor
- flutter analyze + testler temiz

## Commands
- Analyze: `flutter analyze`
- Test: `flutter test`
