import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:hmsapp/widgets/custom.dart';

class AvailableDriversTable extends StatefulWidget {
  const AvailableDriversTable({Key? key}) : super(key: key);

  @override
  State<AvailableDriversTable> createState() => _AvailableDriversTableState();
}

class _AvailableDriversTableState extends State<AvailableDriversTable> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('patients').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
         return const Text("Loading...");
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Error fetching data'));
        }
        if (snapshot.connectionState == ConnectionState.none) {
          return const Text("Not available");
        }

        final patients = snapshot.data?.docs.reversed.toList();

        // Print fetched data to console
        patients?.forEach((patient) {
          final data = patient.data() as Map<String, dynamic>;
          print(data);
        });

        return SizedBox();
        //   return Expanded(
        //     child: ListView.builder(
        //     itemCount: patients?.length ?? 0,
        //     itemBuilder: (context, index) {
        //       final data = patients![index].data() as Map<String, dynamic>;
        //       return Expanded(
        //         child: ListTile(
        //           title: Text(
        //             'Patient: ${data['name']}',
        //             style: TextStyle(color: Colors.black), // Change color to black
        //           ),
        //           subtitle: Text(
        //             'Age: ${data['age']}, Gender: ${data['gender']}',
        //             style: TextStyle(color: Colors.black), // Change color to black
        //           ),
        //         ),
        //       );
        //     },
        //             ),
        //   );
        //  // Return an empty SizedBox since we're printing data to console only
      },
    );
 
  }
}
