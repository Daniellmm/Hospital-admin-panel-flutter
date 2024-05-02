import 'package:flutter/material.dart';

class MediumScreen extends StatelessWidget {
  const MediumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
        children: [
          Expanded(child: Container(
            color: Colors.red,
          )),
          Expanded(
            flex: 5,
            child: Container(
            color: Colors.blue,
          ))
        ],
      );
  }
}