import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gorouter/router/router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(4.seconds);
    RouterClass.completeSplash();
    if (mounted) {
      context.go('/'); // Trigger redirect
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 13, 1, 48),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RichText(
                  text: const TextSpan(
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Elegant ',
                        style: TextStyle(color: Colors.white),
                      ),
                      TextSpan(
                        text: 'Media',
                        style: TextStyle(
                          color: Color.fromARGB(255, 2, 182, 14),
                        ),
                      ),
                    ],
                  ),
                )
                .animate()
                .fadeIn(duration: 500.ms)
                .slideY(begin: 0.5, end: 0, duration: 500.ms)
                .then(delay: 200.ms)
                .scaleXY(begin: 0.7, end: 1.1, duration: 300.ms)
                .then()
                .scaleXY(end: 1.1, duration: 300.ms),
          ],
        ),
      ),
    );
  }
}
