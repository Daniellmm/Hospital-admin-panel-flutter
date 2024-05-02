import 'package:flutter/material.dart';


class CustomText extends StatelessWidget {
  final String text;
  final double? size;
  final Color? color;
  final FontWeight? weight;
  final Key? key; // Declare key here

  const CustomText({
    this.key,
    required this.text,
     this.size , // Default value for size
     this.color, // Default value for color
     this.weight, // Default value for weight
  }) : super(key: key); // Pass key to super constructor

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontSize: size ?? 16,
          color: color ?? Colors.black,
          fontWeight: weight ?? FontWeight.normal),
    );
  }
}








// class CustomText extends StatelessWidget {
//   final String text;
//   final double size;
//   final Color color;
//   final FontWeight weight;

//   const CustomText(
//       {super.key,
//       required this.text,
//       required this.size,
//       required this.color,
//       required this.weight});

//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       text,
//       style: TextStyle(
//           fontSize: size ?? 16,
//           color: color ?? Colors.black,
//           fontWeight: weight ?? FontWeight.normal),
//     );
//   }
// }
