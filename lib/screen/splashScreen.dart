import 'dart:async';
import 'package:flutter/material.dart';
import 'package:todo_with_fb/screen/loginScreen.dart';

class SplashScreenView extends StatefulWidget {
  const SplashScreenView({super.key});

  @override
  State<SplashScreenView> createState() => _SplashScreenViewState();
}

class _SplashScreenViewState extends State<SplashScreenView> {
  @override
  void initState() {
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginscreenView()),
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Image.asset(
                "assets/images/todoSplash.png",
                height: 300,
                width: 250,
              ),
              const Text(
                "TODO",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 28,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              const Text(
                "Make Every Minute Count",
                style: TextStyle(fontSize: 14),
              ),
              const Text(
                "Your Goals, Your Way, Every Day",
                style: TextStyle(fontSize: 14),
              )
            ],
          ),
        ),
      ),
    );
  }
}
