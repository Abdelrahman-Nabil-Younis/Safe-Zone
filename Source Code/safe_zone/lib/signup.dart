import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Added Firestore import
import 'package:safe_zone/login.dart';
import 'home.dart';
import 'terms_and_conditions.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SignUpScreen(),
    );
  }
}

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _isChecked = false;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  late TextEditingController _birthdateController;
  late TextEditingController _firstNameController;
  late TextEditingController _secondNameController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _areaController; // New controller for area
  late TextEditingController _streetController; // New controller for street
  late String _selectedGender = 'Male';
  late String _selectedCity = 'Cairo';
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _birthdateController = TextEditingController();
    _firstNameController = TextEditingController();
    _secondNameController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _areaController = TextEditingController(); // Initialize area controller
    _streetController = TextEditingController(); // Initialize street controller
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _birthdateController.dispose();
    _firstNameController.dispose();
    _secondNameController.dispose();
    _phoneNumberController.dispose();
    _areaController.dispose(); // Dispose of area controller
    _streetController.dispose(); // Dispose of street controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 48),
              Text(
                'Sign up',
                style: TextStyle(
                  color: Color(0xFFF86C1D),
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Roboto Serif',
                ),
              ),
              SizedBox(height: 24),
              Text(
                'Find your dream park!',
                style: TextStyle(
                  color: Color(0xFF040415),
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Roboto Serif',
                ),
              ),
              InputField(
                labelText: 'First Name',
                iconData: Icons.person,
                controller: _firstNameController,
              ),
              InputField(
                labelText: 'Second Name',
                iconData: Icons.person,
                controller: _secondNameController,
              ),
              InputField(
                labelText: 'Email',
                iconData: Icons.email,
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              InputField(
                labelText: 'Phone Number',
                iconData: Icons.phone,
                controller: _phoneNumberController,
              ),
              InputField(
                labelText: 'Password',
                iconData: Icons.lock,
                controller: _passwordController,
                isPassword: true,
              ),
              InputField(
                labelText: 'Confirm Password',
                iconData: Icons.lock,
                controller: _confirmPasswordController,
                isPassword: true,
              ),
              DropdownField(
                labelText: 'Gender',
                iconData: Icons.person,
                value: _selectedGender,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedGender = newValue!;
                  });
                },
                items: <String>['Male', 'Female']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              GestureDetector(
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    setState(() {
                      _birthdateController.text = picked.day.toString() +
                          '/' +
                          picked.month.toString() +
                          '/' +
                          picked.year.toString();
                    });
                  }
                },
                child: InputField(
                  labelText: 'Birthdate',
                  iconData: Icons.cake,
                  controller: _birthdateController,
                  enabled: false,
                ),
              ),
              DropdownField(
                labelText: 'City',
                iconData: Icons.location_city,
                value: _selectedCity,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCity = newValue!;
                  });
                },
                items: <String>['Cairo', 'Alexandria', 'Luxor', 'Aswan']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              InputField(
                  labelText: 'Area',
                  iconData: Icons.location_on,
                  controller: _areaController), // Add area input field
              InputField(
                  labelText: 'Street',
                  iconData: Icons.location_on,
                  controller: _streetController), // Add street input field
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  if (_isInputValid()) {
                    try {
                      final credential = await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                        email: _emailController.text,
                        password: _passwordController.text,
                      );

                      // Log in the user immediately after sign-up
                      await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: _emailController.text,
                        password: _passwordController.text,
                      );

                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(credential.user!.uid)
                          .set({
                        'email': _emailController.text,
                        'firstName': _firstNameController.text,
                        'secondName': _secondNameController.text,
                        'phoneNumber': _phoneNumberController.text,
                        'gender': _selectedGender,
                        'birthdate': _birthdateController.text,
                        'city': _selectedCity,
                        'area': _areaController.text,
                        'street': _streetController.text,
                        'isAdmin': false,
                        'profileImgUrl': '',
                        'coverImgUrl': '',
                      });
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'weak-password') {
                        setState(() {
                          _errorMessage = 'The password provided is too weak.';
                        });
                      } else if (e.code == 'email-already-in-use') {
                        setState(() {
                          _errorMessage =
                              'The account already exists for that email.';
                        });
                      }
                    } catch (e) {
                      print(e);
                    }
                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Color(0xFFF86C1D)),
                  elevation: MaterialStateProperty.all(4),
                  minimumSize: MaterialStateProperty.all(Size(360, 56)),
                ),
                child: Text(
                  'Sign Up',
                  style: TextStyle(
                    color: Color(0xFFFBFBFB),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
                    style: TextStyle(
                      color: Color(0xFF040415),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                        // Remove all routes from the stack
                      );
                    },
                    child: Text(
                      'Log In',
                      style: TextStyle(
                        color: Color(0xFFF86C1D),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TermsAndConditionsPage()),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Terms & Conditions ',
                      style: TextStyle(
                        color: Color(0xFFF86C1D),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward,
                      color: Color(0xFFF86C1D),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                    value: _isChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        _isChecked = value ?? false;
                      });
                    },
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    checkColor: Colors.white,
                  ),
                  Text(
                    'I agree to the ',
                    style: TextStyle(
                      color: Color(0xFF040415),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TermsAndConditionsPage()),
                      );
                    },
                    child: Text(
                      'Terms & Conditions',
                      style: TextStyle(
                        color: Color(0xFFF86C1D),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _isInputValid() {
    if (_emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty ||
        _birthdateController.text.isEmpty ||
        _firstNameController.text.isEmpty ||
        _secondNameController.text.isEmpty ||
        _phoneNumberController.text.isEmpty) {
      setState(() {
        _errorMessage = 'All fields are required.';
      });
      return false;
    } else if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _errorMessage = 'Passwords do not match.';
      });
      return false;
    } else if (!_isChecked) {
      setState(() {
        _errorMessage = 'Please accept the terms and conditions.';
      });
      return false;
    }
    return true;
  }
}

