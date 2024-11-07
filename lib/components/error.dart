
import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class Error_snack{
  final String message;
  Error_snack({required this.message});

  // Method to show the
  void show(BuildContext context) {
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      dismissDirection: DismissDirection.down,
      content: AwesomeSnackbarContent(
        titleTextStyle:const TextStyle(
          fontFamily: 'SF-Pro',
          fontSize: 22, // Increased for better emphasis on the title
          fontWeight: FontWeight.bold, // Added to make the title stand out
          color: Color(0xffFCFAEE), // A slight color change for a more noticeable title
          letterSpacing: 1.2, // Added for a professional touch
        ),

        messageTextStyle:const TextStyle(
          fontFamily: 'SF-Pro',
          fontSize: 16, // Slightly larger for better readability
          fontWeight: FontWeight.w500, // Semi-bold for clarity
          color: Color(0xffFCFAEE), // Subtle opacity for a cleaner look
          letterSpacing: 1.0, // Consistent with the title spacing
        ),
        color:const Color(0xffB8001F),
        title: 'Error',
        message: message,
        contentType: ContentType.failure,
      ),
    );
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
