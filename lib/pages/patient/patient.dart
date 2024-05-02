import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hmsapp/constants/controllers.dart';
import 'package:hmsapp/helpers/responsiveness.dart';
import 'package:hmsapp/widgets/custom.dart';
import 'package:intl/intl.dart';

class PatientPage extends StatefulWidget {
  PatientPage({super.key});

  @override
  State<PatientPage> createState() => _PatientPageState();
}

class _PatientPageState extends State<PatientPage> {
  String genderValue = 'Male';
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController additionalinfoController = TextEditingController();
  TextEditingController conditionController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController medicalhistoryController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  String generatedCode = '';


   // Function to validate if the TextFormField is empty
  bool validateFields() {
    return firstnameController.text.isNotEmpty &&
        lastnameController.text.isNotEmpty &&
        mobileController.text.isNotEmpty &&
        ageController.text.isNotEmpty &&
        additionalinfoController.text.isNotEmpty &&
        conditionController.text.isNotEmpty &&
        addressController.text.isNotEmpty &&
        medicalhistoryController.text.isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp(); // Initialize Firebase
  }

  int serialNumber = 1; // Initial serial number

  void generateCode() { 
    if (validateFields()){
      String newCode = serialNumber
          .toString()
          .padLeft(4, '0'); // Format serial number as a four-digit string
      if (serialNumber <= 9999) {
        setState(() {
          generatedCode = newCode;
          codeController.text = generatedCode;
        });
        serialNumber++; // Increment serial number for the next code
      } else {
        // Handle the case when the serial number exceeds 9999 (optional)
        AwesomeDialog(
          context: context,
          animType: AnimType.scale,
          dialogType: DialogType.info,
          body: const Center(
            child: Text(
              "The code has reached it's limit",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          title: 'This is Ignored',
          desc: 'This is also Ignored',
          btnOkColor: Colors.deepPurple,
          btnOkOnPress: () {},
        ).show();
      }
    }else{
      return null;
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
      CollectionReference patients =
          FirebaseFirestore.instance.collection('patients');

      try {
        await patients.add({
          'firstName': firstnameController.text,
          'lastName': lastnameController.text,
          'gender': genderValue,
          'age': ageController.text,
          'mobile': mobileController.text,
          'additionalInfo': additionalinfoController.text,
          'condition': conditionController.text,
          'address': addressController.text,
          'medicalHistory': medicalhistoryController.text,
          'code': generatedCode,
        });
        AwesomeDialog(
          context: context,
          animType: AnimType.scale,
          dialogType: DialogType.success,
          body: Center(
            child: Text(
              "User Info saved successfully and Your Authetication code is " +
                  generatedCode,
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
        SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            "Generated Code: $generatedCode",
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        );
      }
    }
  }

// Function to clear all text fields
  void clearFields() {
    firstnameController.clear();
    lastnameController.clear();
    mobileController.clear();
    additionalinfoController.clear();
    conditionController.clear();
    addressController.clear();
    medicalhistoryController.clear();
    ageController.clear();
    codeController.clear();
    dateController.clear;
    setState(() {
      generatedCode = ''; // Clear the generated code as well
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
                  const Text(
                    'Gender',
                    style: TextStyle(fontSize: 25),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.deepPurple),
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.transparent),
                    child: DropdownButton<String>(
                      value: genderValue,
                      onChanged: (String? newValue) {
                        setState(() {
                          genderValue = newValue!;
                        });
                      },
                      items: <String>['Male', 'Female']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Age',
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
                        controller: ageController,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Age",
                            hintStyle: TextStyle(color: Colors.grey)),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Mobile number',
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
                        controller: mobileController,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Mobile Number",
                            hintStyle: TextStyle(color: Colors.grey)),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Date of Birth',
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
                  // const Text(
                  //   'Blood Group',
                  //   style: TextStyle(fontSize: 25),
                  // ),
                  // const SizedBox(
                  //   height: 20,
                  // ),
                  // Container(
                  //   padding: const EdgeInsets.all(8),
                  //   width: MediaQuery.of(context).size.width,
                  //   decoration: BoxDecoration(
                  //       border: Border.all(color: Colors.deepPurple),
                  //       borderRadius: BorderRadius.circular(10),
                  //       color: Colors.transparent),
                  //   child: DropdownButton<String>(
                  //     value: dropdownValue2,
                  //     onChanged: (String? newValue) {
                  //       setState(() {
                  //         dropdownValue2 = newValue!;
                  //       });
                  //     },
                  //     items: <String>[
                  //       'A+',
                  //       'A-',
                  //       'B+',
                  //       'B-',
                  //       'AB+',
                  //       'AB-',
                  //       'O+',
                  //       'O-',
                  //     ].map<DropdownMenuItem<String>>((String value) {
                  //       return DropdownMenuItem<String>(
                  //         value: value,
                  //         child: Text(value),
                  //       );
                  //     }).toList(),
                  //   ),
                  // ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Addtional Info',
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
                        controller: additionalinfoController,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Addtional Info",
                            hintStyle: TextStyle(color: Colors.grey)),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Injury/Condition',
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
                        controller: conditionController,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Injury/Condition",
                            hintStyle: TextStyle(color: Colors.grey)),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Address',
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
                        controller: addressController,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Address ",
                            hintStyle: TextStyle(color: Colors.grey)),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Medical History',
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
                        controller: medicalhistoryController,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Medical History",
                            hintStyle: TextStyle(color: Colors.grey)),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      generateCode();
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
                    height: 10,
                  ),
                  const Text(
                    'Generated Code',
                    style: TextStyle(fontSize: 25),
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
                        controller: codeController,
                        readOnly: true, // make it read-only
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Authentication Code",
                            hintStyle: TextStyle(color: Colors.grey)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class LENGTH_LONG {}
