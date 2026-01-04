import 'package:flutter/material.dart';

/// Splash screen shown on app startup while checking auth state.
///
/// The router handles redirecting to login or home based on auth.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App icon
            Icon(
              Icons.book,
              size: 80,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 24),
            // App name
            Text(
              'Not Defterim',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 48),
            // Loading indicator
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
