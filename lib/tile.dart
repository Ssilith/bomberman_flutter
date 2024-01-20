import 'package:flutter/material.dart';

class Tile extends StatelessWidget {
  final Color? color;
  const Tile({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      child: Stack(
        children: [
          Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5), color: color)),
        ],
      ),
    );
  }
}
