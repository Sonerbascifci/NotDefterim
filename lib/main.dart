import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'src/app/app.dart';
import 'src/features/settings/presentation/providers/theme_provider.dart';
import 'src/core/services/notification_service.dart';

/// Main entry point for Not Defterim application.
/// 
/// Initializes Firebase and SharedPreferences, then wraps the app in ProviderScope.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  // Note: Run 'flutterfire configure' to generate firebase_options.dart
  // For now, we'll initialize with default options or skip if not configured
  try {
    await Firebase.initializeApp();
  } catch (e) {
    // Firebase not configured yet - will be set up in next milestone
    debugPrint('Firebase initialization skipped: $e');
  }
  
  // Initialize SharedPreferences for theme persistence
  final sharedPreferences = await SharedPreferences.getInstance();

  // Initialize date formatting for Turkish locale
  await initializeDateFormatting('tr_TR', null);

  // Initialize Notification Service
  await NotificationService().init();
  
  runApp(
    ProviderScope(
      overrides: [
        // Override the SharedPreferences provider with the initialized instance
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: const App(),
    ),
  );
}

