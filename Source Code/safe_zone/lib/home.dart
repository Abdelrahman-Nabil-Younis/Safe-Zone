import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:safe_zone/cam.dart';
import 'my_cars.dart';
import 'profile.dart';
import 'packages.dart';
import 'add_car.dart';
import 'services.dart';
import 'notifications.dart';
import 'my_reservations.dart'; // Import MyReservations screen
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher package

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Define routes
      routes: {
        '/my_cars': (context) => MyCars(),
        // Add other routes as needed
      },
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SAFE ZONE',
          style: TextStyle(
            color: Color(0xFFF76B1C),
            fontSize: 24,
            fontFamily: 'Roboto Serif',
            fontWeight: FontWeight.w600,
            height: 0.5,
            letterSpacing: -0.41,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () async {
              final user = FirebaseAuth.instance.currentUser;
              if (user != null) {
                final userId = user.uid;
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    transitionDuration: Duration(milliseconds: 500),
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        NotificationsPage(
                      userId: userId,
                    ),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      var begin = Offset(1.0, 0.0);
                      var end = Offset.zero;
                      var curve = Curves.easeInOutQuart;
                      var tween = Tween(begin: begin, end: end)
                          .chain(CurveTween(curve: curve));
                      var offsetAnimation = animation.drive(tween);
                      return SlideTransition(
                        position: offsetAnimation,
                        child: child,
                      );
                    },
                  ),
                );
              }
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: StreamBuilder<DocumentSnapshot>(
          stream: _userInfoStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData && snapshot.data != null) {
              final userData = snapshot.data!;
              final firstName = userData['firstName'] ?? '';
              final secondName = userData['secondName'] ?? '';
              final email = userData['email'] ?? '';
              final profileImgUrl = userData['profileImgUrl'] ?? '';

              return ListView(
                children: [
                  UserAccountsDrawerHeader(
                    accountName: Text('$firstName $secondName'),
                    accountEmail: Text(email),
                    currentAccountPicture: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey,
                      backgroundImage: profileImgUrl.isNotEmpty
                          ? NetworkImage(profileImgUrl)
                          : null,
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xFFF76B1C),
                    ),
                  ),
                  // Add divider
                  ListTile(
                    title: const Text(
                      'Profile',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontFamily: 'Roboto Serif',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Profile()),
                      );
                    },
                  ),
                  const Divider(), // Add divider
                  ListTile(
                    title: const Text(
                      'Home',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontFamily: 'Roboto Serif',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onTap: () {
                      Navigator.popUntil(context, ModalRoute.withName('/'));
                    },
                  ),
                  const Divider(), // Add divider
                  ListTile(
                    title: const Text(
                      'My Cars', // Add My Cars option
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontFamily: 'Roboto Serif',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyCars(),
                        ),
                      );
                    },
                  ),
                  const Divider(), // Add divider
                  ListTile(
                    title: const Text(
                      'Live Camera', // Add Live Camera option
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontFamily: 'Roboto Serif',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Cam(),
                        ),
                      );
                    },
                  ),
                  const Divider(), // Add divider
                  ListTile(
                    title: const Text(
                      'Add Vehicle',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontFamily: 'Roboto Serif',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddCar()),
                      );
                    },
                  ),
                  const Divider(), // Add divider
                  ListTile(
                    title: const Text(
                      'Services',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontFamily: 'Roboto Serif',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Services()),
                      );
                    },
                  ),
                  const Divider(), // Add divider
                  ListTile(
                    title: const Text(
                      'Packages',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontFamily: 'Roboto Serif',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Packages()),
                      );
                    },
                  ),
                  const Divider(), // Add divider
                  ListTile(
                    title: const Text(
                      'My Reservations', // Add My Reservations option
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontFamily: 'Roboto Serif',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyReservations()),
                      );
                    },
                  ),
                  const Divider(), // Add divider
                  ListTile(
                    title: const Text(
                      'Contact Us', // Add Contact Us option
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontFamily: 'Roboto Serif',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onTap: () async {
                      const phoneNumber = '01018843770';
                      final Uri launchUri = Uri(
                        scheme: 'tel',
                        path: phoneNumber,
                      );
                      if (await canLaunchUrl(launchUri)) {
                        await launchUrl(launchUri);
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Error'),
                              content: Text(
                                  'Failed to launch the dialer. Please try again later.'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                  ),
                  const Divider(), // Add divider
                  ListTile(
                    title: const Text(
                      'Logout',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontFamily: 'Roboto Serif',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onTap: () async {
                      bool confirmLogout = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Confirm Logout'),
                            content: Text('Are you sure you want to log out?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                },
                                child: Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(true);
                                },
                                child: Text('Logout'),
                              ),
                            ],
                          );
                        },
                      );

                      if (confirmLogout == true) {
                        await FirebaseAuth.instance.signOut();
                        Navigator.pop(context);
                      }
                    },
                  ),
                  const Divider(),
                ],
              );
            } else {
              return SizedBox.shrink();
            }
          },
        ),
      ),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/background.jpg',
              fit: BoxFit.cover,
              color: Colors.white.withOpacity(0.8),
              colorBlendMode: BlendMode.hardLight,
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Packages()),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF76B1C),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      width: 300,
                      height: 220,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Image.asset(
                              'assets/pack.jpg',
                              width: 300,
                              height: 189,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 0),
                          const Text(
                            'Packages',
                            style: TextStyle(
                              fontFamily: "Roboto Serif",
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Services()),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF76B1C),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      width: 300,
                      height: 220,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Image.asset(
                              'assets/serv.jpg',
                              width: 300,
                              height: 189,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 0),
                          const Text(
                            'Services',
                            style: TextStyle(
                              fontFamily: "Roboto Serif",
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Stream<DocumentSnapshot> _userInfoStream() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .snapshots();
    }
    throw Exception('User not found');
  }
}
