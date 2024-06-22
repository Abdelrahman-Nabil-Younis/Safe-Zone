import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:safe_zone/admin_received_notifications.dart';
import 'users.dart';
import 'cars.dart';
import 'profile.dart';
import 'admin_notifications.dart';

class AdminView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin View'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'SAFE ZONE',
                style: TextStyle(
                  color: Color(0xFFF86C1D),
                  fontFamily: 'Poppins',
                  fontSize: 24.0,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.408,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 17.0),
              Text(
                "Admin View",
                style: TextStyle(
                  color: Color(0xFF040415),
                  fontFamily: 'Poppins',
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.0), // Adjusted spacing
              _buildFrame(context, 'Users', Users()),
              SizedBox(height: 30.0), // Adjusted spacing
              _buildFrame(context, 'Cars', Cars()),
              SizedBox(height: 30.0), // Adjusted spacing
              _buildFrame(
                  context, 'Send Notifications', AdminNotificationPage()),
              SizedBox(height: 30.0), // Adjusted spacing
              _buildFrame(context, 'Profile', ProfilePage()),
              SizedBox(height: 30.0), // Adjusted spacing
              _buildFrame(context, 'Notifications',
                  AdminReceivedNotifications()), // New frame for Notifications
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFrame(BuildContext context, String title, Widget page) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Container(
        width: 330.0,
        height: 140.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
          color: Color(0xFFFF5C00),
          border: Border.all(
            color: Colors.black,
            width: 2.0,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              left: 13.0,
              top: 10.0,
              child: Container(
                width: 20.0,
                height: 30.0,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
                child: Icon(
                  Icons.arrow_forward,
                  size: 26.0,
                  color: Color(0xFF1E232C),
                ),
              ),
            ),
            Center(
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Poppins',
                  fontSize: 32.0,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: AdminView(),
  ));
}
