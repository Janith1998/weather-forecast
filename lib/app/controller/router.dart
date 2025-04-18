import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:gorouter/app/app.dart';
import 'package:gorouter/auth/auth.dart';
import 'package:gorouter/home/home.dart';

// class RouterClass {
//   final User? authState;
//   static bool splashCompleted = false;

//   RouterClass({this.authState});

//   late final router = GoRouter(
//     initialLocation: '/',
//     debugLogDiagnostics: true,
//     redirect: (context, state) async {
//       if (!splashCompleted && state.uri.path != '/') {
//         debugPrint('Redirect: Showing splash first');
//         return '/';
//       }

//       final isLoggedIn = authState != null;
//       final isFirstLaunch = await AppState.isFirstLaunch;
//       final isAtSplash = state.uri.path == '/';
//       final isAtStart = state.uri.path == '/start';
//       final isAtAuth =
//           state.uri.path.startsWith('/login') ||
//           state.uri.path.startsWith('/register');

//       debugPrint('REDIRECT CHECK');
//       debugPrint('isLoggedIn: $isLoggedIn');
//       debugPrint('isFirstLaunch: $isFirstLaunch');
//       debugPrint('currentPath: ${state.uri.path}');

//       if (splashCompleted) {
//         if (isFirstLaunch && !isAtStart) {
//           debugPrint('Redirect: First launch -> Start page');
//           return '/start';
//         }

//         if (isLoggedIn) {
//           if (isAtSplash || isAtStart || isAtAuth) {
//             debugPrint('Redirect: Logged in -> Home');
//             return '/home';
//           }
//         } else {
//           if (!isAtAuth && !isAtStart) {
//             debugPrint('Redirect: Not logged in -> Login');
//             return '/login';
//           }
//         }
//       }

//       debugPrint('No redirect needed');
//       return null;
//     },
//     routes: [
//       GoRoute(
//         path: '/',
//         name: 'splash',
//         pageBuilder:
//             (context, state) =>
//                 MaterialPage(key: state.pageKey, child: const SplashScreen()),
//       ),
//       GoRoute(
//         path: '/start',
//         name: 'start',
//         pageBuilder:
//             (context, state) =>
//                 MaterialPage(key: state.pageKey, child: const StarterPage()),
//       ),
//       GoRoute(
//         path: '/login',
//         name: 'login',
//         pageBuilder:
//             (context, state) =>
//                 MaterialPage(key: state.pageKey, child: const LoginPage()),
//         routes: [
//           GoRoute(
//             path: 'register',
//             name: 'register',
//             pageBuilder:
//                 (context, state) => MaterialPage(
//                   key: state.pageKey,
//                   child: const RegisterPage(),
//                 ),
//           ),
//         ],
//       ),
//       GoRoute(
//         path: '/home',
//         name: 'home',
//         pageBuilder:
//             (context, state) =>
//                 MaterialPage(key: state.pageKey, child: const Homepage()),
//       ),
//     ],
//   );

//   static void completeSplash() {
//     splashCompleted = true;
//   }
// }

class RouterClass {
  final User? authState;
  static bool splashCompleted = false;

  RouterClass({this.authState});

  late final router = GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    redirect: (context, state) async {
      // 1. Always show splash first if not completed
      if (!splashCompleted && state.uri.path != '/') {
        return '/';
      }

      final isLoggedIn = authState != null;
      final isFirstLaunch = await AppState.isFirstLaunch;
      final currentPath = state.uri.path;

      debugPrint('REDIRECT CHECK');
      debugPrint('isLoggedIn: $isLoggedIn');
      debugPrint('isFirstLaunch: $isFirstLaunch');
      debugPrint('currentPath: $currentPath');

      // Only process redirects after splash is completed
      if (splashCompleted) {
        // Case 1: User is logged in (skip all onboarding)
        if (isLoggedIn) {
          if (currentPath != '/home') {
            debugPrint('Redirect: Logged in user to home');
            return '/home';
          }
          return null;
        }
        // Case 2: User is not logged in
        else {
          // First time users should see start screen
          if (isFirstLaunch && currentPath != '/start') {
            debugPrint('Redirect: First launch to start');
            return '/start';
          }
          // Returning users should go to login
          else if (!isFirstLaunch && !currentPath.startsWith('/login')) {
            debugPrint('Redirect: Returning user to login');
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
    ],
  );

  static void completeSplash() {
    splashCompleted = true;
  }
}
