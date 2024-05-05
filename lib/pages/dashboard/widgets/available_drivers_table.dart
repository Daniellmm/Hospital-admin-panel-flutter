import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AvailableDriversTable extends StatefulWidget {
  const AvailableDriversTable({Key? key}) : super(key: key);

  @override
  AvailableDriversTableState createState() => AvailableDriversTableState();
}

class AvailableDriversTableState extends State<AvailableDriversTable> {
  late TextEditingController searchController;
  late Query patientsQuery;
  final int itemsPerPage = 5;
  DocumentSnapshot? lastDocument;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    patientsQuery = FirebaseFirestore.instance
        .collection('patients')
        .orderBy('code')
        .limit(itemsPerPage);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void loadMorePatients() {
    if (lastDocument != null) {
      setState(() {
        patientsQuery = FirebaseFirestore.instance
            .collection('patients')
            .orderBy('code')
            .startAfterDocument(lastDocument!)
            .limit(itemsPerPage);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Patient List',
            style: TextStyle(fontSize: 25),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.deepPurple),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: TextFormField(
                  controller: searchController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    labelText: 'Search',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (value) {
                    setState(() {
                      patientsQuery = FirebaseFirestore.instance
                          .collection('patients')
                          .where('code', isGreaterThanOrEqualTo: value)
                          .where('code', isLessThan: (value ?? '') + 'z')
                          .orderBy('code')
                          .limit(itemsPerPage);
                    });
                  },
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          StreamBuilder<QuerySnapshot>(
            stream: patientsQuery.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }

              final documents = snapshot.data!.docs;

              if (documents.isEmpty) {
                return const Center(
                  child: Text('No patients found.'),
                );
              }

              lastDocument = documents[documents.length - 1];

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(
                        label: Text('First Name',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Last Name',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Email',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Age',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Mobile',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Code',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Gender',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Address',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Medical History',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                  rows: documents.map((document) {
                    final patientData = document.data() as Map<String, dynamic>;
                    return DataRow(
                      cells: [
                        DataCell(Text(patientData['firstName'])),
                        DataCell(Text(patientData['lastName'])),
                        DataCell(Text(patientData['email'])),
                        DataCell(Text(patientData['age'])),
                        DataCell(Text(patientData['mobile'])),
                        DataCell(Text(patientData['code'])),
                        DataCell(Text(patientData['gender'])),
                        DataCell(Text(patientData['address'])),
                        DataCell(Text(patientData['medicalHistory'])),
                      ],
                    );
                  }).toList(),
                ),
              );
            },
          ),
          ElevatedButton(
            onPressed: loadMorePatients,
            child: Text('Load More'),
          ),
        ],
      ),
    );
  }
}
