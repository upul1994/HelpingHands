import 'package:flutter/material.dart';
import 'package:project/screens/Donation/insert_data.dart';
import 'package:project/screens/Donation/fetch_data.dart';
import 'package:project/screens/Authentication/home_page.dart';

class DonationHomePage extends StatefulWidget {
  const DonationHomePage({Key? key}) : super(key: key);

  @override
  State<DonationHomePage> createState() => _DonationHomePageState();
}

class _DonationHomePageState extends State<DonationHomePage> {
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
              'Donation Dashboard',
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
              'assets/donation.png',
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
                        builder: (context) => const InsertDonationData()));
              },
              color: Colors.blue,
              textColor: Colors.white,
              minWidth: 300,
              height: 40,
              child: const Text('Insert Donation Details'),
            ),
            const SizedBox(
              height: 20,
            ),
            MaterialButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FetchDonationData()));
              },
              color: Colors.blue,
              textColor: Colors.white,
              minWidth: 300,
              height: 40,
              child: const Text('View Donation Details'),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
