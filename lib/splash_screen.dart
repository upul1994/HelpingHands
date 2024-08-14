import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:project/screens/Authentication/widget_tree.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Lottie.asset('assets/welcome.json'),  
      nextScreen: const WidgetTree(),     
      splashIconSize: 250,
      duration: 3000,
      splashTransition: SplashTransition.fadeTransition,
    );
  }
}
