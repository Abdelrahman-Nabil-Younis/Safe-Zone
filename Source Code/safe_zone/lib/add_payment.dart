import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for LengthLimitTextInputFormatter

class AddPayment extends StatefulWidget {
  final Function(String) onCardAdded;

  AddPayment({required this.onCardAdded});

  @override
  _AddPaymentMethodPageState createState() => _AddPaymentMethodPageState();
}

class _AddPaymentMethodPageState extends State<AddPayment> {
  late String _selectedMonth = 'January';
  late String _selectedYear = '2024';

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  final _formKey = GlobalKey<FormState>(); // Key for the Form widget

  String? _validateCardNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter card number';
    }
    // Add your validation logic here
    // Return null if the value is valid, otherwise return an error message
    return null;
  }

  String? _validateCVV(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter CVV';
    }
    // Add your validation logic here
    // Return null if the value is valid, otherwise return an error message
    return null;
  }

  void _addCard() {
    final card =
        '**** **** **** ${_cardNumberController.text.substring(_cardNumberController.text.length - 4)}';
    widget.onCardAdded(card);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text(''), // Empty title to center the text
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(32.5),
              child: Form(
                key: _formKey, // Assign the form key
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Center(
                      child: Text(
                        'Add Payment Method',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFFF76B1C),
                          fontSize: 24, // Increased font size
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w700,
                          height: 1.0,
                          letterSpacing: -0.41,
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: 'Name on card',
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color(0xFFF76B1C)), // Orange border color
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey, // Grey hint text color
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      style: TextStyle(
                          color: Colors
                              .black), // Black text color when user writes
                    ),
                    SizedBox(height: 30),
                    TextFormField(
                      controller: _cardNumberController,
                      decoration: InputDecoration(
                        hintText: 'Card number',
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color(0xFFF76B1C)), // Orange border color
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey, // Grey hint text color
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                          color: Colors
                              .black), // Black text color when user writes
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(
                            16), // Limit input to 16 characters
                      ],
                      validator: _validateCardNumber,
                    ),
                    SizedBox(height: 30),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Month'),
                              SizedBox(height: 10),
                              Container(
                                width: double.infinity,
                                height: 55,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white,
                                  border: Border.all(
                                      color: Color(
                                          0xFFF76B1C)), // Orange border color
                                ),
                                child: DropdownButton<String>(
                                  value: _selectedMonth,
                                  onChanged: (newValue) {
                                    setState(() {
                                      _selectedMonth = newValue!;
                                    });
                                  },
                                  items: [
                                    'January',
                                    'February',
                                    'March',
                                    'April',
                                    'May',
                                    'June',
                                    'July',
                                    'August',
                                    'September',
                                    'October',
                                    'November',
                                    'December'
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 22),
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          value,
                                          style: TextStyle(
                                            color: Colors
                                                .black, // Black text color
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Year'),
                              SizedBox(height: 10),
                              Container(
                                width: double.infinity,
                                height: 55,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white,
                                  border: Border.all(
                                      color: Color(
                                          0xFFF76B1C)), // Orange border color
                                ),
                                child: DropdownButton<String>(
                                  value: _selectedYear,
                                  onChanged: (newValue) {
                                    setState(() {
                                      _selectedYear = newValue!;
                                    });
                                  },
                                  items: [
                                    '2024',
                                    '2025',
                                    '2026',
                                    '2027',
                                    '2028',
                                    '2029',
                                    '2030',
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16),
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          value,
                                          style: TextStyle(
                                            color: Colors
                                                .black, // Black text color
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    TextFormField(
                      controller: _cvvController,
                      decoration: InputDecoration(
                        hintText: 'CVV',
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color(0xFFF76B1C)), // Orange border color
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey, // Grey hint text color
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                          color: Colors
                              .black), // Black text color when user writes
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(
                            3), // Limit input to 3 characters
                      ],
                      validator: _validateCVV,
                    ),
                    SizedBox(height: 40),
                    Container(
                      width: 345,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState != null &&
                              _formKey.currentState!.validate() &&
                              _cardNumberController.text.length == 16 &&
                              _cvvController.text.length == 3 &&
                              _nameController.text.isNotEmpty) {
                            _addCard();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: (_formKey.currentState != null &&
                                  _formKey.currentState!.validate() &&
                                  _cardNumberController.text.length == 16 &&
                                  _cvvController.text.length == 3 &&
                                  _nameController.text.isNotEmpty)
                              ? Color(0xFFF76B1C) // Enabled color
                              : Color(0xFFF76B1C), // Disabled color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: const Text(
                          'Add now',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w700,
                            height: 3,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}

void main() {
  runApp(MaterialApp(
    home: AddPayment(onCardAdded: (card) {
      // This is a placeholder callback for demonstration.
      print("Card added: $card");
    }),
  ));
}
