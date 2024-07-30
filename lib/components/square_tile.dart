import 'package:flutter/material.dart';

class SquareTile extends StatelessWidget {
  final String imagePath;
  final String imageText;
  final Function()? onTap;

  const SquareTile({
    Key? key,
    required this.imagePath,
    required this.imageText,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.07,
        width: MediaQuery.of(context).size.width * 0.85,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade500),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            SizedBox(
                width: MediaQuery.of(context).size.width *
                    0.05), 
            Text(
              imageText,
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 18, 
                fontWeight: FontWeight.w500, 
              ),
            ),
          ],
        ),
      ),
    );
  }
}
