import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:project/screens/Beneficiary/fetch_data.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project/screens/Authentication/home_page.dart';

class UpdateRecord extends StatefulWidget {
  const UpdateRecord({Key? key, required this.beneficiaryKey})
      : super(key: key);

  final String beneficiaryKey;

  @override
  State<UpdateRecord> createState() => _UpdateRecordState();
}

class _UpdateRecordState extends State<UpdateRecord> {
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late DatabaseReference dbRef;

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref().child('Beneficiaries');
    getBeneficiaryData();
  }

  void getBeneficiaryData() async {
    DataSnapshot snapshot = await dbRef.child(widget.beneficiaryKey).get();

    Map item = snapshot.value as Map;

    nameController.text = item['Beneficiary_Name'];
    addressController.text = item['Beneficiary_Address'];
    emailController.text = item['Beneficiary_Email'];
    phoneController.text = item['Beneficiary_Phone'];
    descriptionController.text = item['Beneficiary_Description'];
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
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Update Beneficiary Details',
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
                  labelText: 'Beneficiary Name *',
                  hintText: 'Enter Beneficiary Name',
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
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Beneficiary Address *',
                  hintText: 'Enter Beneficiary Address',
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
                  labelText: 'Beneficiary Email Address *',
                  hintText: 'Enter Beneficiary Email Address',
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
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Beneficiary Phone Number *',
                  hintText: 'Enter Beneficiary Phone Number',
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
              TextFormField(
                controller: descriptionController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Beneficiary Description',
                  hintText: 'Enter Beneficiary Description',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              MaterialButton(
                  onPressed: () {
                    Map<String, String> beneficiaries = {
                      'Beneficiary_Name': nameController.text,
                      'Beneficiary_Address': addressController.text,
                      'Beneficiary_Email': emailController.text,
                      'Beneficiary_Phone': phoneController.text,
                      'Beneficiary_Description': descriptionController.text
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
                              dbRef
                                  .child(widget.beneficiaryKey)
                                  .update(beneficiaries);

                              Fluttertoast.showToast(
                                msg: "Data Updated Successfully!",
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
                                    builder: (context) => FetchData()),
                              );
                            },
                            child: const Text('Yes'),
                          ),
                        ],
                        title: const Text('Alert'),
                        contentPadding: const EdgeInsets.all(20.0),
                        content: const Text('Do You Want to Update Data ?'),
                      ),
                    );
                  },
                  color: Colors.blue,
                  textColor: Colors.white,
                  minWidth: 300,
                  height: 40,
                  child: const Text('Update Data')),
            ],
          ),
        ),
      ),
    );
  }
}
