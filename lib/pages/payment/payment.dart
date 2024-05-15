import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';


class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  TextEditingController fullnameController = TextEditingController();
  TextEditingController authController = TextEditingController();
  TextEditingController registrationController = TextEditingController();
  TextEditingController appointmentController = TextEditingController();
  TextEditingController consultationController = TextEditingController();
  TextEditingController totalController = TextEditingController();
  String? _patientDocumentId;

  bool validateFields() {
    return registrationController.text.isNotEmpty &&
        fullnameController.text.isNotEmpty &&
        authController.text.isNotEmpty &&
        appointmentController.text.isNotEmpty &&
        consultationController.text.isNotEmpty &&
        totalController.text.isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().then((_) {
      registrationController.addListener(updateTotal);
      appointmentController.addListener(updateTotal);
      consultationController.addListener(updateTotal);
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
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('patients')
          .where('code', isEqualTo: authCode)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var patientData =
            querySnapshot.docs.first.data() as Map<String, dynamic>;
        _patientDocumentId = querySnapshot.docs.first.id;

        setState(() {
          String firstName = patientData['firstName'] ?? '';
          String lastName = patientData['lastName'] ?? '';
          fullnameController.text = '$firstName $lastName';
        });
      } else {
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
    }
  }

  void updateTotal() {
    double registration = double.tryParse(registrationController.text) ?? 0;
    double appointment = double.tryParse(appointmentController.text) ?? 0;
    double consultation = double.tryParse(consultationController.text) ?? 0;

    double total = registration + appointment + consultation;

    setState(() {
      totalController.text = total.toStringAsFixed(2);
    });
  }

  Future<void> saveData() async {
    if (!validateFields()) {
      AwesomeDialog(
        context: context,
        animType: AnimType.scale,
        dialogType: DialogType.error,
        body: const Center(
          child: Text(
            'Check Fields',
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
      if (_patientDocumentId != null) {
        await FirebaseFirestore.instance
            .collection('patients')
            .doc(_patientDocumentId)
            .update({
          'payments': FieldValue.arrayUnion([
            {
              'RegistrationFees': registrationController.text,
              'Appointmentfees': appointmentController.text,
              'ConsultationFees': consultationController.text,
              'Totalbills': totalController.text,
              'paymentDate': Timestamp.now(),
            }
          ])
        });
      }

      AwesomeDialog(
        context: context,
        animType: AnimType.scale,
        dialogType: DialogType.success,
        body: const Center(
          child: Text(
            "Payment Record Saved Successfully",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        title: 'This is Ignored',
        desc: 'This is also Ignored',
        btnOkColor: Colors.deepPurple,
        btnOkOnPress: () {},
      ).show();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "Error: $e",
            style: const TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
      );
    }
  }

  void clearFields() {
    fullnameController.clear();
    authController.clear();
    registrationController.clear();
    appointmentController.clear();
    consultationController.clear();
    totalController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            const Text('Auth Code', style: TextStyle(fontSize: 15)),
            const SizedBox(height: 10),
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
                    _onAuthCodeChanged(value);
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Full Name', style: TextStyle(fontSize: 15)),
            const SizedBox(height: 10),
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
                      hintText: "Full Name",
                      hintStyle: TextStyle(color: Colors.grey)),
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text('Registration Fees', style: TextStyle(fontSize: 15)),
            const SizedBox(height: 10),
            TextFormField(
              controller: registrationController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Registration Fees',
                  prefixText: '₦',
                  prefixStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 20),
            const Text('Appointment Fees', style: TextStyle(fontSize: 15)),
            const SizedBox(height: 10),
            TextFormField(
              controller: appointmentController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Appointment Fees in naira',
                  prefixText: '₦',
                  prefixStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 20),
            const Text('Consultation Fees', style: TextStyle(fontSize: 15)),
            const SizedBox(height: 10),
            TextFormField(
              controller: consultationController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Consultation Fees',
                  prefixText: '₦',
                  prefixStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 20),
            const Text('Total Bill', style: TextStyle(fontSize: 15)),
            const SizedBox(height: 10),
            TextFormField(
              controller: totalController,
              readOnly: true,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Total Bill',
                  prefixText: '₦',
                  prefixStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: saveData,
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
            // const SizedBox(height: 20),
            // InkWell(
            //   onTap: () {},
            //   child: Container(
            //     height: 50,
            //     width: MediaQuery.of(context).size.width,
            //     decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(10),
            //         color: Colors.greenAccent),
            //     child: const Center(
            //       child: Text(
            //         'Download',
            //         style: TextStyle(
            //             fontSize: 20,
            //             fontWeight: FontWeight.bold,
            //             color: Colors.white),
            //       ),
            //     ),
            //   ),
            // ),
            const SizedBox(height: 20),
            InkWell(
              onTap: clearFields,
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.redAccent),
                child: const Center(
                  child: Text(
                    'Clear',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
