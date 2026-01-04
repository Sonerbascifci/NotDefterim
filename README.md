<p align="center">
  <img src="assets/app_icon.png" width="120" alt="Not Defterim Logo">
</p>

<h1 align="center">📓 Not Defterim</h1>

<p align="center">
  <strong>Kişisel medya takip ve hedef yönetimi uygulaması</strong><br>
  <em>Personal media tracking and goal management application</em>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.9.2+-blue?logo=flutter" alt="Flutter">
  <img src="https://img.shields.io/badge/Dart-3.0+-0175C2?logo=dart" alt="Dart">
  <img src="https://img.shields.io/badge/Firebase-Backend-FFCA28?logo=firebase" alt="Firebase">
  <img src="https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Windows-lightgrey" alt="Platforms">
</p>

---

## 📖 Proje Hakkında / About

**Not Defterim**, kullanıcıların izledikleri filmler, diziler, animeler ve okuduğları kitapları takip etmelerini, kişisel hedefler belirlemelerini ve günlük/haftalık planlar oluşturmalarını sağlayan modern bir Flutter uygulamasıdır.

### 🎯 Temel Özellikler / Key Features

| Özellik | Açıklama |
|---------|----------|
| 📚 **Arşiv Yönetimi** | Film, dizi, anime ve kitapları kategorize ederek takip edin |
| 🎯 **Hedef Takibi** | Kişisel gelişim hedefleri belirleyin ve ilerlemenizi kaydedin |
| 📅 **Planlayıcı** | Günlük ve haftalık planlar oluşturun, tekrarlayan görevler ekleyin |
| 🔔 **Bildirimler** | Planlarınız için hatırlatıcı bildirimler alın |
| 🌍 **Çoklu Dil** | Türkçe ve İngilizce dil desteği |
| 🌓 **Tema Desteği** | Açık, koyu ve sistem teması seçenekleri |
| 📱 **Çoklu Platform** | Android, iOS ve Windows desteği |

---

## 🏗️ Mimari / Architecture

Proje, **Clean Architecture** prensiplerine uygun olarak 3 katmanlı bir yapıda tasarlanmıştır:

```
lib/src/
├── app/                    # Uygulama katmanı (Router, Theme, L10n)
├── core/                   # Paylaşılan altyapı (Services, Widgets, Errors)
└── features/               # Özellik modülleri
    ├── auth/               # Kimlik doğrulama
    ├── dashboard/          # Ana panel
    ├── goals/              # Hedef yönetimi
    ├── media/              # Medya arşivi
    ├── planner/            # Planlayıcı
    └── settings/           # Ayarlar
```

### 📂 Katman Detayları / Layer Details

#### 🔷 App Layer (`lib/src/app/`)
| Dosya | Açıklama |
|-------|----------|
| `app.dart` | Ana MaterialApp widget'ı, ConnectivityWrapper entegrasyonu |
| `router.dart` | GoRouter yapılandırması, auth-gated navigation, animated transitions |
| `theme.dart` | Material 3 light/dark tema tanımlamaları |
| `route_error_screen.dart` | 404 ve route hataları için özel ekran |
| `l10n/` | ARB tabanlı çoklu dil desteği (TR/EN) |

#### 🔷 Core Layer (`lib/src/core/`)
| Klasör | İçerik |
|--------|--------|
| `services/` | `NotificationService` - Yerel bildirim yönetimi |
| `presentation/widgets/` | Paylaşılan UI bileşenleri |
| `presentation/providers/` | `connectivityProvider` - İnternet bağlantı izleme |
| `errors/` | `Failure`, `ErrorMapper` - Hata yönetimi |

#### 🔷 Feature Modules
Her feature modülü aşağıdaki yapıyı takip eder:

```
feature/
├── domain/           # Entity ve Repository interface'leri
├── data/             # DTO ve Firebase repository implementasyonları
└── presentation/
    ├── providers/    # Riverpod state management
    └── screens/      # UI ekranları
```

---

## 🛠️ Teknoloji Yığını / Tech Stack

### 📦 Temel Bağımlılıklar / Core Dependencies

| Kategori | Paket | Versiyon | Açıklama |
|----------|-------|----------|----------|
| **State Management** | `flutter_riverpod` | ^2.5.1 | Reaktif state yönetimi |
| | `riverpod_annotation` | ^2.3.5 | Code generation desteği |
| **Navigation** | `go_router` | ^14.6.0 | Declarative routing |
| **Backend** | `firebase_core` | ^3.8.1 | Firebase altyapısı |
| | `firebase_auth` | ^5.3.4 | Kimlik doğrulama |
| | `cloud_firestore` | ^5.6.5 | NoSQL veritabanı |
| **Storage** | `shared_preferences` | ^2.3.4 | Yerel tercih depolama |

