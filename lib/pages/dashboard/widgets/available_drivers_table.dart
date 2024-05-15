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
  final ScrollController _scrollController = ScrollController();
  int currentPage = 1;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    patientsQuery = FirebaseFirestore.instance
        .collection('patients')
        .orderBy('code')
        .limit(itemsPerPage);
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    searchController.dispose();
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      loadMorePatients();
    }
  }

  void loadMorePatients() {
    if (lastDocument != null) {
      setState(() {
        currentPage++;
        patientsQuery = FirebaseFirestore.instance
            .collection('patients')
            .orderBy('code')
            .startAfterDocument(lastDocument!)
            .limit(itemsPerPage);
      });
    }
  }

  void goToPage(int page) {
    setState(() {
      currentPage = page;
      patientsQuery = FirebaseFirestore.instance
          .collection('patients')
          .orderBy('code')
          .limit(itemsPerPage * page);
    });
  }

  void showPatientDetailsDialog(
      BuildContext context, Map<String, dynamic> patientData) {
    showDialog(
      context: context,
      barrierDismissible:
          false, // Prevents closing the dialog by tapping outside
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async =>
              false, // Prevents closing the dialog with the back button
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              padding: EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Patient Details',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                    SizedBox(height: 20),
                   
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'First Name: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors
                                  .black, // Make sure to specify the color since default is white for TextSpan
                            ),
                          ),
                          TextSpan(
                            text: patientData['firstName'],
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.black, // Same here for color
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text('Last Name: ${patientData['lastName']}'),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'First Name: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors
                                  .black, // Make sure to specify the color since default is white for TextSpan
                            ),
                          ),
                          TextSpan(
                            text: patientData['firstName'],
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.black, // Same here for color
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text('Last Name: ${patientData['lastName']}'),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'First Name: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors
                                  .black, // Make sure to specify the color since default is white for TextSpan
                            ),
                          ),
                          TextSpan(
                            text: patientData['firstName'],
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.black, // Same here for color
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text('Last Name: ${patientData['lastName']}'),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'First Name: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors
                                  .black, // Make sure to specify the color since default is white for TextSpan
                            ),
                          ),
                          TextSpan(
                            text: patientData['firstName'],
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.black, // Same here for color
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text('Last Name: ${patientData['lastName']}'),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'First Name: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors
                                  .black, // Make sure to specify the color since default is white for TextSpan
                            ),
                          ),
                          TextSpan(
                            text: patientData['firstName'],
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.black, // Same here for color
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text('Last Name: ${patientData['lastName']}'),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'First Name: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors
                                  .black, // Make sure to specify the color since default is white for TextSpan
                            ),
                          ),
                          TextSpan(
                            text: patientData['firstName'],
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.black, // Same here for color
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text('Last Name: ${patientData['lastName']}'),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'First Name: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors
                                  .black, // Make sure to specify the color since default is white for TextSpan
                            ),
                          ),
                          TextSpan(
                            text: patientData['firstName'],
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.black, // Same here for color
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text('Last Name: ${patientData['lastName']}'),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'First Name: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors
                                  .black, // Make sure to specify the color since default is white for TextSpan
                            ),
                          ),
                          TextSpan(
                            text: patientData['firstName'],
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.black, // Same here for color
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text('Last Name: ${patientData['lastName']}'),
                    Text('Email: ${patientData['email']}'),
                    Text('Phone Number: ${patientData['phoneNumber']}'),
                    Text('Consultant: ${patientData['consultingDoctor']}'),
                    Text('Date of Appointment: ${patientData['date']}'),
                    Text('Symptoms: ${patientData['symptoms']}'),
                    Text('Note: ${patientData['note']}'),
                    SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Color(0XFFD50000))),
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(
                          'Close',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
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
                        DataCell(Text(patientData['firstName']),
                            onTap: () =>
                                showPatientDetailsDialog(context, patientData)),
                        DataCell(Text(patientData['lastName']),
                            onTap: () =>
                                showPatientDetailsDialog(context, patientData)),
                        DataCell(Text(patientData['email']),
                            onTap: () =>
                                showPatientDetailsDialog(context, patientData)),
                        DataCell(Text(patientData['age']),
                            onTap: () =>
                                showPatientDetailsDialog(context, patientData)),
                        DataCell(Text(patientData['mobile']),
                            onTap: () =>
                                showPatientDetailsDialog(context, patientData)),
                        DataCell(Text(patientData['code']),
                            onTap: () =>
                                showPatientDetailsDialog(context, patientData)),
                        DataCell(Text(patientData['gender']),
                            onTap: () =>
                                showPatientDetailsDialog(context, patientData)),
                        DataCell(Text(patientData['address']),
                            onTap: () =>
                                showPatientDetailsDialog(context, patientData)),
                        DataCell(Text(patientData['medicalHistory']),
                            onTap: () =>
                                showPatientDetailsDialog(context, patientData)),
                      ],
                    );
                  }).toList(),
                ),
              );
            },
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed:
                    currentPage > 1 ? () => goToPage(currentPage - 1) : null,
              ),
              for (int i = 1; i <= currentPage; i++)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextButton(
                    onPressed: () => goToPage(i),
                    child: Text(
                      i.toString(),
                      style: TextStyle(
                        color: i == currentPage ? Colors.blue : null,
                      ),
                    ),
                  ),
                ),
              IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: () => loadMorePatients(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
