import 'package:flutter/material.dart';


class TopBar extends StatelessWidget {
  final VoidCallback onBackButtonPressed;
  final VoidCallback onShareButtonPressed;

  const TopBar({
    Key? key,
    required this.onBackButtonPressed,
    required this.onShareButtonPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: onBackButtonPressed,
            ),
            const Text(
              'Lesmills Player',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            IconButton(
              icon: const Icon(Icons.share, color: Colors.white),
              onPressed: onShareButtonPressed,
            ),
          ],
        ),
      ),
    );
  }
}
