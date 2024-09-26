import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:posts_app/view/home_screen.dart';

class splashScreen extends StatefulWidget {
  const splashScreen({super.key});

  @override
  State<splashScreen> createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 4), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => PostListScreen(),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('assets/logo.json'),
            const Text(
              'postaty',
              style: TextStyle(
                  color: Color.fromARGB(255, 202, 68, 255), fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
