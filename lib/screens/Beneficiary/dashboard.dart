import 'package:flutter/material.dart';
import 'package:project/screens/Beneficiary/insert_data.dart';
import 'package:project/screens/Beneficiary/fetch_data.dart';
import 'package:project/screens/Authentication/home_page.dart';

class BeneficiaryHomePage extends StatefulWidget {
  const BeneficiaryHomePage({Key? key}) : super(key: key);

  @override
  State<BeneficiaryHomePage> createState() => _BeneficiaryHomePageState();
}

class _BeneficiaryHomePageState extends State<BeneficiaryHomePage> {
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
              'Beneficiary Dashboard',
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
              'assets/beneficiary.jpg',
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
                child: const Text('Insert Beneficiary Details')),
            const SizedBox(
              height: 20,
            ),
            MaterialButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const FetchData()));
                },
                color: Colors.blue,
                textColor: Colors.white,
                minWidth: 300,
                height: 40,
                child: const Text('View Beneficiary Details')),
          ],
        ),
      ),
    );
  }
}
