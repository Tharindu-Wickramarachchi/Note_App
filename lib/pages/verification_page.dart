import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:note/pages/home_page.dart';
import 'package:note/pages/signUp_logIn_selector.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({super.key});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  bool isEmailVerified = false;
  bool canResendEmail = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!isEmailVerified) {
      sendVerificationEmail();

      timer = Timer.periodic(
        const Duration(seconds: 3),
        (_) => checkEmailVerified(),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();

    if (!mounted) return; // Check if the widget is still mounted

    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) timer?.cancel();
  }

  // Future sendVerificationEmail() async {
  //   try {
  //     final user = FirebaseAuth.instance.currentUser!;
  //     await user.sendEmailVerification();
  //     if (kDebugMode) {
  //       print(
  //           '----------------------------------------------------------------');
  //       print('email => ${user.email}');
  //       print(
  //           '----------------------------------------------------------------');
  //     }

  //     if (!mounted) return; // Check if the widget is still mounted

  //     setState(() => canResendEmail = false);
  //     await Future.delayed(const Duration(seconds: 60));

  //     if (!mounted) return; // Check if the widget is still mounted

  //     setState(() => canResendEmail = true);
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print('Send verification email error : $e');
  //     }
  //   }
  // }
  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
      if (kDebugMode) {
        print('email ${user.email}');
      }

      setState(() => canResendEmail = false);
      await Future.delayed(const Duration(seconds: 60));
      setState(() => canResendEmail = true);
    } catch (e) {
      if (kDebugMode) {
        print('Send verification email error : $e');
      }
    }
  }

  Future cancelEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      user?.delete();
    } catch (e) {
      if (kDebugMode) {
        print('Send verification email error : $e');
      }
    }
  }

  void navigateToSelectorPage(BuildContext context) {
    cancelEmail(); // Call the cancelEmail function
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const SignupLoginSelector()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) => isEmailVerified
      ? HomePage()
      : Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/email_icon.png',
                  width: MediaQuery.of(context).size.width * 0.50,
                  height: MediaQuery.of(context).size.width * 0.50,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                const Text(
                  'Please Verify your Email',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                const Text(
                  'Verification email has been sent to',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Text(
                  '${FirebaseAuth.instance.currentUser!.email}', // Displaying user's email
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                const Text(
                  'Click on the link to complete the verification process',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                const Text(
                  'Wait 60 seconds to get new verification email',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.07,
                  width: MediaQuery.of(context).size.width * 0.85,
                  decoration: BoxDecoration(
                    // gradient: const LinearGradient(
                    //   colors: [
                    //     Color.fromARGB(255, 0, 80, 255), // Blue 1
                    //     Color.fromARGB(255, 0, 120, 255), // Blue 2
                    //     Color.fromARGB(255, 0, 180, 255), // Blue 3
                    //     Color.fromARGB(255, 0, 220, 255), // Blue 4
                    //   ],
                    //   begin: Alignment.topLeft,
                    //   end: Alignment.bottomRight,
                    // ),
                    gradient: canResendEmail
                        ? const LinearGradient(
                            colors: [
                              Color.fromARGB(255, 0, 80, 255), // Blue 1
                              Color.fromARGB(255, 0, 120, 255), // Blue 2
                              Color.fromARGB(255, 0, 180, 255), // Blue 3
                              Color.fromARGB(255, 0, 220, 255), // Blue 4
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : const LinearGradient(
                            colors: [
                              Color.fromARGB(255, 100, 100, 100), // Blue 1
                              Color.fromARGB(255, 150, 150, 150), // Blue 2
                              Color.fromARGB(255, 200, 200, 200), // Blue 3
                              Color.fromARGB(255, 250, 250, 250), // Blue 4
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                    border: Border.all(
                      color: Colors.black, // Border color
                      width: 0.5, // Border width
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(
                        MediaQuery.of(context).size.width * 0.85,
                        MediaQuery.of(context).size.height * 0.07,
                      ),
                      backgroundColor: Colors
                          .transparent, // Make the button background transparent
                      shadowColor: Colors.transparent, // Remove button shadow
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            5), // Match the container's border radius
                      ),
                    ),
                    icon: const Icon(
                      Icons.email,
                      size: 32,
                      color: Colors.black,
                    ),
                    label: const Text(
                      'Resend Email',
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.black,
                      ),
                    ),
                    onPressed: canResendEmail ? sendVerificationEmail : null,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.04,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.07,
                  width: MediaQuery.of(context).size.width * 0.85,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 0, 80, 255), // Blue 1
                        Color.fromARGB(255, 0, 120, 255), // Blue 2
                        Color.fromARGB(255, 0, 180, 255), // Blue 3
                        Color.fromARGB(255, 0, 220, 255), // Blue 4
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    border: Border.all(
                      color: Colors.black, // Border color
                      width: 0.5, // Border width
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(
                        MediaQuery.of(context).size.width * 0.85,
                        MediaQuery.of(context).size.height * 0.07,
                      ),
                      backgroundColor: Colors
                          .transparent, // Make the button background transparent
                      shadowColor: Colors.transparent, // Remove button shadow
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            5), // Match the container's border radius
                      ),
                    ),
                    icon: const Icon(
                      Icons.email,
                      size: 32,
                      color: Colors.black,
                    ),
                    label: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.black,
                      ),
                    ),
                    onPressed: () => navigateToSelectorPage(context),
                  ),
                ),
              ],
            ),
          ),
        );
}
