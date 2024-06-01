import 'package:flutter/material.dart';
import 'package:hmsapp/constants/style.dart';

class RevenueInfo extends StatefulWidget {
  final String? title;
  final String? amount;

  const RevenueInfo({Key? key, this.title, this.amount}) : super(key: key);

  @override
  State<RevenueInfo> createState() => _RevenueInfoState();
}

class _RevenueInfoState extends State<RevenueInfo> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: "${widget.title} \n\n",
              style: TextStyle(color: lightGrey, fontSize: 16),
            ),
            TextSpan(
              text: "${widget.amount != null ? '₦${widget.amount}' : ''}",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
