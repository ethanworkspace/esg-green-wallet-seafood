import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../shared/widgets/bottom_nav_shell.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/scan/presentation/screens/scan_screen.dart';
import '../../features/seafood/presentation/screens/seafood_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/dashboard',
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => BottomNavShell(child: child),
      routes: [
        GoRoute(
          path: '/dashboard',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: DashboardScreen(),
          ),
        ),
        GoRoute(
          path: '/scan',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: ScanScreen(),
          ),
        ),
        GoRoute(
          path: '/seafood',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: SeafoodScreen(),
          ),
        ),
      ],
    ),
  ],
);
