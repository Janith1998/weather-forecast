import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class StarterPage extends StatefulWidget {
  const StarterPage({super.key});

  @override
  State<StarterPage> createState() => _StarterPageState();
}

class _StarterPageState extends State<StarterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              ClipPath(
                clipper: BottomCurveClipper(),
                child: Image.asset(
                  'assets/images/imgStart.jpg',
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),

              ElevatedButton(
                onPressed: () {
                  GoRouter.of(context).go('/login');
                },
                child: Text("Lets go ->"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BottomCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 30);
    path.quadraticBezierTo(
      size.width / 3,
      size.height + 30, // Control point weighted to left
      size.width,
      size.height - 100, // Right side ends higher
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
