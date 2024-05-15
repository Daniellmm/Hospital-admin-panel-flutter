import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:hmsapp/constants/controllers.dart';
import 'package:hmsapp/helpers/responsiveness.dart';
import 'package:hmsapp/widgets/custom.dart';

class PharmacyPage extends StatefulWidget {
  const PharmacyPage({super.key});

  @override
  State<PharmacyPage> createState() => _PharmacyPageState();
}

class _PharmacyPageState extends State<PharmacyPage> {
  TextEditingController fullnameController = TextEditingController();
  TextEditingController authController = TextEditingController();
  TextEditingController prescriptionController = TextEditingController();
  Stream<DocumentSnapshot>? patientStream;

  // Function to validate if the TextFormField is empty
  bool validateFields() {
    return fullnameController.text.isNotEmpty &&
        authController.text.isNotEmpty &&
        prescriptionController.text.isNotEmpty;
    // Controller.text.isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().then((_) {
      // Initialize Firebase
      print('Firebase initialized');
    }).catchError((error) {
      print('Failed to initialize Firebase: $error');
    });
  }

  Timer? _debounce;

  void _onAuthCodeChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 700), () {
      fetchPatientDetails(value); // Fetch details after delay
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void fetchPatientDetails(String authCode) async {
    try {
      // Query Firestore to get the patient details based on the auth code
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('patients')
          .where('code', isEqualTo: authCode)
          .get();

      // Check if any matching patient record found
      if (querySnapshot.docs.isNotEmpty) {
        // Retrieve the auth codes
        var patientData =
            querySnapshot.docs.first.data() as Map<String, dynamic>;

        // Update respective text form field controllers with patient details
        setState(() {
          String firstName = patientData['firstName'] ?? '';
          String lastName = patientData['lastName'] ?? '';
          fullnameController.text = '$firstName $lastName';
        });
      } else {
        // Clear text form field controllers if no matching patient record found
        clearFields();
      }
    } catch (e) {
      AwesomeDialog(
        context: context,
        animType: AnimType.scale,
        dialogType: DialogType.error,
        body: const Center(
          child: Text(
            'Error while fetching patient details',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        title: 'This is Ignored',
        desc: 'This is also Ignored',
        btnOkColor: Colors.deepPurple,
        btnOkOnPress: () {},
      ).show();
      // Handle errors, such as Firestore query failures
      // print("Error fetching patient details: $e");
    }
  }

  // Save data to Firestore
  Future<void> saveData() async {
    if (!validateFields()) {
      AwesomeDialog(
        context: context,
        animType: AnimType.scale,
        dialogType: DialogType.error,
        body: const Center(
          child: Text(
            'Compelete the fields',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        title: 'This is Ignored',
        desc: 'This is also Ignored',
        btnOkColor: Colors.deepPurple,
        btnOkOnPress: () {},
      ).show();
    } else {
      CollectionReference pharmacy =
          FirebaseFirestore.instance.collection('pharmacy');

      try {
        await pharmacy.add({
          'fullName': fullnameController.text,
          'Authentication code': authController.text,
          'Drugs Prescriptions': prescriptionController.text,
          'Date': Timestamp.now(),
        });
        AwesomeDialog(
          // ignore: use_build_context_synchronously
          context: context,
          animType: AnimType.scale,
          dialogType: DialogType.success,
          body: const Center(
            child: Text(
              "Information saved Proceed to Payment",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          title: 'This is Ignored',
          desc: 'This is also Ignored',
          btnOkColor: Colors.deepPurple,
          btnOkOnPress: () {
            clearFields();
          },
        ).show();
        // Show toast message with generated cod
        // Toast.show("Generated Code: $generatedCode", );
      } catch (e) {
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            "",
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        );
      }
    }
  }

// Function to clear all text fields
  void clearFields() {
    fullnameController.clear();
    authController.clear();
    prescriptionController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(
          () => Row(
            children: [
              Container(
                  margin: EdgeInsets.only(
                      top: ResponsiveWidget.isSmallScreen(context) ? 56 : 6,
                      left: 10),
                  child: CustomText(
                    text: menuControllers.activeItem.value,
                    size: 24,
                    weight: FontWeight.bold,
                  )),
            ],
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(20),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Auth Number',
                    style: TextStyle(fontSize: 25),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 20, top: 5, bottom: 5),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.deepPurple),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: TextFormField(
                        controller: authController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Auth Code",
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        onChanged: (value) {
                          _onAuthCodeChanged(
                              value); // Fetch details when code changes
                        },
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Full Name',
                    style: TextStyle(fontSize: 25),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 20, top: 5, bottom: 5),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.deepPurple),
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: TextFormField(
                        readOnly: true,
                        controller: fullnameController,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Full Name ",
                            hintStyle: TextStyle(color: Colors.grey)),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  const Text(
                    'Prescriptions',
                    style: TextStyle(fontSize: 25),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 20, top: 5, bottom: 5),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.deepPurple),
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: TextFormField(
                        maxLines: 4,
                        controller: prescriptionController,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Prescriptions",
                            hintStyle: TextStyle(color: Colors.grey)),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Total Amount',
                    style: TextStyle(fontSize: 25),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 20, top: 5, bottom: 5),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.deepPurple),
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: TextFormField(
                        maxLines: 3,
                        // controller: noteController,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Total Amount",
                            hintStyle: TextStyle(color: Colors.grey)),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const SizedBox(height: 10),
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: () {
                      saveData();
                    },
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.deepPurple),
                      child: const Center(
                        child: Text(
                          'Add',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 35,
                  ),

                  // const Text(
                  //   ' ',
                  //   style: TextStyle(fontSize: 25),
                  // ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
