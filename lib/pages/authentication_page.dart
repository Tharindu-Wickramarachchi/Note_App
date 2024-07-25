import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:note/pages/signUp_logIn_selector.dart';
import 'package:note/pages/verification_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        _navigateToPage(const SignupLoginSelector());
      } else {
        _navigateToPage(const VerificationPage());
      }
    });
  }

  void _navigateToPage(Widget page) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => page),
        (Route<dynamic> route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      // body: Center(
      //   child:
      //       Show a loading indicator while waiting for the auth state
      //       CircularProgressIndicator(), 
      // ),
    );
  }
}
