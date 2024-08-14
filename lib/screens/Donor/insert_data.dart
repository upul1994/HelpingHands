import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:project/screens/Donor/dashboard.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project/screens/Authentication/home_page.dart';

class InsertData extends StatefulWidget {
  const InsertData({Key? key}) : super(key: key);

  @override
  State<InsertData> createState() => _InsertDataState();
}

class _InsertDataState extends State<InsertData> {
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final emailController = TextEditingController();
  final nicController = TextEditingController();
  final phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late DatabaseReference dbRef;

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref().child('Donors');
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
                'Insert Donor Details',
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
                controller: nameController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Donor Name *',
                  hintText: 'Enter Donor Name',
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
                controller: addressController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Donor Address *',
                  hintText: 'Enter Donor Address',
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
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Donor Email *',
                  hintText: 'Enter Donor Email',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "This field is required";
                  } else if (!value.contains('@')) {
                    return "Please enter a valid email";
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: nicController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Donor NIC *',
                  hintText: 'Enter Donor NIC',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "This field is required";
                  } else if (value.length < 10) {
                    return "Please enter a valid NIC number";
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Donor Phone Number *',
                  hintText: 'Enter Donor Phone Number',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "This field is required";
                  } else if (value.length < 10) {
                    return "Please enter a valid phone number";
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(
                height: 20,
              ),
              MaterialButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Map<String, String> donors = {
                      'Donor_Name': nameController.text,
                      'Donor_Address': addressController.text,
                      'Donor_Email': emailController.text,
                      'Donor_Nic': nicController.text,
                      'Donor_Phone': phoneController.text,
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
                              dbRef.push().set(donors);

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
                                        const DonorHomePage()),
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
