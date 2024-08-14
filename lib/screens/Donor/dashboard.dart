import 'package:flutter/material.dart';
import 'package:project/screens/Donor/insert_data.dart';
import 'package:project/screens/Donor/fetch_data.dart';
import 'package:project/screens/Authentication/home_page.dart';

class DonorHomePage extends StatefulWidget {
  const DonorHomePage({Key? key}) : super(key: key);

  @override
  State<DonorHomePage> createState() => _DonorHomePageState();
}

class _DonorHomePageState extends State<DonorHomePage> {
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
              'Donor Dashboard',
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
              'assets/donor.jpg',
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
                        builder: (context) => const InsertData()));
              },
              color: Colors.blue,
              textColor: Colors.white,
              minWidth: 300,
              height: 40,
              child: const Text('Insert Donor Details'),
            ),
            const SizedBox(
              height: 20,
            ),
            MaterialButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const FetchData()));
              },
              color: Colors.blue,
              textColor: Colors.white,
              minWidth: 300,
              height: 40,
              child: const Text('View Donor Details'),
            ),
          ],
        ),
      ),
    );
  }
}
