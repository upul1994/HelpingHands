import 'package:firebase_auth/firebase_auth.dart';
import 'package:project/screens/Authentication/auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:project/screens/Authentication/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  String? errorMessage = '';
  String? successMessage = '';
  bool isLogin = true;
  bool _passwordVisible = false;
  bool isLoading = false;

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  late final AnimationController _controllerAnimation;
  final _formKey = GlobalKey<FormState>();
  final GoogleSignIn googleSignIn = GoogleSignIn();

  final String _backgroundImage = 'assets/background.png';

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;

    _controllerAnimation = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
  }

  @override
  dispose() {
    _controllerAnimation.dispose();
    super.dispose();
  }

  bool loginAnimation = false;

  Future<void> signInWithEmailAndPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      try {
        await Auth().signInWithEmailAndPassword(
          email: _controllerEmail.text,
          password: _controllerPassword.text,
        );

        if (!(await Auth().isEmailVerified())) {
          throw FirebaseAuthException(
            message: 'Please verify your email before signing in.',
            code: 'email-not-verified',
          );
        }

        // If email is verified, navigate to HomePage
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomePage()),
        );

        if (loginAnimation == false) {
          _controllerAnimation.forward();
          loginAnimation = true;
        } else {
          _controllerAnimation.reverse();
          loginAnimation = false;
        }
      } on FirebaseAuthException catch (e) {
        setState(() {
          isLoading = false;
          print(e.message);
          errorMessage = "Email or password is incorrect.";
        });
        return;
      }

      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      try {
        await Auth().createUserWithEmailAndPassword(
          email: _controllerEmail.text,
          password: _controllerPassword.text,
        );

        await Auth()
            .sendEmailVerification(); // Sending verification email after user creation

        setState(() {
          isLoading = false;
          successMessage = 'Registration successful! Please verify your email.';
        });
      } on FirebaseAuthException catch (e) {
        setState(() {
          isLoading = false;
          errorMessage = e.message;
        });
      }
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        // User canceled the sign-in process
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // Check if the sign-in was successful
      if (userCredential.user != null && mounted) {
        // Navigate to the home page after successful sign-in
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      }
    } catch (e) {
      setState(() {
        errorMessage = "Could not sign in with Google! Please try again.";
      });
    }
  }

  Widget _title() {
    return const Text(
      'Helping Hands',
      style: TextStyle(
          color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
    );
  }

  Widget _entryField(String title, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: title,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.blue),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter an email';
        } else if (!RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(value)) {
          return 'Please enter a valid email';
        }
        return null;
      },
    );
  }

  Widget _passwordEntryField(TextEditingController controller) {
    return TextFormField(
      keyboardType: TextInputType.text,
      controller: controller,
      obscureText: !_passwordVisible,
      decoration: InputDecoration(
        labelText: 'Password',
        hintText: 'Enter your password',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.blue),
        ),
        filled: true,
        fillColor: Colors.white,
        suffixIcon: IconButton(
          icon: Icon(
            _passwordVisible ? Icons.visibility : Icons.visibility_off,
            color: Theme.of(context).primaryColorDark,
          ),
          onPressed: () {
            setState(() {
              _passwordVisible = !_passwordVisible;
            });
          },
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a password';
        }

        if (!isLogin) {
          if (value.length < 8) {
            return 'Password should be at least 8 characters';
          } else if (!RegExp(r'(?=.*[A-Z])').hasMatch(value)) {
            return 'Password should have at least one uppercase letter';
          } else if (!RegExp(r'(?=.*[a-z])').hasMatch(value)) {
            return 'Password should have at least one lowercase letter';
          } else if (!RegExp(r'(?=.*\d)').hasMatch(value)) {
            return 'Password should have at least one number';
          } else if (!RegExp(r'(?=.*[!@#$%^&*()\-_=+{};:,.<>?~])')
              .hasMatch(value)) {
            return 'Password should have at least one special character';
          } else if (RegExp(r'\s').hasMatch(value)) {
            return 'Password should not contain spaces';
          }
          return null;
        }
        return null;
      },
    );
  }

  Widget _errorMessage() {
    return Text(
      errorMessage == '' ? '' : 'Error : $errorMessage',
      style: const TextStyle(color: Colors.red),
    );
  }

  Widget _successMessage() {
    return Text(
      successMessage == null || successMessage!.isEmpty
          ? ''
          : 'Success : $successMessage',
      style: const TextStyle(color: Colors.green),
    );
  }

  Widget _submitButton() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: isLogin
                ? signInWithEmailAndPassword
                : createUserWithEmailAndPassword,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              isLogin ? 'Login' : 'Register',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: signInWithGoogle,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/google_logo2.png', height: 24.0),
                const SizedBox(width: 12.0),
                const Text(
                  'Sign in with Google',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _loginOrRegistrationButton() {
    return Column(
      children: [
        const SizedBox(height: 10),
        TextButton(
          onPressed: () {
            setState(() {
              isLogin = !isLogin;
            });
          },
          child: Text(
            isLogin ? 'Register instead' : 'Login instead',
            style: const TextStyle(color: Colors.blue, fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget _animation() {
    return Lottie.asset(
      'assets/login.json',
      controller: _controllerAnimation,
      height: 200,
      reverse: true,
      repeat: true,
      fit: BoxFit.cover,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: _title(),
        backgroundColor: const Color.fromARGB(255, 50, 182, 230),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(_backgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        if (loginAnimation == false) {
                          _controllerAnimation.forward();
                          loginAnimation = true;
                        } else {
                          _controllerAnimation.reverse();
                          loginAnimation = false;
                        }
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.asset(
                          'assets/logo.png',
                          height: 300,
                          width: 300,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _entryField('Email', _controllerEmail),
                  const SizedBox(height: 10),
                  _passwordEntryField(_controllerPassword),
                  if (isLoading) ...[
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: CircularProgressIndicator(),
                    ),
                  ],
                  const SizedBox(height: 10),
                  _errorMessage(),
                  _successMessage(),
                  _submitButton(),
                  _loginOrRegistrationButton(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
