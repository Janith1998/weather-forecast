import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ChildPage extends StatelessWidget {
  const ChildPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: const Text("Child Page")),
          ElevatedButton(
            onPressed: () {
              GoRouter.of(context).go("/profile");
            },
            child: Text("Go to Profile page"),
          ),
        ],
      ),
    );
  }
}
