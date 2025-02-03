import 'package:flutter/material.dart';

// Define colors
const Color primaryColor = Color(0xFF00FF00); // Example color
const Color secondaryColor = Color(0xFF547EC8); // Example color

// Reusable Button Widget
class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color buttonColor;

  const CustomButton({
    Key? key,
    required this.label,
    required this.onPressed,
    required this.buttonColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        onPressed();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Container(
          height: 55,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                  fontFamily: "TimesNewRoman",
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );

    // ElevatedButton(
    //   style: ElevatedButton.styleFrom(
    //     backgroundColor: buttonColor, // Use backgroundColor instead of primary
    //     padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    //     textStyle: TextStyle(fontSize: 18),
    //   ),
    //   onPressed: onPressed,
    //   child: Text(label),
    // );
  }
}
