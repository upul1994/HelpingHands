import 'package:firebase_auth/firebase_auth.dart';
import 'package:project/screens/Authentication/auth.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:project/screens/Beneficiary/dashboard.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:project/screens/Donation/dashboard.dart';
import 'package:project/screens/Donor/dashboard.dart';
import 'package:project/screens/Volunteer/dashboard.dart';
import 'package:project/screens/Authentication/login_register_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final User? user = Auth().currentUser;

  int activeIndex = 0;
  final controller = CarouselSliderController();
  final urlImages = [
    'assets/images/image1.png',
    'assets/images/image2.png',
    'assets/images/image3.png',
    'assets/images/image4.png',
  ];

  Future<void> signOut() async {
    Auth().signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  Widget _title() {
    return const Text('Helping Hands', style: TextStyle(color: Colors.white));
  }

  Widget _userUid() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        user?.email ?? 'User email',
        style: const TextStyle(
          fontSize: 10.0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _title(),
        actions: <Widget>[
          _userUid(),
        ],
        backgroundColor: Colors.blue,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          signOut();
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.logout_rounded, color: Colors.white),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Helping Hands Charity App',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 30,
            ),
            CarouselSlider.builder(
                carouselController: controller,
                itemCount: urlImages.length,
                itemBuilder: (context, index, realIndex) {
                  final urlImage = urlImages[index];
                  return buildImage(urlImage, index);
                },
                options: CarouselOptions(
                    height: 200,
                    autoPlay: true,
                    enableInfiniteScroll: true,
                    autoPlayAnimationDuration: const Duration(seconds: 2),
                    enlargeCenterPage: true,
                    onPageChanged: (index, reason) =>
                        setState(() => activeIndex = index))),
            const SizedBox(height: 12),
            buildIndicator(),
            const SizedBox(height: 20),
            MaterialButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DonationHomePage()));
              },
              color: Colors.blue,
              textColor: Colors.white,
              minWidth: 300,
              height: 40,
              child: const Text('Donations'),
            ),
            const SizedBox(
              height: 20,
            ),
            MaterialButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DonorHomePage()));
              },
              color: Colors.blue,
              textColor: Colors.white,
              minWidth: 300,
              height: 40,
              child: const Text('Donors'),
            ),
            const SizedBox(
              height: 20,
            ),
            MaterialButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const VolunteerHomePage()));
              },
              color: Colors.blue,
              textColor: Colors.white,
              minWidth: 300,
              height: 40,
              child: const Text('Volunteers'),
            ),
            const SizedBox(
              height: 20,
            ),
            MaterialButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const BeneficiaryHomePage()));
              },
              color: Colors.blue,
              textColor: Colors.white,
              minWidth: 300,
              height: 40,
              child: const Text('Beneficiaries'),
            ),
            const SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildIndicator() => AnimatedSmoothIndicator(
        onDotClicked: animateToSlide,
        effect: const ExpandingDotsEffect(
            dotWidth: 10,
            dotHeight: 8,
            activeDotColor: Color.fromARGB(255, 137, 144, 150)),
        activeIndex: activeIndex,
        count: urlImages.length,
      );

  void animateToSlide(int index) => controller.animateToPage(index);
}

Widget buildImage(String urlImage, int index) => Container(
    margin: const EdgeInsets.symmetric(horizontal: 5),
    child: Image.asset(urlImage, fit: BoxFit.cover));
