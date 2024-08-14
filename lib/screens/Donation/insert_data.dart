// ignore_for_file: depend_on_referenced_packages

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:project/screens/Donation/dashboard.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project/screens/Authentication/home_page.dart';
import 'package:intl/intl.dart';

class InsertDonationData extends StatefulWidget {
  const InsertDonationData({Key? key}) : super(key: key);

  @override
  State<InsertDonationData> createState() => _InsertDonationDataState();
}

class _InsertDonationDataState extends State<InsertDonationData> {
  final itemNameController = TextEditingController();
  final itemTypeController = TextEditingController();
  final dateController = TextEditingController();
  final amountController = TextEditingController();
  final descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late DatabaseReference dbRef;

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref().child('Donations');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          title: GestureDetector(
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              )
            },
            child: const Text('Helping Hands',
                style: TextStyle(color: Colors.white)),
          ),
          backgroundColor: const Color.fromARGB(255, 50, 182, 230)),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Text(
                'Insert Donation Details',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: itemNameController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Item Name *',
                  hintText: 'Enter Item Name',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "This field is required";
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: itemTypeController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Item Type *',
                  hintText: 'Enter Item Type',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "This field is required";
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: dateController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Donation Date *',
                  hintText: 'Enter Donation Date',
                ),
                onTap: () async {
                  DateTime? pickeddate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101));

                  if (pickeddate != null) {
                    setState(() {
                      dateController.text =
                          DateFormat('yyyy-MM-dd').format(pickeddate);
                    });
                  }
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return "This field is required";
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: amountController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Item Amount *',
                  hintText: 'Enter Item Amount',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "This field is required";
                  } else if (double.parse(value) <= 0) {
                    return "Amount should be greater than 0";
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: descriptionController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Item Description',
                  hintText: 'Enter Item Description',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              MaterialButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Map<String, String> donations = {
                      'Item_Name': itemNameController.text,
                      'Item_Type': itemTypeController.text,
                      'Date': dateController.text,
                      'Amount': amountController.text,
                      'Description': descriptionController.text
                    };

                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('No'),
                          ),
                          TextButton(
                            onPressed: () {
                              dbRef.push().set(donations);
                              Fluttertoast.showToast(
                                msg: "Data Added Successfully!",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 5,
                                backgroundColor: Colors.grey,
                                textColor: Colors.black,
                                fontSize: 15,
                              );
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const DonationHomePage()),
                              );
                            },
                            child: const Text('Yes'),
                          ),
                        ],
                        title: const Text('Alert'),
                        contentPadding: const EdgeInsets.all(20.0),
                        content: const Text('Do You Want to Insert Data ?'),
                      ),
                    );
                  }
                },
                color: Colors.blue,
                textColor: Colors.white,
                minWidth: 300,
                height: 40,
                child: const Text('Insert Data'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
