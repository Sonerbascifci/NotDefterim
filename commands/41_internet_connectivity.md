# commands/41_internet_connectivity.md
## Goal
Internet bağlantı durumunu izleyen altyapı eklemek.
- Online/Offline durumunu global takip et
- Offline iken kullanıcıya kibar banner/snackbar göster
- Ağ gelince otomatik “retry” akışı için hook sağla

## Decisions
- Paket: `connectivity_plus` (bağlantı tipini verir)
- NOT: connectivity, internetin gerçekten çalıştığını garanti etmez.
  Bu yüzden opsiyonel olarak “reachability check” eklenebilir:
  - hafif HTTP ping (ör. https://www.google.com/generate_204) veya
  - Firebase / Firestore ile küçük okuma (maliyet/limit dikkat)
  MVP’de: connectivity_plus + basit doğrulama (opsiyon flag)

## Steps
1) pubspec.yaml
- dependencies:
  - connectivity_plus
  - (opsiyonel) http

2) Core servis katmanı (Clean Architecture uyumlu)
- `lib/src/core/connectivity/connectivity_service.dart`
  - Stream<ConnectivityStatus> (online/offline)
  - currentStatus getter
  - dispose

3) Riverpod provider
- `connectivityStatusProvider` (StreamProvider)
- `isOnlineProvider` (Provider<bool>)

4) UI global banner
- App Shell (tab scaffold) üzerinde üstte ince bir banner:
  - Offline iken: “Çevrimdışısın. Kayıtlar cihazda saklanacak.”
  - Online olunca: banner kaybolur
- Banner component:
  - `lib/src/core/widgets/offline_banner.dart`

5) Retry hook standardı
- AsyncValue kullanan ekranlar için:
  - Offline ise retry butonu disable veya “Bağlantı bekleniyor” göster
- `AsyncValue` wrapper widget’ına connectivity entegrasyonu (command 42 ile birlikte kullanılacak)

6) Test
- Unit test: ConnectivityService mapping (fake stream ile)
- Widget test: offline banner görünür/gizlenir

## Files to create/update
- + lib/src/core/connectivity/connectivity_status.dart (enum/model)
- + lib/src/core/connectivity/connectivity_service.dart
- + lib/src/core/connectivity/connectivity_providers.dart
- + lib/src/core/widgets/offline_banner.dart
- * lib/src/app/app_shell.dart (banner entegrasyonu)

## Acceptance checklist
- Uçak modunda banner görünür
- İnternet geri gelince banner kaybolur
- En az 1 ekranda offline iken “retry” davranışı düzgün
- Analiz ve testler temiz

## Commands
- Run: `flutter run`
- Test: `flutter test`
