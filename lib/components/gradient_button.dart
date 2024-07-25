import 'package:flutter/material.dart';

class GradientButton extends StatefulWidget {
  final Function()? onTap;
  final String buttonText;

  const GradientButton({
    super.key,
    required this.onTap,
    required this.buttonText,
  });

  @override
  _GradientButtonState createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        // padding: const EdgeInsets.all(18),
        // margin: const EdgeInsets.symmetric(horizontal: 25), // Left and right margin
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
        child: Center(
          child: Text(
            widget.buttonText,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}