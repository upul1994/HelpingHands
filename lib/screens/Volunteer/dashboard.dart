import 'package:flutter/material.dart';
import 'package:project/screens/Volunteer/insert_data.dart';
import 'package:project/screens/Volunteer/fetch_data.dart';
import 'package:project/screens/Authentication/home_page.dart';

class VolunteerHomePage extends StatefulWidget {
  const VolunteerHomePage({Key? key}) : super(key: key);

  @override
  State<VolunteerHomePage> createState() => _VolunteerHomePageState();
}

class _VolunteerHomePageState extends State<VolunteerHomePage> {
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Volunteers Dashboard',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20,
            ),
            Image.asset(
              'assets/volunteer.jpg',
              height: 300,
              width: 300,
            ),
            const SizedBox(
              height: 20,
            ),
            MaterialButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const InsertVolunteer()));
              },
              color: Colors.blue,
              textColor: Colors.white,
              minWidth: 300,
              height: 40,
              child: const Text('Insert Volunteer Details'),
            ),
            const SizedBox(
              height: 20,
            ),
            MaterialButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FetchVolunteer()));
              },
              color: Colors.blue,
              textColor: Colors.white,
              minWidth: 300,
              height: 40,
              child: const Text('View Volunteer Details'),
            ),
          ],
        ),
      ),
    );
  }
}
