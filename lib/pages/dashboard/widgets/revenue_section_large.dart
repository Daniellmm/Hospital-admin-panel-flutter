import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:hmsapp/constants/style.dart';
import 'package:hmsapp/pages/dashboard/widgets/revenue_info.dart';
import 'package:hmsapp/widgets/custom.dart';

class RevenueSectionLarge extends StatefulWidget {
  const RevenueSectionLarge({super.key});

  @override
  State<RevenueSectionLarge> createState() => _RevenueSectionLargeState();
}

class _RevenueSectionLargeState extends State<RevenueSectionLarge> {
  double todayRevenue = 0.0;
  double last7DaysRevenue = 0.0;
  double last30DaysRevenue = 0.0;
  double last12MonthsRevenue = 0.0;

  @override
  void initState() {
    super.initState();
    updateTodayRevenue();
  }

  void updateTodayRevenue() {
    // Get today's date
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);

    // Get payments made today
    FirebaseFirestore.instance
        .collection('Payments')
        .where('paymentDate',
            isGreaterThanOrEqualTo: today,
            isLessThan: today.add(Duration(days: 1)))
        .get()
        .then((QuerySnapshot querySnapshot) {
      double totalAmount = 0.0;
      querySnapshot.docs.forEach((doc) {
        totalAmount += double.parse(doc['Totalbills']);
      });

      // Update the UI with today's revenue
      setState(() {
        todayRevenue = totalAmount;
      });
    });

    // Get payments made in the last 7 days
    DateTime sevenDaysAgo = today.subtract(Duration(days: 7));
    FirebaseFirestore.instance
        .collection('Payments')
        .where('paymentDate',
            isGreaterThanOrEqualTo: sevenDaysAgo,
            isLessThan: today.add(Duration(days: 1)))
        .get()
        .then((QuerySnapshot querySnapshot) {
      double totalAmount = 0.0;
      querySnapshot.docs.forEach((doc) {
        totalAmount += double.parse(doc['Totalbills']);
      });

      // Update the UI with last 7 days revenue
      setState(() {
        last7DaysRevenue = totalAmount;
      });
    });

    // Get payments made in the last 30 days
    DateTime thirtyDaysAgo = today.subtract(Duration(days: 30));
    FirebaseFirestore.instance
        .collection('Payments')
        .where('paymentDate',
            isGreaterThanOrEqualTo: thirtyDaysAgo,
            isLessThan: today.add(Duration(days: 1)))
        .get()
        .then((QuerySnapshot querySnapshot) {
      double totalAmount = 0.0;
      querySnapshot.docs.forEach((doc) {
        totalAmount += double.parse(doc['Totalbills']);
      });

      // Update the UI with last 30 days revenue
      setState(() {
        last30DaysRevenue = totalAmount;
      });
    });

    // Get payments made in the last 12 months
    DateTime twelveMonthsAgo = today.subtract(Duration(days: 365));
    FirebaseFirestore.instance
        .collection('Payments')
        .where('paymentDate',
            isGreaterThanOrEqualTo: twelveMonthsAgo,
            isLessThan: today.add(Duration(days: 1)))
        .get()
        .then((QuerySnapshot querySnapshot) {
      double totalAmount = 0.0;
      querySnapshot.docs.forEach((doc) {
        totalAmount += double.parse(doc['Totalbills']);
      });

      // Update the UI with last 12 months revenue
      setState(() {
        last12MonthsRevenue = totalAmount;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.symmetric(vertical: 30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
              offset: const Offset(0, 6),
              color: lightGrey.withOpacity(.1),
              blurRadius: 12)
        ],
        border: Border.all(color: lightGrey, width: .5),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomText(
                  text: "Revenue Chart",
                  size: 20,
                  weight: FontWeight.bold,
                  color: lightGrey,
                ),
                SizedBox(
                  width: 600,
                  height: 200,
                  // child: SimpleBarChart.withSampleData()
                ),
              ],
            ),
          ),
          Container(
            width: 1,
            height: 120,
            color: lightGrey,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    RevenueInfo(
                      title: "Today's revenue",
                      amount: NumberFormat.currency(symbol: '')
                          .format(todayRevenue),
                    ),
                    RevenueInfo(
                      title: "Last 7 days",
                      amount: NumberFormat.currency(symbol: '')
                          .format(last7DaysRevenue),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    RevenueInfo(
                      title: "Last 30 days",
                      amount: NumberFormat.currency(symbol: '')
                          .format(last30DaysRevenue),
                    ),
                    RevenueInfo(
                      title: "Last 12 months",
                      amount: NumberFormat.currency(symbol: '')
                          .format(last12MonthsRevenue),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
