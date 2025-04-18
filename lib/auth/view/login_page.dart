import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gorouter/locator.dart';

import '../auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController emailController;
  late TextEditingController passwordController; // = TextEditingController();
  bool isLoading = false;
  final AuthService authService = getIt<AuthService>();
  final EmailService emailService = getIt<EmailService>();

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      await authService.login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      // Save the email for future use
      emailService.updateEmail(emailController.text.trim());

      Fluttertoast.showToast(
        msg: "Login successful!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );

      if (mounted) {
        GoRouter.of(context).go('/home');
      }
    } on FirebaseAuthException {
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
  void initState() {
    super.initState();
    log('LoginPage initState');
    emailController = TextEditingController();
    passwordController = TextEditingController();

    // // Initialize EmailService and listen to email stream
    // emailService.init().then((_) {
    //   // Listen to changes in email stream and update the controller
    //   emailService.emailStream.listen((email) {
    //     emailController.text = email; // Update the text field with the email
    //   });
    // });
    // Get the latest email just once instead of listening
    final lastEmail = emailService.currentEmail;
    emailController.text = lastEmail;
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    //emailService.dispose();
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
          AbsorbPointer(
            absorbing: isLoading,
            child: Center(
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
                                    // ignore: sort_child_properties_last
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
          ),
        ],
      ),
    );
  }
}
