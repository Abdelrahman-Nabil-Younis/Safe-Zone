import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'admin_view.dart';
import 'home.dart';
import 'onboarding.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Initialize Firebase
  await Firebase.initializeApp();
  // Save the notification to SharedPreferences
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String>? messagesJson = prefs.getStringList('notifications') ?? [];
  messagesJson.insert(0, jsonEncode(message.toMap()));
  await prefs.setStringList('notifications', messagesJson);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Set up background message handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFFF86C1D)),
        useMaterial3: true,
      ),
      home: AuthenticationWrapper(),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Image.asset('assets/loading.png'), // Loading image
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error fetching authentication state'));
        } else {
          final User? user = snapshot.data;
          if (user == null) {
            // User is signed out, navigate to the onboarding screen
            return OnboardingScreen();
          } else {
            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .get(),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Image.asset('assets/loading.png'), // Loading image
                  );
                } else if (!userSnapshot.hasData ||
                    !userSnapshot.data!.exists) {
                  return Center(child: Text('User document not found!'));
                } else {
                  final bool isAdmin =
                      userSnapshot.data!.get('isAdmin') ?? false;
                  if (isAdmin) {
                    return AdminView();
                  } else {
                    return HomeScreen();
                  }
                }
              },
            );
          }
        }
      },
    );
  }
}

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage>
    with AutomaticKeepAliveClientMixin {
  late FirebaseMessaging _messaging;
  List<RemoteMessage> _messages = [];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _messaging = FirebaseMessaging.instance;

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      setState(() {
        _messages.add(message);
        _saveNotifications();
      });
    });

    _loadNotifications();

    _messaging.getToken().then((token) {
      print("FCM Token: $token");
      // Send this token to your server
    });
  }

  void _loadNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? messagesJson = prefs.getStringList('notifications');
    if (messagesJson != null) {
      setState(() {
        _messages = messagesJson
            .map((json) => RemoteMessage.fromMap(jsonDecode(json)))
            .toList();
      });
    }
  }

  void _saveNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> messagesJson =
        _messages.map((message) => jsonEncode(message.toMap())).toList();
    await prefs.setStringList('notifications', messagesJson);
  }
}
