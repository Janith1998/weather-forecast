import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gorouter/locator.dart';
import 'package:gorouter/router/router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gorouter/services/theme_service.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  setupLocator();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => getIt<ThemeService>())],
      child: Consumer<ThemeService>(
        builder: (context, themeService, child) {
          return StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, authSnapshot) {
              return MaterialApp.router(
                routerConfig: RouterClass(authState: authSnapshot.data).router,
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                  colorScheme: ColorScheme.light(
                    primary: Colors.blue,
                    secondary: Colors.blueAccent,
                  ),
                  scaffoldBackgroundColor: Colors.white,
                  cardColor: Colors.grey[50],
                  appBarTheme: const AppBarTheme(
                    elevation: 0,
                    backgroundColor: Colors.white,
                    iconTheme: IconThemeData(color: Colors.black87),
                    titleTextStyle: TextStyle(
                      color: Colors.black87,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                darkTheme: ThemeData(
                  colorScheme: ColorScheme.dark(
                    primary: Colors.blue,
                    secondary: Colors.blueAccent,
                  ),
                  scaffoldBackgroundColor: const Color(0xFF121212),
                  cardColor: const Color(0xFF1E1E1E),
                  appBarTheme: const AppBarTheme(
                    elevation: 0,
                    backgroundColor: Color(0xFF121212),
                    iconTheme: IconThemeData(color: Colors.white),
                    titleTextStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                themeMode: themeService.currentTheme,
              );
            },
          );
        },
      ),
    );
  }
}
