import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AvailableDriversTable extends StatefulWidget {
  @override
  AvailableDriversTableState createState() => AvailableDriversTableState();
}

class AvailableDriversTableState extends State<AvailableDriversTable> {
  late TextEditingController searchController;
  late Stream<QuerySnapshot> patientsStream;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    patientsStream = FirebaseFirestore.instance
        .collection('patients')
        .orderBy('code') // Adjust the field to order by
        .snapshots();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              // padding: const EdgeInsets.only(left: 20, top: 5, bottom: 5),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.deepPurple),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: TextFormField(
                  controller: searchController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: 'Search',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (value) {
                    setState(() {
                      patientsStream = FirebaseFirestore.instance
                          .collection('patients')
                          .where('code', isGreaterThanOrEqualTo: value)
                          .where('code', isLessThan: (value ?? '') + 'z')
                          .snapshots();
                    });
                  },
                ),
              ),
            ),
          ),
          SizedBox(height: 50),
          StreamBuilder(
            stream: patientsStream,
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              List<Row> patientWidgets = [];
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              // if (snapshot.hasData) {
              //   final patients = snapshot.data?.docs.reversed.toList();
              //   for (var patients in patients!) {
              //     final patientWidget = Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //       children: [
              //         Text(patients['firstName']),
              //         Text(patients['lastName']),
              //         Text(patients['email']),
              //         Text(patients['code']),
              //       ],
              //     );
              //     patientWidgets.add(patientWidget);
              //   }
              // }

              if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }

              if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Text('No patients found.'),
                );
              }

              // return Expanded(
              //   child: ListView(
              //     children: patientWidgets,
              //   ),
              // );

              return ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: snapshot.data!.docs.map((document) {
                  Map<String, dynamic> patientData =
                      document.data() as Map<String, dynamic>;
                  return ListTile(
                    leadingAndTrailingTextStyle: TextStyle(fontSize: 25),
                    leading: Text(patientData['firstName']),
                    title: Text(patientData['lastName']),
                    subtitle: Text(patientData['email']),
                    trailing: Text(patientData['code']),
                    // Add more details if necessary
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
