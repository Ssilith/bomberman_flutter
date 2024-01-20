import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final Function() onPressed;
  final IconData icon;
  const MyButton({super.key, required this.onPressed, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8), color: Colors.grey),
            child: Icon(
              icon,
              size: 30,
              color: Colors.black,
            )),
      ),
    );
  }
}
