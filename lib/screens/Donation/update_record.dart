import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:project/screens/Donation/fetch_data.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project/screens/Authentication/home_page.dart';

class UpdateDonationData extends StatefulWidget {
  const UpdateDonationData({Key? key, required this.donationKey})
      : super(key: key);

  final String donationKey;

  @override
  State<UpdateDonationData> createState() => _UpdateDonationDataState();
}

class _UpdateDonationDataState extends State<UpdateDonationData> {
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
    getDonationData();
  }

  void getDonationData() async {
    DataSnapshot snapshot = await dbRef.child(widget.donationKey).get();

    Map donation = snapshot.value as Map;

    itemNameController.text = donation['Item_Name'];
    itemTypeController.text = donation['Item_Type'];
    dateController.text = donation['Date'];
    amountController.text = donation['Amount'];
    descriptionController.text = donation['Description'];
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
                'Update Donation Details',
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
                  labelText: 'Item Type',
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
                            dbRef.child(widget.donationKey).update(donations);
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
                                      const FetchDonationData()),
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
                child: const Text('Update Data'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
