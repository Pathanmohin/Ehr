import 'package:flutter/material.dart';

class IconButton extends StatefulWidget {
  @override
  _IconButtonState createState() => _IconButtonState();
}

class _IconButtonState extends State<IconButton> {
  @override
  Widget build(BuildContext context) {
    return _buildIconButton('example_image.png', () {
      // Add your onTap logic here
    });
  }

  Widget _buildIconButton(String image, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 35,
        height: 35,
        decoration: BoxDecoration(
          color: Color(0xFF951A1C),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Image.asset(
            'assets/images/$image',
            width: 20,
            height: 20,
          ),
        ),
      ),
    );
  }
}
