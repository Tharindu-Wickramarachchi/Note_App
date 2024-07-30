import 'package:flutter/material.dart';

class VisibilityTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final Color color; 

  const VisibilityTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.color, 
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _VisibilityTextFieldState createState() => _VisibilityTextFieldState();
}

class _VisibilityTextFieldState extends State<VisibilityTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.07),
      child: TextField(
        controller: widget.controller,
        obscureText: _obscureText,
        decoration: InputDecoration(
          hintText: widget.hintText,
          suffixIcon: IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: widget.color, 
              width: 1.5,
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
              width: 1.5,
            ),
          ),
          fillColor: Colors.blue.shade200,
          filled: true,
          hintStyle: const TextStyle(
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
