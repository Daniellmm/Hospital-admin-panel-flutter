import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart' as pw;

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

    CollectionReference payments =
        FirebaseFirestore.instance.collection('Payments');

    try {
      await payments.add({
        'FullName': fullnameController.text,
        'AuthenticationCode': authController.text,
        'RegistrationFees': registrationController.text,
        'Appointmentfees': appointmentController.text,
        'ConsultationFees':
            consultationController.text, // Fixed field name typo
        'Totalbills': totalController.text,
        'paymentDate': Timestamp.now(),
      });

      AwesomeDialog(
        context: context,
        animType: AnimType.scale,
        dialogType: DialogType.success,
        body: Center(
          child: Text(
            "Payment Record Saved Successfully",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        title: 'This is Ignored',
        desc: 'This is also Ignored',
        btnOkColor: Colors.deepPurple,
        btnOkOnPress: () {
          // clearFields();
        },
      ).show();
    } catch (e) {
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


  void clearFields() {
    fullnameController.clear();
    authController.clear();
    registrationController.clear();
    appointmentController.clear();
    consultationController.clear();
    totalController.clear();
  }

  // Future<void> _printReceipt(BuildContext context) async {
  //   final doc = pw.Document();

  //   doc.addPage(
  //     pw.Page(
  //       build: (pw.Context context) {
  //         return pw.Container(
  //           child: pw.Column(
  //             children: [
  //               pw.Text('Registration Fees: ${registrationController.text}'),
  //               pw.Text('Appointment Fees: ${appointmentController.text}'),
  //               pw.Text('Consultation Fees: ${consultationController.text}'),
  //               pw.Text('Total Amount: ${totalController.text}'),
  //             ],
  //           ),
  //         );
  //       },
  //     ),
  //   );

  //   await Printing.layoutPdf(
  //     onLayout: (pw.PageFormat format) async => doc.save(),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            const Text(
              'Full Name',
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.only(left: 20, top: 5, bottom: 5),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.deepPurple),
                  borderRadius: BorderRadius.circular(10)),
              child: Center(
                child: TextFormField(
                  controller: fullnameController,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Full Name",
                      hintStyle: TextStyle(color: Colors.grey)),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Auth Code',
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.only(left: 20, top: 5, bottom: 5),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.deepPurple),
                  borderRadius: BorderRadius.circular(10)),
              child: Center(
                child: TextFormField(
                  controller: authController,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Auth code",
                      hintStyle: TextStyle(color: Colors.grey)),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Registration Fees',
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: registrationController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Registration Fees',
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Appointment Fees',
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: appointmentController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Appointment Fees',
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Consultation Fees',
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: consultationController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Consultation Fees',
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Total Bill',
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: totalController,
              readOnly: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Total Bill',
              ),
            ),
            SizedBox(height: 20,),
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
            SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                // saveData();
              },
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.greenAccent),
                child: const Center(
                  child: Text(
                    'Download',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                clearFields();
              },
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
