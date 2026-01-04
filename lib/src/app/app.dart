import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'router.dart';
import 'theme.dart';
import '../features/settings/presentation/providers/theme_provider.dart';
import '../features/settings/presentation/providers/language_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import '../core/presentation/widgets/connectivity_wrapper.dart';

/// Main application widget.
/// 
/// Uses MaterialApp.router with go_router and Material 3 theming.
class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final language = ref.watch(languageProvider);
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'Not Defterim',
      debugShowCheckedModeBanner: false,
      
      // Theme configuration
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      
      // Router configuration
      routerConfig: router,

      // Localization
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: language.code != null ? Locale(language.code!) : null,
      builder: (context, child) {
        return ConnectivityWrapper(child: child);
      },
    );
  }
}
