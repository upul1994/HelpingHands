import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:project/screens/Volunteer/update_record.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project/screens/Authentication/home_page.dart';

class FetchVolunteer extends StatefulWidget {
  const FetchVolunteer({Key? key}) : super(key: key);

  @override
  State<FetchVolunteer> createState() => _FetchVolunteerState();
}

class _FetchVolunteerState extends State<FetchVolunteer> {
  Query dbRef = FirebaseDatabase.instance.ref().child('Volunteers');
  DatabaseReference reference =
      FirebaseDatabase.instance.ref().child('Volunteers');

  final TextEditingController _searchController = TextEditingController();
  late Query _searchQuery;
  List<Map> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _searchQuery = dbRef;
  }

  Widget listItem({required Map volunteer}) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 10,
              backgroundColor: Colors.transparent,
              child: Container(
                constraints:
                    const BoxConstraints(maxHeight: 250, maxWidth: 400),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${volunteer['Volunteer_Name']}\'s Details',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Volunteer Address: ${volunteer['Volunteer_Address']}',
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Volunteer Email: ${volunteer['Volunteer_Email']}',
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Volunteer Nic: ${maskNic(volunteer['Volunteer_Nic'])}',
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Volunteer Phone: ${volunteer['Volunteer_Phone']}',
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            'Close',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      child: Container(
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.amberAccent,
              borderRadius: BorderRadius.circular(10)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Volunteer Name: ${volunteer['Volunteer_Name']}',
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Volunteer Address: ${volunteer['Volunteer_Address']}',
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Volunteer Email: ${volunteer['Volunteer_Email']}',
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Volunteer Nic: ${maskNic(volunteer['Volunteer_Nic'])}',
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Volunteer Phone: ${volunteer['Volunteer_Phone']}',
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.only(right: 20),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => UpdateVolunteer(
                                    volunteerKey: volunteer['key'])));
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
                                  reference.child(volunteer['key']).remove();
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
                ),
              )
            ],
          )),
    );
  }

  String maskNic(String nic) {
    return nic.substring(0, 4) +
        '*' * (nic.length - 5) +
        nic.substring(nic.length - 1);
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
                  hintText: "Search a Volunteer By Name",
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchResults = [];
                    if (value.isNotEmpty) {
                      _searchQuery = dbRef
                          .orderByChild('Volunteer_Name')
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
                  Map volunteer = snapshot.value as Map;
                  volunteer['key'] = snapshot.key;
                  if (_searchController.text.isNotEmpty &&
                      !volunteer['Volunteer_Name']
                          .toLowerCase()
                          .contains(_searchController.text.toLowerCase())) {
                    return Container();
                  }
                  // Add the filtered volunteer to the search results list
                  _searchResults.add(volunteer);
                  return listItem(volunteer: volunteer);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
