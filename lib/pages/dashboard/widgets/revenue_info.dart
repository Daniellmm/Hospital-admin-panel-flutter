import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hmsapp/constants/style.dart';
import 'package:intl/intl.dart';

class RevenueInfo extends StatefulWidget {
  final String? title;
  final String? amount;

  const RevenueInfo({Key? key, this.title, this.amount}) : super(key: key);

  @override
  State<RevenueInfo> createState() => _RevenueInfoState();
}

class _RevenueInfoState extends State<RevenueInfo> {
  String getFormattedAmount() {
    if (widget.amount == null) {
      return '';
    }
    // Parse amount to double
    double amount = double.tryParse(widget.amount!) ?? 0.0;
    // Format amount with Naira symbol
    NumberFormat format = NumberFormat.currency(
      locale: Platform.localeName,
      symbol: '₦', // Naira symbol
    );
    return format.format(amount);
  }

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
              text: getFormattedAmount(),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
