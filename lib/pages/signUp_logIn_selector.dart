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
        backgroundColor: Colors.white,
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
                  const Text(
                    'Welcome to',
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black), // Customize your text style
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Image.asset(
                    'assets/images/Note_Logo.png',
                    height: screenHeight * 0.33,
                    width: screenWidth,
                  ), // Replace with your image
                  SizedBox(height: screenHeight * 0.01),
                  Text(
                    'The ultimate destination for',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color:
                            Colors.grey.shade700), // Customize your text style
                  ),
                  Text(
                    'capture your knowledge',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color:
                            Colors.grey.shade700), // Customize your text style
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.07),

            // InkWell(
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => LoginPage()),
            //     );
            //   },
            //   child: Container(
            //     height: MediaQuery.of(context).size.height * 0.07,
            //     width: MediaQuery.of(context).size.width * 0.85,
            //     decoration: BoxDecoration(
            //       gradient: const LinearGradient(
            //         colors: [
            //           Color.fromARGB(255, 0, 80, 255), // Blue 1
            //           Color.fromARGB(255, 0, 120, 255), // Blue 2
            //           Color.fromARGB(255, 0, 180, 255), // Blue 3
            //           Color.fromARGB(255, 0, 220, 255), // Blue 4
            //         ],
            //         begin: Alignment.topLeft,
            //         end: Alignment.bottomRight,
            //       ),
            //       border: Border.all(
            //         color: Colors.black, // Border color
            //         width: 0.5, // Border width
            //       ),
            //       borderRadius: BorderRadius.circular(5),
            //     ),
            //     child: const Center(
            //       child: Text(
            //         'Login',
            //         style: TextStyle(
            //           color: Colors.black,
            //           fontSize: 20,
            //           fontWeight: FontWeight.bold,
            //         ),
            //       ),
            //     ),
            //   ),
            // ),

            GradientButton(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              buttonText: 'Login',
            ),

            SizedBox(height: screenHeight * 0.07),

            GradientButton(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterPage()),
                );
              },
              buttonText: 'Register',
            ),

            // Container(
            //   // height: screenHeight * 0.5,
            //   // width: screenWidth,
            //   color: Colors.amber,
            //   child: WaveWidget(
            //     config: CustomConfig(
            //       colors: [
            //         Colors.blue.withOpacity(0.4),
            //         Colors.blue.withOpacity(0.6),
            //         Colors.blue.withOpacity(0.8),
            //         Colors.blue,
            //       ],
            //       durations: [
            //         19450, // Adjust duration to slow down the wave
            //         19500, // Adjust duration to slow down the wave
            //         19600, // Adjust duration to slow down the wave
            //         19700, // Adjust duration to slow down the wave
            //       ],
            //       heightPercentages: [0.30, 0.34, 0.45, 0.56],
            //     ),
            //     size: Size(screenWidth, screenHeight * 0.30),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
