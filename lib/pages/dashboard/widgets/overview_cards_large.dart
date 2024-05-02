import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hmsapp/pages/dashboard/widgets/info_card.dart';

class OverviewCardsLargeScreen extends StatefulWidget {
  const OverviewCardsLargeScreen({Key? key}) : super(key: key);

  @override
  _OverviewCardsLargeScreenState createState() =>
      _OverviewCardsLargeScreenState();
}

class _OverviewCardsLargeScreenState extends State<OverviewCardsLargeScreen> {
  int newPatientsCount = 0;
  int appointmentCount = 0;
  int operationsCount = 0;
  int totalPatientsThisWeek = 0; // Added totalPatientsThisWeek variable

  @override
  void initState() {
    super.initState();
    // Call functions to fetch data from Firestore and update counts
    fetchAppointmentCount();
    fetchOperationsCount();
    fetchTotalPatientsThisWeek(); // Call the function to fetch total patients this week
    // Listen for changes in patients collection
    FirebaseFirestore.instance
        .collection('patients')
        .snapshots()
        .listen((event) {
      fetchNewPatientsCount();
    });
  }

  Future<void> fetchNewPatientsCount() async {
    // Calculate the start and end of the current day
    DateTime now = DateTime.now();
    DateTime startOfDay = DateTime(now.year, now.month, now.day);
    DateTime endOfDay = startOfDay.add(Duration(days: 1));

    // Retrieve data from Firestore
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('patients')
        .where('registrationDate', isGreaterThanOrEqualTo: startOfDay)
        .where('registrationDate', isLessThan: endOfDay)
        .get();

    // Update the count of new patients for today
    setState(() {
      newPatientsCount = snapshot.docs.length;
    });
  }

  Future<void> fetchAppointmentCount() async {
    // Retrieve data from Firestore
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('bookings').get();
        

    // Update the count of appointments
    setState(() {
      appointmentCount = snapshot.docs.length;
    });
  }

  Future<void> fetchOperationsCount() async {
    // Retrieve data from Firestore
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('predictions').get();

    // Update the count of operations
    setState(() {
      operationsCount = snapshot.docs.length;
    });
  }

  Future<void> fetchTotalPatientsThisWeek() async {
    // Calculate the start date of the current week (assuming week starts on Sunday)
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));

    // Retrieve data from Firestore
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('patients')
        .where('registrationDate', isGreaterThanOrEqualTo: startOfWeek)
        .get();

    // Update the count of total patients this week
    setState(() {
      totalPatientsThisWeek = snapshot.docs.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Row(
      children: [
        InfoCard(
          title: "Appointment",
          value: appointmentCount.toString(),
          onTap: () {},
          topColor: Colors.orange,
        ),
        SizedBox(
          width: width / 64,
        ),
        InfoCard(
          title: "New Patients",
          value: newPatientsCount.toString(),
          topColor: Colors.lightGreen,
          onTap: () {},
        ),
        SizedBox(
          width: width / 64,
        ),
        InfoCard(
          title: "Consultation",
          value: operationsCount.toString(),
          topColor: Colors.redAccent,
          onTap: () {},
        ),
        SizedBox(
          width: width / 64,
        ),
        InfoCard(
          title: "Total Patient this week",
          value: totalPatientsThisWeek.toString(),
          onTap: () {},
        ),
      ],
    );
  }
}
