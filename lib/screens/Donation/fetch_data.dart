import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:project/screens/Donation/update_record.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project/screens/Authentication/home_page.dart';

class FetchDonationData extends StatefulWidget {
  const FetchDonationData({Key? key}) : super(key: key);

  @override
  State<FetchDonationData> createState() => _FetchDonationDataState();
}

class _FetchDonationDataState extends State<FetchDonationData> {
  Query dbRef = FirebaseDatabase.instance.ref().child('Donations');
  DatabaseReference reference =
      FirebaseDatabase.instance.ref().child('Donations');

  final TextEditingController _searchController = TextEditingController();
  late Query _searchQuery;
  List<Map> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _searchQuery = dbRef;
  }

  Widget listItem({required Map donation}) {
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
            'Item Name: ${donation['Item_Name']}',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            'Item Type: ${donation['Item_Type']}',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            'Donation Date: ${donation['Date']}',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            'Amount: Rs. ${donation['Amount']}',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            'Item Description: ${donation['Description']}',
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
                          builder: (_) => UpdateDonationData(
                              donationKey: donation['key'])));
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
                            reference.child(donation['key']).remove();
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
                          child: const Text('Yes'),
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
                  hintText: "Search Donation By Item Name",
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchResults = [];
                    if (value.isNotEmpty) {
                      _searchQuery = dbRef
                          .orderByChild('Item_Name')
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
                  Map donation = snapshot.value as Map;
                  donation['key'] = snapshot.key;
                  if (_searchController.text.isNotEmpty &&
                      !donation['Item_Name']
                          .toLowerCase()
                          .contains(_searchController.text.toLowerCase())) {
                    return Container();
                  }
                  // Add the filtered volunteer to the search results list
                  _searchResults.add(donation);
                  return listItem(donation: donation);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
