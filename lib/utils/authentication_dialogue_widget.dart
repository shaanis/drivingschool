import 'package:flutter/material.dart';

class AuthenticationDialogueWidget extends StatelessWidget {
  final String? message;
  const AuthenticationDialogueWidget({this.message, super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        height: 100,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const CircularProgressIndicator(
              strokeWidth: 2,
            ),
            Text(message!),
          ],
        ),
      ),
    );
  }
}
