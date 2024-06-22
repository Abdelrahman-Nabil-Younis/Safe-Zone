import 'package:flutter/material.dart';

class Cam extends StatefulWidget {
  @override
  _CamState createState() => _CamState();
}

class _CamState extends State<Cam> {
  // Text editing controllers for user input
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();

  // Flag to track if terms and conditions are accepted
  bool _termsAccepted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/head.png',
              height: 3000,
              width: 260,
            ),
          ],
        ),
        backgroundColor: Color.fromARGB(164, 255, 214, 220),
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(164, 255, 214, 220),
              Color.fromARGB(255, 255, 255, 255)
            ], // Lighter orange gradient
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 20),
                Center(
                  child: Text(
                    'Log in to Camera Feed',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 0, 0, 0),
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'User Name',
                    labelStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: const Color.fromARGB(255, 0, 0, 0)),
                    ),
                  ),
                  style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle:
                        TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: const Color.fromARGB(255, 0, 0, 0)),
                    ),
                  ),
                  style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle:
                        TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: const Color.fromARGB(255, 0, 0, 0)),
                    ),
                  ),
                  style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                ),
                SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    Checkbox(
                      value: _termsAccepted,
                      onChanged: (value) =>
                          setState(() => _termsAccepted = value!),
                      activeColor: const Color.fromARGB(255, 0, 0, 0),
                    ),
                    Flexible(
                      child: Text(
                        'I Agree to the Terms of Service and Privacy Policy',
                        style: TextStyle(
                            color: const Color.fromARGB(255, 0, 0, 0)),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _termsAccepted ? _login : null,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Color.fromARGB(255, 0, 0, 0),
                    backgroundColor:
                        Color.fromARGB(255, 255, 231, 231), // Text color
                  ),
                  child: Text('Log In'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _login() {
    // Add your login logic here
    print('Logging in user...');
    // Navigate to the camera feed screen
  }

  String? _selectedCountry;
}

void main() {
  runApp(MaterialApp(
    home: Cam(),
  ));
}
