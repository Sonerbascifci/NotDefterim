# commands/50_planner_notifications.md
## Goal
Planlama özelliğine yerel bildirim (local notification) desteği eklemek. Kullanıcı bir plan oluşturduğunda, plan saatinde cihazına hatırlatıcı bildirim göndermek.

## Decisions
- **Package:** `flutter_local_notifications` + `timezone` (cross-platform, robust, well-supported)
- **Trigger:** Her plan kaydedildiğinde veya güncellendiğinde, o planın tarih/saatine göre bildirim schedule edilecek
- **Recurring Plans:** Haftalık tekrarlayan planlar için seçilen günlere ayrı ayrı bildirim schedule edilecek
- **Cancel Logic:** Plan silindiğinde ilgili bildirimler iptal edilecek
- **Unique ID Strategy:** planId'den hashCode ile benzersiz int id türetilecek
- **Platform Config:**
  - Android: `AndroidManifest.xml` -> permissions, boot receiver
  - iOS: `AppDelegate.swift` -> notification delegate
  - Windows: Destekleniyor (flutter_local_notifications >= 9.0)

## Steps

### 1) Dependencies
```yaml
# pubspec.yaml
dependencies:
  flutter_local_notifications: ^19.0.0
  timezone: ^0.10.0
  flutter_timezone: ^3.0.1
```

### 2) Platform Configuration - Android
**File:** `android/app/src/main/AndroidManifest.xml`
```xml
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED" />
<uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM" />
<uses-permission android:name="android.permission.USE_EXACT_ALARM" />

<receiver android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver"
    android:exported="false">
    <intent-filter>
        <action android:name="android.intent.action.BOOT_COMPLETED" />
    </intent-filter>
</receiver>
<receiver android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationReceiver"
    android:exported="false"/>
```

### 3) Platform Configuration - iOS
**File:** `ios/Runner/AppDelegate.swift`
```swift
import flutter_local_notifications

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
      GeneratedPluginRegistrant.register(with: registry)
    }

    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```

### 4) Notification Service
**File:** `lib/src/core/services/notification_service.dart`
- Singleton pattern
- `init()`: Platform init + timezone init + permission request
- `scheduleNotification(int id, String title, String body, DateTime scheduledTime)`
- `cancelNotification(int id)`
- `cancelAllNotifications()`

### 5) Timezone Initialization
**File:** `lib/main.dart`
- `tz.initializeTimeZones()` on app start
- Get device timezone via `flutter_timezone`

### 6) Provider Integration
**File:** `lib/src/features/planner/presentation/providers/planner_provider.dart`
- `upsertPlan()` sonrasında:
  - Eski bildirimi iptal et
  - Yeni bildirimi schedule et
- `deletePlan()` sonrasında:
  - Bildirimi iptal et

### 7) Notification ID Generation
```dart
int getNotificationId(String planId, [DateTime? date]) {
  if (date == null) return planId.hashCode.abs();
  return '${planId}_${date.toIso8601String()}'.hashCode.abs();
}
```

### 8) Settings Screen Toggle (Optional - Phase 2)
- "Bildirimler Aktif" switch
- shared_preferences ile persist

## Files to create/update
- + `lib/src/core/services/notification_service.dart`
- * `lib/main.dart` (timezone init)
- * `lib/src/features/planner/presentation/providers/planner_provider.dart`
- * `android/app/src/main/AndroidManifest.xml`
- * `ios/Runner/AppDelegate.swift`
- * `pubspec.yaml`

## Acceptance Checklist
- [ ] Plan eklendiğinde bildirim schedule ediliyor
- [ ] Plan silindiğinde bildirim iptal ediliyor
- [ ] Bildirim, planın tarih/saatinde geliyor
- [ ] Android 13+ cihazlarda izin dialog gösteriliyor
- [ ] Uygulama kapalıyken de bildirim geliyor
- [ ] `flutter analyze` temiz

## Commands
- Analyze: `flutter analyze`
- Test: Manual - Plan oluştur, bekleme zamanı (1-2 dk sonrası) ayarla, bildirimi bekle
