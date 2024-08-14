import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:project/screens/Beneficiary/update_record.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project/screens/Authentication/home_page.dart';

class FetchData extends StatefulWidget {
  const FetchData({Key? key}) : super(key: key);

  @override
  State<FetchData> createState() => _FetchDataState();
}

class _FetchDataState extends State<FetchData> {
  Query dbRef = FirebaseDatabase.instance.ref().child('Beneficiaries');
  DatabaseReference reference =
      FirebaseDatabase.instance.ref().child('Beneficiaries');

  final TextEditingController _searchController = TextEditingController();
  late Query _searchQuery;
  List<Map> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _searchQuery = dbRef;
  }

  Widget listItem({required Map beneficiary}) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.amberAccent, borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Beneficiary Name: ${beneficiary['Beneficiary_Name']}',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            'Beneficiary Address: ${beneficiary['Beneficiary_Address']}',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            'Beneficiary Email: ${beneficiary['Beneficiary_Email']}',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            'Beneficiary Phone: ${beneficiary['Beneficiary_Phone']}',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            'Beneficiary Description: ${beneficiary['Beneficiary_Description']}',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => UpdateRecord(
                              beneficiaryKey: beneficiary['key'])));
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.edit,
                      color: Theme.of(context).primaryColor,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 6,
              ),
              GestureDetector(
                onTap: () {
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
                            reference.child(beneficiary['key']).remove();
                            Navigator.of(context).pop();

                            Fluttertoast.showToast(
                              msg: "Data Deleted Successfully!",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 5,
                              backgroundColor: Colors.grey,
                              textColor: Colors.black,
                              fontSize: 15,
                            );
                          },
                          child: Text('Yes'),
                        ),
                      ],
                      title: const Text('Alert'),
                      contentPadding: const EdgeInsets.all(20.0),
                      content: const Text('Do You Want to Delete Data ?'),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.delete,
                      color: Colors.red[700],
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(10),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.black,
                    size: 20,
                  ),
                  prefixIconConstraints:
                      BoxConstraints(maxHeight: 20, minWidth: 25),
                  hintText: "Search Beneficiary Details By Name",
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchResults = [];
                    if (value.isNotEmpty) {
                      _searchQuery = dbRef
                          .orderByChild('Beneficiary_Name')
                          .startAt(value.toLowerCase())
                          .endAt(value.toLowerCase());
                    } else {
                      _searchQuery = dbRef;
                    }
                  });
                },
              ),
            ),
            Expanded(
              child: FirebaseAnimatedList(
                query: _searchQuery,
                itemBuilder: (BuildContext context, DataSnapshot snapshot,
                    Animation<double> animation, int index) {
                  Map beneficiary = snapshot.value as Map;
                  beneficiary['key'] = snapshot.key;
                  if (_searchController.text.isNotEmpty &&
                      !beneficiary['Beneficiary_Name']
                          .toLowerCase()
                          .contains(_searchController.text.toLowerCase())) {
                    return Container();
                  }
                  // Add the filtered volunteer to the search results list
                  _searchResults.add(beneficiary);
                  return listItem(beneficiary: beneficiary);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