### 🎨 UI/UX Paketleri

| Paket | Versiyon | Kullanım |
|-------|----------|----------|
| `animations` | ^2.1.1 | Material motion transitions |
| `flutter_staggered_animations` | ^1.1.1 | Liste animasyonları |
| `lottie` | ^1.4.3 | Lottie JSON animasyonları |
| `shimmer` | ^3.0.0 | Skeleton loading efektleri |

### 🔧 Altyapı Paketleri

| Paket | Versiyon | Kullanım |
|-------|----------|----------|
| `flutter_local_notifications` | ^19.5.0 | Yerel bildirimler |
| `timezone` | ^0.10.1 | Timezone-aware scheduling |
| `flutter_timezone` | ^5.0.1 | Cihaz timezone algılama |
| `connectivity_plus` | ^7.0.0 | Ağ bağlantı izleme |
| `intl` | ^0.20.0 | Tarih/sayı formatlama |

### 🧪 Geliştirme Araçları

| Paket | Kullanım |
|-------|----------|
| `riverpod_generator` | Provider code generation |
| `build_runner` | Kod üretim altyapısı |
| `riverpod_lint` | Riverpod best practices |
| `flutter_launcher_icons` | Uygulama ikonu üretimi |
| `flutter_lints` | Kod kalite analizi |

---

## 🔥 Firebase Yapılandırması / Firebase Configuration

### Firestore Koleksiyonları

```
users/{uid}/
├── media/{mediaId}         # Medya öğeleri
├── goals/{goalId}          # Hedefler
│   └── logs/{logId}        # Hedef ilerleme kayıtları
└── plans/{planId}          # Planlar
```

### Güvenlik Kuralları
- Kullanıcılar yalnızca kendi verilerine erişebilir
- Tüm yazma işlemleri kimlik doğrulama gerektirir

---

## 📱 Özellik Detayları / Feature Details

### 1️⃣ Kimlik Doğrulama (Auth)
- Firebase Authentication entegrasyonu
- Email/password ile giriş
- Otomatik oturum durumu takibi
- Auth-gated routing

### 2️⃣ Dashboard
- Hoşgeldin kartı (günün saatine göre selamlama)
- Toplam arşiv ve aktif hedef istatistikleri
- Medya türü dağılımı
- Hedef ilerleme özeti
- Haftalık plan performansı

### 3️⃣ Arşiv (Media)
- **Desteklenen Türler:** Film, Dizi, Anime, Kitap
- **Durumlar:** Planlandı, Devam Ediyor, Tamamlandı, Bırakıldı
- Yıl ve durum bazlı filtreleme
- 5 yıldızlı puanlama sistemi
- Notlar ve açıklamalar

### 4️⃣ Hedefler (Goals)
- Sayısal hedef belirleme (ör: 50 kitap okumak)
- İlerleme günlüğü tutma
- Aktif/Tamamlandı/Duraklatıldı durumları
- Görsel ilerleme göstergeleri

### 5️⃣ Planlayıcı (Planner)
- Tek seferlik ve tekrarlayan planlar
- Haftalık gün seçimi (Pzt-Paz)
- Başlangıç ve bitiş tarihi
- **🔔 Otomatik hatırlatıcı bildirimleri**
- Timeline görünümü (90 günlük pencere)
- Hafta bazlı gruplama

### 6️⃣ Ayarlar (Settings)
- Tema seçimi (Açık/Koyu/Sistem)
- Dil seçimi (Türkçe/English)
- Uygulama hakkında bilgi
- Çıkış yapma

---

## 🎬 Animasyon Sistemi / Animation System

Uygulama, premium bir kullanıcı deneyimi için çoklu animasyon katmanları içerir:

| Animasyon Türü | Kullanım Alanı |
|----------------|----------------|
| **FadeThroughTransition** | Tab geçişleri |
| **SharedAxisTransition** | Sayfa navigasyonları |
| **OpenContainer** | FAB → Ekran geçişleri |
| **StaggeredAnimation** | Liste öğeleri |
| **Lottie** | Başarı mesajları, boş durumlar |
| **Shimmer** | Yükleme durumları |

---

## 🌐 Çoklu Dil Desteği / Localization

### Desteklenen Diller
- 🇹🇷 Türkçe (varsayılan)
- 🇬🇧 English

