import 'package:flutter/material.dart';
import 'login.dart'; // Import the LoginPage widget from login.dart

void main() {
  runApp(MaterialApp(
    home: OnboardingScreen(),
  ));
}

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  final List<Map<String, String>> pages = [
    {
      'imagePath': 'assets/Parking-bro 1.png',
      'text':
          'Welcome to Safe Zone, the ultimate app for all your vehicle service and parking needs!\n\nWe understand that when you\'re traveling, you want the peace of mind knowing that your vehicle is in safe hands. That\'s why we\'ve designed an innovative platform that combines convenience, reliability, and creativity to provide you with top-notch services.',
    },
    {
      'imagePath': 'assets/Car_wash-bro_1.png',
      'text':
          'At Safe Zone, we believe that servicing your vehicle should be a hassle-free experience.\n\nWith just a few taps on our app, you can easily book a wide range of vehicle services, including routine maintenance, repairs, and even customization options. Our team of highly skilled technicians and mechanics are dedicated to delivering exceptional quality workmanship, ensuring that your vehicle receives the care it deserves.',
    },
    {
      'imagePath': 'assets/Parking-amico 1.png',
      'text':
          'But that\'s not all we offer.\nWe understand that finding secure parking spaces for your vehicle can be a daunting task, especially when you\'re away for an extended period.\n\nWith our long-term parking system, keep your vehicle safe and secure while you\'re traveling. Our state-of-the-art facilities are equipped with advanced security measures, including 24/7 surveillance, to give you peace of mind throughout your journey.',
    },
  ];
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: PageView.builder(
              controller: _pageController,
              itemCount: pages.length,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              itemBuilder: (context, index) {
                return OnboardingPage(
                  imagePath: pages[index]['imagePath']!,
                  text: pages[index]['text']!,
                );
              },
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              pages.length,
              (index) => Container(
                margin: EdgeInsets.symmetric(horizontal: 4),
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentPage == index ? Colors.orange : Colors.grey,
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      LoginPage(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    var begin = 0.0;
                    var end = 1.0;
                    var curve = Curves.easeInOut;

                    var tween = Tween(begin: begin, end: end).chain(
                      CurveTween(curve: curve),
                    );

                    return FadeTransition(
                      opacity: animation.drive(tween),
                      child: child,
                    );
                  },
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.orange, // Button color
            ),
            child: Text('Login'),
          ),
        ],
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String imagePath;
  final String text;

  OnboardingPage({
    required this.imagePath,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          flex: 3,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Image.asset(imagePath),
          ),
        ),
        Flexible(
          flex: 2,
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              text,
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'Roboto Serif',
                fontSize: 16, // Adjusted font size
                fontWeight: FontWeight.w700,
                height: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
