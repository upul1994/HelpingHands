import 'package:project/screens/Authentication/auth.dart';
import 'package:project/screens/Authentication/home_page.dart';
import 'package:project/screens/Authentication/login_register_page.dart';
import 'package:project/screens/Authentication/email_verification_page.dart';
import 'package:flutter/material.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({Key? key}) : super(key: key);

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Auth().authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.providerData
                    .any((provider) => provider.providerId == 'google.com') ||
                snapshot.data!.emailVerified) {
              // If signed in with Google or email verified, go to HomePage
              return HomePage();
            } else if (!snapshot.data!.emailVerified) {
              // If the email is not verified and the user did not sign in with Google, go to EmailVerificationPage
              return const EmailVerificationPage();
            } else {
              return HomePage();
            }
          } else {
            return const LoginPage();
          }
        });
  }
}
