import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Text("Profile Page")),
          ElevatedButton(
            onPressed: () {
              GoRouter.of(context).go("/");
            },
            child: Text("Go To Home"),
          ),

          ElevatedButton(
            onPressed: () {
              GoRouter.of(context).go("/profile/child");
            },
            child: Text("Go to Child Sub Page"),
          ),
        ],
      ),
    );
  }
}
