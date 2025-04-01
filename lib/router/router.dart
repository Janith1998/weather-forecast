import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gorouter/pages/child_page.dart';
import 'package:gorouter/pages/home_page.dart';
import 'package:gorouter/pages/login_page.dart';
import 'package:gorouter/pages/profile_page.dart';
import 'package:gorouter/pages/register_page.dart';
import 'package:gorouter/pages/splash_screen.dart';
import 'package:gorouter/pages/starter_page.dart';

class RouterClass {
  final router = GoRouter(
    initialLocation: "/home",
    debugLogDiagnostics: true,
    errorPageBuilder: (context, state) {
      return const MaterialPage<dynamic>(
        child: Scaffold(body: Center(child: Text("This page is not Found"))),
      );
    },
    routes: [
      GoRoute(
        path: "/",
        name: "splash",
        builder: (context, state) {
          return const SplashScreen();
        },
      ),

      GoRoute(
        path: "/start",
        name: "start",
        builder: (context, state) {
          return StarterPage();
        },
      ),

      GoRoute(
        path: "/login",
        name: "login",
        builder: (context, state) {
          return LoginPage();
        },
        routes: [
          GoRoute(
            path: "register",
            name: "register",
            builder: (context, state) {
              return const RegisterPage();
            },
          ),
        ],
      ),

      GoRoute(
        path: "/home",
        name: "home",
        builder: (context, state) {
          return const Homepage();
        },
      ),

      GoRoute(
        path: "/profile",
        name: "profile",
        builder: (context, state) {
          return const ProfilePage();
        },
        routes: [
          GoRoute(
            path: "child",
            name: "child",
            builder: (context, state) {
              return const ChildPage();
            },
          ),
        ],
      ),
    ],
  );
}
