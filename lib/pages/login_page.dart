import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gorouter/locator.dart';
import 'package:gorouter/services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;
  final AuthService authService = getIt<AuthService>();

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      await authService.login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      Fluttertoast.showToast(
        msg: "Login successful!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );

      if (mounted) {
        GoRouter.of(context).go('/home');
      }
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(
        msg: "An error occurred. Please try again.",
        toastLength: Toast.LENGTH_SHORT,
      );
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 500.0),
                  child: ClipPath(
                    clipper: BottomWaveClipper(),
                    child: Container(
                      color: const Color.fromARGB(255, 5, 0, 76),
                      width: double.infinity,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Login Form
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(top: 150.0),
              child: Column(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Login',
                              style: TextStyle(
                                color: Color.fromARGB(255, 252, 149, 24),
                                fontSize: 44,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 100),

                            // Email Field
                            TextFormField(
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                prefixIcon: Icon(Icons.email),
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                if (!RegExp(
                                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                ).hasMatch(value)) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 35),

                            TextFormField(
                              controller: passwordController,
                              obscureText: true,
                              decoration: const InputDecoration(
                                labelText: 'Password',
                                prefixIcon: Icon(Icons.lock),
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),

                            Padding(
                              padding: const EdgeInsets.only(top: 30),
                              child: SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: isLoading ? null : login,
                                  child:
                                      isLoading
                                          ? const CircularProgressIndicator(
                                            color: Colors.white,
                                          )
                                          : const Text('Sign In'),
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(0, 55),
                                    textStyle: const TextStyle(
                                      fontWeight: FontWeight.w900,
                                    ),
                                    backgroundColor: const Color.fromARGB(
                                      255,
                                      31,
                                      31,
                                      79,
                                    ),
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                              ),
                            ),

                            TextButton(
                              onPressed: () {
                                GoRouter.of(context).go('/login/register');
                              },
                              child: const Text(
                                'Create an account',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 252, 149, 24),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(
      size.width / 4,
      size.height - 80,
      size.width / 2,
      size.height - 50,
    );
    path.quadraticBezierTo(
      size.width * 3 / 4,
      size.height - 20,
      size.width,
      size.height - 50,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
