import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:animations/animations.dart';

import 'package:not_defterim/src/features/auth/presentation/providers/auth_provider.dart';
import 'package:not_defterim/src/features/auth/presentation/screens/splash_screen.dart';
import 'package:not_defterim/src/features/auth/presentation/screens/login_screen.dart';
import 'package:not_defterim/src/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:not_defterim/src/app/l10n/app_localizations.dart';
import 'package:not_defterim/src/features/media/presentation/screens/media_screen.dart';
import 'package:not_defterim/src/features/media/presentation/screens/add_media_screen.dart';
import 'package:not_defterim/src/features/media/presentation/screens/media_detail_screen.dart';
import 'package:not_defterim/src/features/goals/presentation/screens/goals_screen.dart';
import 'package:not_defterim/src/features/goals/presentation/screens/add_goal_screen.dart';
import 'package:not_defterim/src/features/goals/presentation/screens/goal_detail_screen.dart';
import 'package:not_defterim/src/features/planner/presentation/screens/planner_screen.dart';
import 'package:not_defterim/src/features/planner/domain/planned_item.dart';
import 'package:not_defterim/src/features/planner/presentation/screens/add_plan_screen.dart';
import 'package:not_defterim/src/features/settings/presentation/screens/settings_screen.dart';
import 'package:not_defterim/src/app/route_error_screen.dart';

/// Application route paths.
class AppRoutes {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String dashboard = '/';
  static const String media = '/media';
  static const String goals = '/goals';
  static const String planner = '/planner';
  static const String settings = '/settings';
}

/// Shell widget that provides the bottom navigation bar.
class MainShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainShell({
    super.key,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      body: PageTransitionSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation, secondaryAnimation) {
          return FadeThroughTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            child: child,
          );
        },
        child: navigationShell,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(20),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: (index) {
            navigationShell.goBranch(
              index,
              initialLocation: index == navigationShell.currentIndex,
            );
          },
          height: 70,
          elevation: 0,
          backgroundColor: theme.colorScheme.surface,
          indicatorColor: theme.colorScheme.primaryContainer,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.grid_view_rounded),
              selectedIcon: Icon(Icons.grid_view_rounded),
              label: AppLocalizations.of(context)!.dashboardTitle,
            ),
            NavigationDestination(
              icon: Icon(Icons.inventory_2_rounded),
              selectedIcon: Icon(Icons.inventory_2_rounded),
              label: AppLocalizations.of(context)!.mediaTitle,
            ),
            NavigationDestination(
              icon: Icon(Icons.stars_rounded),
              selectedIcon: Icon(Icons.stars_rounded),
              label: AppLocalizations.of(context)!.goalsTitle,
            ),
            NavigationDestination(
              icon: Icon(Icons.event_note_rounded),
              selectedIcon: Icon(Icons.event_note_rounded),
              label: AppLocalizations.of(context)!.plannerTitle,
            ),
            NavigationDestination(
              icon: Icon(Icons.tune_rounded),
              selectedIcon: Icon(Icons.tune_rounded),
              label: AppLocalizations.of(context)!.settingsTitle,
            ),
          ],
        ),
      ),
    );
  }
}

/// Provider for the app router with auth-gated navigation.
final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: _RouterRefreshNotifier(ref),
    errorBuilder: (context, state) => RouteErrorScreen(error: state.error),
    redirect: (context, state) {
      final isLoading = authState.isLoading;
      final user = authState.valueOrNull;
      final isLoggedIn = user != null;

      final isOnSplash = state.matchedLocation == AppRoutes.splash;
      final isOnLogin = state.matchedLocation == AppRoutes.login;

      // Still loading - stay on splash
      if (isLoading) {
        return isOnSplash ? null : AppRoutes.splash;
      }

      // Not logged in - go to login
      if (!isLoggedIn) {
        return isOnLogin ? null : AppRoutes.login;
      }

      // Logged in but on splash/login - go to dashboard
      if (isOnSplash || isOnLogin) {
        return AppRoutes.dashboard;
      }

      // No redirect needed
      return null;
    },
    routes: [
      // Splash route
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      // Login route
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      // Main app shell with tabs
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShell(navigationShell: navigationShell);
        },
        branches: [
          // Dashboard tab
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.dashboard,
                builder: (context, state) => const DashboardScreen(),
              ),
            ],
          ),
          // Media tab
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.media,
                builder: (context, state) => const MediaScreen(),
                routes: [
                  GoRoute(
                    path: 'add',
                    pageBuilder: (context, state) => _buildPageWithSharedAxisTransition(
                      context: context,
                      state: state,
                      child: const AddMediaScreen(),
                      type: SharedAxisTransitionType.scaled,
                    ),
                  ),
                  GoRoute(
                    path: ':id',
                    pageBuilder: (context, state) {
                      final id = state.pathParameters['id']!;
                      return _buildPageWithSharedAxisTransition(
                        context: context,
                        state: state,
                        child: MediaDetailScreen(mediaId: id),
                        type: SharedAxisTransitionType.horizontal,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          // Goals tab
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.goals,
                builder: (context, state) => const GoalsScreen(),
                routes: [
                  GoRoute(
                    path: 'add',
                    pageBuilder: (context, state) => _buildPageWithSharedAxisTransition(
                      context: context,
                      state: state,
                      child: const AddGoalScreen(),
                      type: SharedAxisTransitionType.scaled,
                    ),
                  ),
                  GoRoute(
                    path: ':id',
                    pageBuilder: (context, state) {
                      final id = state.pathParameters['id']!;
                      return _buildPageWithSharedAxisTransition(
                        context: context,
                        state: state,
                        child: GoalDetailScreen(goalId: id),
                        type: SharedAxisTransitionType.horizontal,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          // Planner tab
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.planner,
                builder: (context, state) => const PlannerScreen(),
                routes: [
                  GoRoute(
                    path: 'add',
                    pageBuilder: (context, state) {
                      final plan = state.extra as PlannedItem?;
                      return _buildPageWithSharedAxisTransition(
                        context: context,
                        state: state,
                        child: AddPlanScreen(initialPlan: plan),
                        type: SharedAxisTransitionType.scaled,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          // Settings tab
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.settings,
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});

/// Notifier that triggers router refresh when auth state changes.
class _RouterRefreshNotifier extends ChangeNotifier {
  _RouterRefreshNotifier(Ref ref) {
    ref.listen(authStateProvider, (_, __) {
      notifyListeners();
    });
  }
}

Page<dynamic> _buildPageWithSharedAxisTransition({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
  SharedAxisTransitionType type = SharedAxisTransitionType.horizontal,
}) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SharedAxisTransition(
        animation: animation,
        secondaryAnimation: secondaryAnimation,
        transitionType: type,
        child: child,
      );
    },
  );
}
