import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:get/get.dart';
import 'package:hmsapp/constants/controllers.dart';
import 'package:hmsapp/helpers/responsiveness.dart';
import 'package:hmsapp/widgets/custom.dart';
import 'package:intl/intl.dart';

class BookingPage extends StatefulWidget {
  BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  TextEditingController authController = TextEditingController();
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController consultingController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController symptomController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  String? _patientDocumentId;

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp(); // Initialize Firebase
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

        // Store the document ID
        _patientDocumentId = querySnapshot.docs.first.id;

        // Update respective text form field controllers with patient details
        setState(() {
          firstnameController.text = patientData['firstName'] ?? '';
          lastnameController.text = patientData['lastName'] ?? '';
          phoneController.text = patientData['phoneNumber'] ?? '';
          emailController.text = patientData['email'] ?? '';
          phoneController.text = patientData['mobile'] ?? '';
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


  Future<void> updatePatientWithBooking() async {
    if (_patientDocumentId == null) {
      AwesomeDialog(
        context: context,
        animType: AnimType.scale,
        dialogType: DialogType.error,
        body: const Center(
          child: Text(
            'Patient not found, cannot update booking details',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        title: 'This is Ignored',
        desc: 'This is also Ignored',
        btnOkColor: Colors.deepPurple,
        btnOkOnPress: () {},
      ).show();
      return;
    }

    
    try {
      await FirebaseFirestore.instance
          .collection('patients')
          .doc(_patientDocumentId)
          .update({
        'bookings': FieldValue.arrayUnion([
          {
            'Auth': authController.text,
            'consultingDoctor': consultingController.text,
            'date': dateController.text,
            'symptoms': symptomController.text,
            'note': noteController.text,
            'Dateofappointment': Timestamp.now(),
          }
        ])
      });

      AwesomeDialog(
        context: context,
        animType: AnimType.scale,
        dialogType: DialogType.success,
        body: Center(
          child: Text(
            "Booking details added to patient successfully!",
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
    } catch (e) {
      // Show error snackbar if Firestore operation fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "Error: $e",
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
      );
    }
  }

Future<void> BookTime() async {
    // Function to validate if the TextFormField is empty
    bool validateFields() {
      return firstnameController.text.isNotEmpty &&
          authController.text.isNotEmpty &&
          lastnameController.text.isNotEmpty &&
          phoneController.text.isNotEmpty &&
          emailController.text.isNotEmpty &&
          consultingController.text.isNotEmpty &&
          dateController.text.isNotEmpty &&
          symptomController.text.isNotEmpty &&
          noteController.text.isNotEmpty;
    }

    if (!validateFields()) {
      // Show error dialog if any field is empty
      AwesomeDialog(
        context: context,
        animType: AnimType.scale,
        dialogType: DialogType.error,
        body: const Center(
          child: Text(
            'Complete the fields',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        title: 'This is Ignored',
        desc: 'This is also Ignored',
        btnOkColor: Colors.deepPurple,
        btnOkOnPress: () {},
      ).show();
    } else {
      try {
        // Update patient with booking details
        await updatePatientWithBooking();
      } catch (e) {
        // Show error snackbar if Firestore operation fails
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              "Error: $e",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
        );
      }
    }
  }




  void clearFields() {
    authController.clear();
    firstnameController.clear();
    lastnameController.clear();
    phoneController.clear();
    emailController.clear();
    consultingController.clear();
    dateController.clear();
    symptomController.clear();
    noteController.clear();
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
                    'Auth Code',
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
                    'First Name',
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
                        controller: firstnameController,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "First Name",
                            hintStyle: TextStyle(color: Colors.grey)),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Last Name',
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
                        controller: lastnameController,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Last Name",
                            hintStyle: TextStyle(color: Colors.grey)),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Email',
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
                        controller: emailController,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Email",
                            hintStyle: TextStyle(color: Colors.grey)),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Phone Number',
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
                        controller: phoneController,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Phone Number",
                            hintStyle: TextStyle(color: Colors.grey)),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Consultant',
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
                        controller: consultingController,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Consultant",
                            hintStyle: TextStyle(color: Colors.grey)),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Date of Appointment',
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
                        controller: dateController,
                        readOnly: true,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime(2101));
                          if (pickedDate != null) {
                            setState(() {
                              dateController.text =
                                  (DateFormat.yMMMMd()).format(pickedDate);
                            });
                          }
                        },
                        decoration: const InputDecoration(
                            prefixIcon: Icon(
                              Icons.calendar_month,
                              color: Colors.deepPurple,
                            ),
                            border: InputBorder.none,
                            hintText: "Date of Birth",
                            hintStyle: TextStyle(color: Colors.grey)),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Symptoms',
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
                        controller: symptomController,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Symptoms",
                            hintStyle: TextStyle(color: Colors.grey)),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Note',
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
                        maxLines: 6,
                        controller: noteController,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Note",
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
                      BookTime();
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
