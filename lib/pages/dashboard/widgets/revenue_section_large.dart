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

    // Listen for changes in the payments field of any patient document
    FirebaseFirestore.instance
        .collection('patients')
        .snapshots()
        .listen((event) {
      updateTodayRevenue();
      updateLast7DaysRevenue();
      updateLast30DaysRevenue();
      updateLast12MonthsRevenue();
    });
  }

  void updateTodayRevenue() {
    // Get today's date
    DateTime now = DateTime.now();
    DateTime startOfDay = DateTime(now.year, now.month, now.day);
    DateTime endOfDay = startOfDay.add(Duration(days: 1));

    // Retrieve data from Firestore
    FirebaseFirestore.instance
        .collection('patients')
        .where('payment.paymentDate',
            isGreaterThanOrEqualTo: startOfDay, isLessThan: endOfDay)
        .get()
        .then((QuerySnapshot querySnapshot) {
      double totalAmount = 0.0;
      querySnapshot.docs.forEach((doc) {
        final data = doc.data() as Map<String, dynamic>?;
        if (data != null && data.containsKey('payment')) {
          List<dynamic> payments = data['payment'];
          payments.forEach((payment) {
            // Check if payment date is today
            DateTime paymentDate =
                (payment['paymentDate'] as Timestamp).toDate();
            if (paymentDate.isAfter(startOfDay) &&
                paymentDate.isBefore(endOfDay)) {
              totalAmount += payment['amount'];
            }
          });
        }
      });

      // Update today's revenue
      setState(() {
        todayRevenue = totalAmount;
      });
    });
  }

  void updateLast7DaysRevenue() {
    // Calculate the date 7 days ago
    DateTime now = DateTime.now();
    DateTime sevenDaysAgo = now.subtract(Duration(days: 7));

    // Retrieve data from Firestore
    FirebaseFirestore.instance
        .collection('patients')
        .get()
        .then((QuerySnapshot querySnapshot) {
      double totalAmount = 0.0;
      querySnapshot.docs.forEach((doc) {
        final data = doc.data() as Map<String, dynamic>?;
        if (data != null && data.containsKey('payments')) {
          List<dynamic> payments = data['payment'];
          payments.forEach((payments) {
            DateTime paymentDate =
                (payments['paymentDate'] as Timestamp).toDate();
            if (paymentDate.isAfter(sevenDaysAgo) &&
                paymentDate.isBefore(now)) {
              totalAmount += payments['Totalbills'];
            }
          });
        }
      });

      // Update last 7 days revenue
      setState(() {
        last7DaysRevenue = totalAmount;
      });
    });
  }

  void updateLast30DaysRevenue() {
    // Calculate the date 30 days ago
    DateTime now = DateTime.now();
    DateTime thirtyDaysAgo = now.subtract(Duration(days: 30));

    // Retrieve data from Firestore
    FirebaseFirestore.instance
        .collection('patients')
        .get()
        .then((QuerySnapshot querySnapshot) {
      double totalAmount = 0.0;
      querySnapshot.docs.forEach((doc) {
        final data = doc.data() as Map<String, dynamic>?;
        if (data != null && data.containsKey('payments')) {
          List<dynamic> payments = data['payment'];
          payments.forEach((payment) {
            DateTime paymentDate =
                (payment['paymentDate'] as Timestamp).toDate();
            if (paymentDate.isAfter(thirtyDaysAgo) &&
                paymentDate.isBefore(now)) {
              totalAmount += payment['amount'];
            }
          });
        }
      });

      // Update last 30 days revenue
      setState(() {
        last30DaysRevenue = totalAmount;
      });
    });
  }

  void updateLast12MonthsRevenue() {
    // Calculate the date 12 months ago
    DateTime now = DateTime.now();
    DateTime twelveMonthsAgo = now.subtract(Duration(days: 365));

    // Retrieve data from Firestore
    FirebaseFirestore.instance
        .collection('patients')
        .get()
        .then((QuerySnapshot querySnapshot) {
      double totalAmount = 0.0;
      querySnapshot.docs.forEach((doc) {
        final data = doc.data() as Map<String, dynamic>?;
        if (data != null && data.containsKey('payment')) {
          List<dynamic> payments = data['paymentS'];
          payments.forEach((payment) {
            DateTime paymentDate =
                (payment['paymentDate'] as Timestamp).toDate();
            if (paymentDate.isAfter(twelveMonthsAgo) &&
                paymentDate.isBefore(now)) {
              totalAmount += payment['Totalbills'];
            }
          });
        }
      });

      // Update last 12 months revenue
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
                SizedBox(height: 30),
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