### ARB Dosyaları
```
lib/src/app/l10n/
├── app_tr.arb    # Türkçe çeviriler
└── app_en.arb    # İngilizce çeviriler
```

### Kullanım
```dart
// Extension ile
context.l10n.welcomeMessage

// Direkt erişim
AppLocalizations.of(context)!.welcomeMessage
```

---

## 🔔 Bildirim Sistemi / Notification System

### Yapılandırma
- **Android:** `POST_NOTIFICATIONS`, `SCHEDULE_EXACT_ALARM`, boot receiver
- **iOS:** `UNUserNotificationCenterDelegate` entegrasyonu
- **Core Library Desugaring:** Aktif (Android)

### Özellikler
- Timezone-aware scheduling
- Uygulama kapalıyken çalışır
- Cihaz yeniden başlatıldığında korunur
- Plan düzenlendiğinde otomatik güncellenir
- Plan silindiğinde otomatik iptal edilir

---

## 🌐 Bağlantı Yönetimi / Connectivity

Uygulama, internet bağlantısını gerçek zamanlı izler:

- **Offline Durumu:** Tam ekran engelleme overlay'i
- **Otomatik Kurtarma:** Bağlantı geldiğinde overlay kaybolur
- **Stream-based:** `connectivity_plus` ile reaktif izleme

---

## 📊 Hata Yönetimi / Error Handling

### Standart UI Bileşenleri
| Bileşen | Kullanım |
|---------|----------|
| `AppLoadingView` | Tam ekran yükleme |
| `AppLoadingOverlay` | Modal yükleme overlay'i |
| `SkeletonList` | Shimmer liste yükleyici |
| `AppErrorView` | Hata + Retry butonu |
| `AppEmptyView` | Boş durum gösterimi |
| `AsyncValueView<T>` | Riverpod AsyncValue wrapper |

### Route Hataları
- `RouteErrorScreen`: 404 ve bilinmeyen rotalar için
- GoRouter `errorBuilder` entegrasyonu

---

## 🚀 Kurulum / Installation

### Gereksinimler
- Flutter SDK 3.9.2+
- Dart SDK 3.0+
- Firebase project (configured)
- Android Studio / Xcode

### Adımlar

```bash
# 1. Repo'yu klonlayın
git clone <repository-url>
cd NoteBook

# 2. Bağımlılıkları yükleyin
flutter pub get

# 3. Firebase yapılandırması
flutterfire configure

# 4. Lokalizasyon dosyalarını üretin
flutter gen-l10n

# 5. Uygulamayı çalıştırın
flutter run
```

---

## 📁 Proje Yapısı / Project Structure

```
NoteBook/
├── android/                    # Android platform kodu
├── ios/                        # iOS platform kodu
├── windows/                    # Windows platform kodu
├── lib/
│   ├── main.dart               # Giriş noktası
│   └── src/
│       ├── app/                # Uygulama katmanı
│       ├── core/               # Paylaşılan altyapı
│       └── features/           # Özellik modülleri
├── commands/                   # Geliştirme komut dosyaları
├── assets/                     # Statik varlıklar
├── pubspec.yaml                # Bağımlılıklar
└── README.md                   # Bu dosya
```

---

## 📜 Komutlar / Commands

| Komut | Açıklama |
|-------|----------|
| `flutter run` | Uygulamayı çalıştır |
| `flutter analyze` | Kod analizi |
| `flutter test` | Testleri çalıştır |
| `flutter gen-l10n` | Lokalizasyon üret |
| `flutter pub run build_runner build` | Riverpod code gen |
| `flutter pub run flutter_launcher_icons` | Uygulama ikonu üret |

---

## 🎯 Geliştirme Yol Haritası / Roadmap

- [x] Temel uygulama altyapısı
- [x] Firebase entegrasyonu
- [x] Medya arşivi özelliği
- [x] Hedef takip sistemi
- [x] Planlayıcı modülü
- [x] Çoklu dil desteği
- [x] Tema yönetimi
- [x] Animasyon sistemi
- [x] Bildirim sistemi
- [x] Bağlantı yönetimi
- [x] Hata yönetimi UI
- [ ] Push notification (Firebase Cloud Messaging)
- [ ] Sosyal paylaşım
- [ ] Veri yedekleme/geri yükleme
- [ ] Widget desteği (Android/iOS)

---

## 📄 Lisans / License

Bu proje özel kullanım içindir.

---

<p align="center">
  Made with ❤️ using Flutter
</p>
