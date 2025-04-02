import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gorouter/pages/home_page.dart';
import 'package:gorouter/pages/login_page.dart';
import 'package:gorouter/pages/profile_page.dart';
import 'package:gorouter/pages/register_page.dart';
import 'package:gorouter/pages/splash_screen.dart';
import 'package:gorouter/pages/starter_page.dart';
import 'package:gorouter/services/app_state.dart';

class RouterClass {
  final User? authState;
  static bool splashCompleted = false;

  RouterClass({this.authState});

  late final router = GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    redirect: (context, state) async {
      // 1. Always show splash first
      if (!splashCompleted && state.uri.path != '/') {
        debugPrint('Redirect: Showing splash first');
        return '/';
      }

      // 2. Get all required states
      // final isLoggedIn = FirebaseAuth.instance.currentUser != null;
      final isLoggedIn = authState != null;
      final isFirstLaunch = await AppState.isFirstLaunch;
      final isAtSplash = state.uri.path == '/';
      final isAtStart = state.uri.path == '/start';
      final isAtAuth =
          state.uri.path.startsWith('/login') ||
          state.uri.path.startsWith('/register');

      debugPrint('--- REDIRECT CHECK ---');
      debugPrint('isLoggedIn: $isLoggedIn');
      debugPrint('isFirstLaunch: $isFirstLaunch');
      debugPrint('currentPath: ${state.uri.path}');

      // 3. Only process redirects after splash completes
      if (splashCompleted) {
        // First launch flow - should have isLoggedIn = false
        if (isFirstLaunch && !isAtStart) {
          debugPrint('Redirect: First launch -> Start page');
          return '/start';
        }

        // Auth flow
        if (isLoggedIn) {
          if (isAtSplash || isAtStart || isAtAuth) {
            debugPrint('Redirect: Logged in -> Home');
            return '/home';
          }
        } else {
          if (!isAtAuth && !isAtStart) {
            debugPrint('Redirect: Not logged in -> Login');
            return '/login';
          }
        }
      }

      debugPrint('No redirect needed');
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        name: 'splash',
        pageBuilder:
            (context, state) =>
                MaterialPage(key: state.pageKey, child: const SplashScreen()),
      ),
      GoRoute(
        path: '/start',
        name: 'start',
        pageBuilder:
            (context, state) =>
                MaterialPage(key: state.pageKey, child: const StarterPage()),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        pageBuilder:
            (context, state) =>
                MaterialPage(key: state.pageKey, child: const LoginPage()),
        routes: [
          GoRoute(
            path: 'register',
            name: 'register',
            pageBuilder:
                (context, state) => MaterialPage(
                  key: state.pageKey,
                  child: const RegisterPage(),
                ),
          ),
        ],
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        pageBuilder:
            (context, state) =>
                MaterialPage(key: state.pageKey, child: const Homepage()),
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        pageBuilder:
            (context, state) =>
                MaterialPage(key: state.pageKey, child: const ProfilePage()),
      ),
    ],
  );

  static void completeSplash() {
    splashCompleted = true;
  }
}