class InputField extends StatefulWidget {
  final String labelText;
  final IconData iconData;
  final TextEditingController? controller;
  final bool isPassword;
  final TextInputType? keyboardType;
  final bool enabled;

  InputField({
    required this.labelText,
    required this.iconData,
    this.controller,
    this.isPassword = false,
    this.keyboardType,
    this.enabled = true,
  });

  @override
  _InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  late FocusNode _focusNode;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0xFF000000).withOpacity(0.25),
            offset: Offset(0, 4),
            blurRadius: 4,
          ),
        ],
        borderRadius: BorderRadius.circular(8),
        border: _focusNode.hasFocus || _errorMessage.isNotEmpty
            ? Border.all(
                color:
                    _errorMessage.isNotEmpty ? Colors.red : Color(0xFFF86C1D),
              )
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                widget.iconData,
                size: 32,
                color:
                    _focusNode.hasFocus ? Color(0xFFF86C1D) : Color(0xFFA8AFB9),
              ),
              SizedBox(width: 16),
              Expanded(
                child: TextField(
                  focusNode: _focusNode,
                  controller: widget.controller,
                  obscureText: widget.isPassword,
                  keyboardType: widget.keyboardType,
                  enabled: widget.enabled,
                  onChanged: (value) {
                    setState(() {
                      _errorMessage =
                          value.isEmpty ? 'This field is required.' : '';
                    });
                  },
                  decoration: InputDecoration(
                    labelText: widget.labelText,
                    labelStyle: TextStyle(
                      fontSize: _focusNode.hasFocus ? 16 : 14,
                      fontWeight: FontWeight.w500,
                      color: _focusNode.hasFocus
                          ? Color(0xFFF86C1D)
                          : Color(0xFFA8AFB9),
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
          if (_errorMessage.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(left: 48),
              child: Text(
                _errorMessage,
                style: TextStyle(color: Colors.red),
              ),
            ),
        ],
      ),
    );
  }
}

class DropdownField extends StatelessWidget {
  final String labelText;
  final IconData iconData;
  final String? value;
  final Function(String?)? onChanged;
  final List<DropdownMenuItem<String>> items;

  DropdownField({
    required this.labelText,
    required this.iconData,
    this.value,
    this.onChanged,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0xFF000000).withOpacity(0.25),
            offset: Offset(0, 4),
            blurRadius: 4,
          ),
        ],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                iconData,
                size: 32,
                color: Color(0xFFA8AFB9),
              ),
              SizedBox(width: 16),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: value,
                  onChanged: onChanged,
                  items: items,
                  decoration: InputDecoration(
                    labelText: labelText,
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
