import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:project/screens/Volunteer/fetch_data.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project/screens/Authentication/home_page.dart';

class UpdateVolunteer extends StatefulWidget {
  const UpdateVolunteer({Key? key, required this.volunteerKey})
      : super(key: key);

  final String volunteerKey;

  @override
  State<UpdateVolunteer> createState() => _UpdateVolunteerState();
}

class _UpdateVolunteerState extends State<UpdateVolunteer> {
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
    dbRef = FirebaseDatabase.instance.ref().child('Volunteers');
    getVolunteerData();
  }

  void getVolunteerData() async {
    DataSnapshot snapshot = await dbRef.child(widget.volunteerKey).get();

    Map item = snapshot.value as Map;

    nameController.text = item['Volunteer_Name'];
    addressController.text = item['Volunteer_Address'];
    emailController.text = item['Volunteer_Email'];
    nicController.text = item['Volunteer_Nic'];
    phoneController.text = item['Volunteer_Phone'];
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
        body: ListView(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Update Volunteer Details',
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
                          labelText: 'Volunteer Name *',
                          hintText: 'Enter Volunteer Name',
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
                          labelText: 'Volunteer Address *',
                          hintText: 'Enter Volunteer Address',
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
                          labelText: 'Volunteer Email *',
                          hintText: 'Enter Volunteer Email',
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
                          labelText: 'Volunteer NIC *',
                          hintText: 'Enter Volunteer NIC',
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
                          labelText: 'Volunteer Phone Number *',
                          hintText: 'Enter Volunteer Phone Number',
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
                            Map<String, String> volunteers = {
                              'Volunteer_Name': nameController.text,
                              'Volunteer_Address': addressController.text,
                              'Volunteer_Email': emailController.text,
                              'Volunteer_Nic': nicController.text,
                              'Volunteer_Phone': phoneController.text,
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
                                          .child(widget.volunteerKey)
                                          .update(volunteers);
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
                                            builder: (context) =>
                                                const FetchVolunteer()),
                                      );
                                    },
                                    child: const Text('Yes'),
                                  ),
                                ],
                                title: const Text('Alert'),
                                contentPadding: const EdgeInsets.all(20.0),
                                content:
                                    const Text('Do You Want to Update Data ?'),
                              ),
                            );
                          }
                        },
                        color: Colors.blue,
                        textColor: Colors.white,
                        minWidth: 300,
                        height: 40,
                        child: const Text('Update Data'),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
