import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:note/components/gradient_button.dart';
import 'package:note/components/normal_textfield.dart';
import 'package:note/components/square_tile.dart';
import 'package:note/components/visibility_textfield.dart';
import 'package:note/pages/login_page.dart';
import 'package:note/pages/verification_page.dart';
import 'package:note/services/google_login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({
    super.key,
  });
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmpasswordController = TextEditingController();
  bool isError = false;
  String emailError = '';
  String passwordError = '';
  Color color = Colors.grey.shade600;

  void registerUser() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
        );
      },
    );

    if (emailController.text.isNotEmpty) {
      try {
        if (passwordController.text == confirmpasswordController.text) {
          
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text,
          );

          // Navigate to HomePage after successful sign-in
          Navigator.pushAndRemoveUntil(
            // ignore: use_build_context_synchronously
            context,
            MaterialPageRoute(builder: (context) => const VerificationPage()),
            (Route<dynamic> route) => false,
          );
        } else {
          Navigator.pop(context);
          isError = true;
          emailError = 'Invalid credentials, Please check your email.';
          passwordError = 'Invalid credentials, Passwords don\'t match.';
          setState(() {});
        }

        //Handle errors
      } on FirebaseAuthException catch (e) {
        isError = true;

        //Display exception in terminal
        if (kDebugMode) {
          print("Exception code : ${e.code}");
        }
        //pop the loading circle
        // ignore: use_build_context_synchronously
        Navigator.pop(context);

        //invalid user
        if (e.code == 'invalid-credential') {
          emailError = 'Invalid credentials, Please check your email.';
          passwordError = 'Invalid credentials, Please check your password.';

          //Display error to user
        } else if (e.code == 'invalid-email') {
          emailError = 'Invalid email, Please check your email.';
          passwordError = 'Invalid email, Please check your password.';
          //Display error to user
        } else if (e.code == 'channel-error') {
          //No email and passwords
          emailError = 'Empty credentials, Please enter your email.';
          passwordError = 'Empty credentials, Please enter your password.';
        } else if (e.code == 'email-already-in-us') {
          emailError = 'Empty credentials, Please enter your email.';
          passwordError = 'Empty credentials, Please enter your password.';
        } else {
          emailError = 'Please check your email.';
          passwordError = 'Please check your password.';
        }

        // Trigger a rebuild
        setState(() {});
      }
      setState(() {});
    } else {
      Navigator.pop(context);
      isError = true;
      emailError = 'Invalid credentials, Please enter your email.';
      passwordError = 'Invalid credentials, Please check your password.';
      setState(() {});
    }
  }


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    if (isError) {
      color = Colors.red;
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              size: 25,
              color: Theme.of(context).colorScheme.primary,
            ),
            onPressed: () {
              Navigator.pop(context); // Go back to the previous screen
            },
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: screenHeight * 0.23,
                width: screenWidth * 0.85,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Register',
                      style: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .primary, 
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.01,
                      width: screenWidth,
                    ),
                    Text(
                      'Let\'s create your account. Please enter your email and a password',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),

              Normaltextfield(
                controller: emailController,
                hintText: 'Enter your email',
                obscureText: false,
                color: color,
              ),
              Container(
                margin: EdgeInsets.only(top: screenHeight * 0.01),
                height: screenHeight * 0.03,
                width: screenWidth * 0.85,
                child: isError && passwordError.isNotEmpty
                    ? Text(
                        emailError,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.left,
                      )
                    : const SizedBox.shrink(),
              ),
              // Password textfield
              VisibilityTextField(
                controller: passwordController,
                hintText: 'Enter your password',
                obscureText: true,
                color: color,
              ),

              // Displaying Password Error
              Container(
                margin: EdgeInsets.only(top: screenHeight * 0.01),
                height: screenHeight * 0.03,
                width: screenWidth * 0.85,
                child: isError && passwordError.isNotEmpty
                    ? Text(
                        passwordError,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.left,
                      )
                    : const SizedBox.shrink(),
              ),
              // Password textfield
              VisibilityTextField(
                controller: confirmpasswordController,
                hintText: 'Enter confirmation password',
                obscureText: true,
                color: color,
              ),
              // Displaying Password Error
              Container(
                margin: EdgeInsets.only(top: screenHeight * 0.01),
                height: screenHeight * 0.03,
                width: screenWidth * 0.85,
                child: isError && passwordError.isNotEmpty
                    ? Text(
                        passwordError,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.left,
                      )
                    : const SizedBox.shrink(),
              ),

              SizedBox(
                height: screenHeight * 0.02,
                width: screenWidth,
              ),

              GradientButton(
                onTap: registerUser,
                buttonText: 'Register',
              ),

              SizedBox(
                height: screenHeight * 0.03, 
                width: screenWidth,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                child: Row(
                  children: [
                    const Expanded(
                      child: Divider(
                        thickness: 0.8,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      ' or Login with ',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 0.8,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: screenHeight * 0.03, 
                width: screenWidth,
              ),

              SquareTile(
                onTap: () => signInWithGoogle(context),
                imagePath: 'assets/images/Google_icon.png',
                imageText: 'log in with Google',
              ),

              SizedBox(
                height: screenHeight * 0.03, 
                width: screenWidth,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Have an account? ',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                      );
                    }, 
                    child: const Text(
                      ' Login Now',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
