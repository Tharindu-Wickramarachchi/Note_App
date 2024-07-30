import 'package:flutter/material.dart';
import 'package:note/components/gradient_button.dart';
import 'package:note/pages/login_page.dart';
import 'package:note/pages/register_page.dart';

class SignupLoginSelector extends StatelessWidget {
  const SignupLoginSelector({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Column(
          children: [
            SizedBox(
              height: screenHeight * 0.60,
              width: screenWidth,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: screenHeight * 0.10),
                  Text(
                    'Welcome to',
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Image.asset(
                    'assets/images/Note_Logo.png',
                    height: screenHeight * 0.33,
                    width: screenWidth,
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Text(
                    'The ultimate destination for',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                  Text(
                    'capture your knowledge',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.07),
            GradientButton(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              buttonText: 'Login',
            ),
            SizedBox(height: screenHeight * 0.07),
            GradientButton(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterPage()),
                );
              },
              buttonText: 'Register',
            ),
          ],
        ),
      ),
    );
  }
}
