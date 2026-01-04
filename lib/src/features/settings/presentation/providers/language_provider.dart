import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme_provider.dart';

const String _languageKey = 'app_language';

/// Enum representing supported languages.
enum AppLanguage {
  system(null, 'System'),
  turkish('tr', 'Türkçe'),
  english('en', 'English');

  final String? code;
  final String displayName;
  const AppLanguage(this.code, this.displayName);
}

/// Notifier that manages the app's language/locale.
class LanguageNotifier extends StateNotifier<AppLanguage> {
  final SharedPreferences _prefs;

  LanguageNotifier(this._prefs) : super(_loadInitialLanguage(_prefs));

  static AppLanguage _loadInitialLanguage(SharedPreferences prefs) {
    final savedCode = prefs.getString(_languageKey);
    return AppLanguage.values.firstWhere(
      (lang) => lang.code == savedCode,
      orElse: () => AppLanguage.system,
    );
  }

  Future<void> setLanguage(AppLanguage language) async {
    state = language;
    if (language.code == null) {
      await _prefs.remove(_languageKey);
    } else {
      await _prefs.setString(_languageKey, language.code!);
    }
  }

  Locale? get locale {
    if (state.code == null) return null;
    return Locale(state.code!);
  }
}

/// Provider for the current language.
final languageProvider = StateNotifierProvider<LanguageNotifier, AppLanguage>(
  (ref) {
    final prefs = ref.watch(sharedPreferencesProvider);
    return LanguageNotifier(prefs);
  },
);
