import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/screens/Authentication/home_page.dart';

class EmailVerificationPage extends StatefulWidget {
  const EmailVerificationPage({Key? key}) : super(key: key);
  @override
  EmailVerificationPageState createState() => EmailVerificationPageState();
}

class EmailVerificationPageState extends State<EmailVerificationPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User? _user;
  final bool _isVerificationEmailSent = false;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Email Verification",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Please verify your email to proceed.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20.0),
              ),
              const SizedBox(height: 20),
              if (_isVerificationEmailSent)
                const Text(
                  "Verification email sent! Check your inbox and click on the verification link.",
                  style: TextStyle(color: Colors.green),
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await _user?.reload(); // Refresh user data
                  _user = _auth
                      .currentUser; // Fetch the user again to get the latest status

                  if (_user?.emailVerified == true) {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => HomePage()));
                  } else {
                    const snackBar = SnackBar(
                        content: Text(
                            'Email is not yet verified! Please check your inbox and verify.'));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
                child: const Text("I have verified my email!"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
